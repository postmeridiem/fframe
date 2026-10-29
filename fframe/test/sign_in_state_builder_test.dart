import 'dart:async';

import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards how fframe waits for Firebase's first sign-in state at a page load.
///
/// Before the first report the user is unknown, not signed out. If the sign-in page showed then,
/// an app's silent Google sign-in would sign a signed-in user in to Firebase again, and Firestore
/// would restart every running read.
///
/// [_FakeAuth] sends the sign-in state the way FlutterFire web does (firebase_auth_web 6.3.0): each
/// call returns a new stream, which waits until Firebase has restored the saved user, sends that
/// user first, and then each change. The screens are stand-in texts, so the tests run without
/// Firebase. The harness calls authStateChanges() in build, as fframe did before.
void main() {
  group('at a page load', () {
    testWidgets('shows the wait page until Firebase reports the sign-in state', (WidgetTester tester) async {
      final _App app = _App(tester);
      await app.start();
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('wait'), findsOneWidget);
      expect(app.screens.built, isEmpty);
    });

    testWidgets('a signed-in user goes straight to the app: the sign-in page is never built', (WidgetTester tester) async {
      final _App app = _App(tester);
      await app.start();
      app.auth.restore(_FakeUser('u1'));
      await app.settle();
      expect(find.text('app u1'), findsOneWidget);
      expect(app.screens.built.where((AsyncSnapshot<User?> snapshot) => !snapshot.hasData), isEmpty);
    });

    testWidgets('a user who is not signed in gets the sign-in page', (WidgetTester tester) async {
      final _App app = _App(tester);
      await app.start();
      app.auth.restore(null);
      await app.settle();
      expect(find.text('sign-in'), findsOneWidget);
    });
  });

  group('after the first report', () {
    testWidgets('a sign-in from the sign-in page shows the app', (WidgetTester tester) async {
      final _App app = _App(tester);
      await app.start();
      app.auth.restore(null);
      await app.settle();
      expect(find.text('sign-in'), findsOneWidget);
      app.auth.change(_FakeUser('u1'));
      await app.settle();
      expect(find.text('app u1'), findsOneWidget);
    });

    testWidgets('a sign-out shows the sign-in page, not the wait page', (WidgetTester tester) async {
      final _App app = _App(tester);
      await app.start();
      app.auth.restore(_FakeUser('u1'));
      await app.settle();
      expect(find.text('app u1'), findsOneWidget);
      final int waits = app.screens.waits;
      app.auth.change(null);
      await app.settle();
      expect(find.text('sign-in'), findsOneWidget);
      expect(app.screens.waits, waits);
    });

    testWidgets('an error from Firebase reaches the builder', (WidgetTester tester) async {
      final _App app = _App(tester);
      await app.start();
      app.auth.restore(_FakeUser('u1'));
      await app.settle();
      expect(find.text('app u1'), findsOneWidget);
      app.auth.fail(StateError('network'));
      await app.settle();
      expect(find.text('error'), findsOneWidget);
    });
  });

  group('rebuilds', () {
    testWidgets('subscribe once and never go back to the wait page', (WidgetTester tester) async {
      // A new subscription would start over in waiting and swap the running app for the wait page.
      final _App app = _App(tester);
      await app.start();
      await app.start();
      expect(find.text('wait'), findsOneWidget);
      app.auth.restore(_FakeUser('u1'));
      await app.settle();
      expect(find.text('app u1'), findsOneWidget);
      final int waits = app.screens.waits;
      await app.start();
      await app.start();
      expect(find.text('app u1'), findsOneWidget);
      expect(app.screens.waits, waits);
      expect(app.auth.subscriptions, 1);
    });
  });
}

/// One test's app: the fake auth, the screens, and the harness that shows them.
///
/// Made inside each test. testWidgets runs on a fake clock, and a future made in setUp completes
/// outside it, so the first report would never arrive.
class _App {
  _App(this.tester);

  final WidgetTester tester;
  final _FakeAuth auth = _FakeAuth();
  final _Screens screens = _Screens();

  /// Pumps the harness. A second call rebuilds it, which calls authStateChanges() again.
  Future<void> start() => tester.pumpWidget(_Harness(auth: auth, screens: screens));

  /// Shows a report on screen. It arrives in microtasks that run after the frame of a plain pump.
  Future<void> settle() => tester.pumpAndSettle();
}

/// The app's screens as texts, and what the builder was given.
class _Screens {
  int waits = 0;
  final List<AsyncSnapshot<User?>> built = [];

  Widget wait(BuildContext context) {
    waits++;
    return const Text('wait');
  }

  Widget build(BuildContext context, AsyncSnapshot<User?> snapshot) {
    built.add(snapshot);
    if (snapshot.hasError) return const Text('error');
    if (!snapshot.hasData) return const Text('sign-in');
    return Text('app ${snapshot.data!.uid}');
  }
}

class _Harness extends StatelessWidget {
  const _Harness({required this.auth, required this.screens});

  final _FakeAuth auth;
  final _Screens screens;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SignInStateBuilder(authStateChanges: auth.authStateChanges(), waiting: screens.wait, builder: screens.build),
    );
  }
}

/// Stands in for FirebaseAuth on the web.
class _FakeAuth {
  final Completer<void> _restored = Completer<void>();
  final StreamController<User?> _changes = StreamController<User?>.broadcast();
  User? _currentUser;

  /// How many streams were listened to.
  int subscriptions = 0;

  Stream<User?> authStateChanges() async* {
    subscriptions++;
    await _restored.future;
    yield _currentUser;
    yield* _changes.stream;
  }

  /// Firebase has read the saved sign-in state: [user], or null when no user is signed in.
  void restore(User? user) {
    _currentUser = user;
    _restored.complete();
  }

  void change(User? user) {
    _currentUser = user;
    _changes.add(user);
  }

  void fail(Object error) => _changes.addError(error);
}

class _FakeUser implements User {
  _FakeUser(this.uid);

  @override
  final String uid;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
