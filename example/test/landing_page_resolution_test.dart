// Run with: flutter test --platform chrome
//
// The browser platform is required because package:fframe exports the web-only
// google_sign_in_web library, so the example app cannot compile for the VM
// test platform.
@TestOn('browser')
library;

// Tests the end-user routing behaviour of the example app for users with
// limited roles: which page a signed-in user lands on, and what they see when
// they deep-link to a page they cannot access or that does not exist.
//
// These tests run the example app's real navigation configuration through the
// same initialisation sequence Fframe uses after sign-in (FRouterConfig role
// filtering -> NavigationNotifier -> TargetState), with FFrameUser instances
// standing in for Firebase-authenticated users. No Firebase services are
// required.

import 'package:example/screens/signInPage/signin_page.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'example_router_harness.dart';

/// Renders what the end user would see in the content pane for [target].
Future<void> pumpTarget(WidgetTester tester, NavigationTarget target) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: target.contentPane)),
  );
}

void main() {
  setUpAll(() {
    // Console.instance.logThreshold is `late`; initialise it once like
    // main.dart does, but keep the test output quiet.
    Console(logThreshold: LogLevel.prod);
  });

  group("Landing page resolution for signed-in users", () {
    test("user whose roles grant the landing page but none of its tabs lands on the page itself", () {
      // The 'suggestions' landing page requires role 'user'; its tabs require
      // 'developer'/'nobody'. With only 'user' the tabs are filtered away and
      // the landing page itself must be the default route (this previously
      // fell through to the error page).
      initRouterFor(FFrameUser(uid: "test", email: "user@example.com", roles: ["user"]));

      expect(TargetState.instance.defaultRoute.path, "/suggestions");
    });

    test("user whose roles grant the landing page tabs lands on the first tab", () {
      initRouterFor(FFrameUser(uid: "test", email: "dev@example.com", roles: ["developer"]));

      expect(TargetState.instance.defaultRoute.path, "/suggestions/active");
    });

    testWidgets("user with roles but no accessible landing page sees the 'no landing page' message", (WidgetTester tester) async {
      // 'useradmin' can access /users (among others), but none of those
      // targets is flagged as a landing page.
      initRouterFor(FFrameUser(uid: "test", email: "admin@example.com", roles: ["useradmin"]));

      final NavigationTarget resolved = TargetState.instance.defaultRoute;
      expect(resolved.path, "/fframe-no-landing-page");

      await pumpTarget(tester, resolved);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.text("No landing page configured"), findsOneWidget);
      expect(find.textContaining("contact your administrator"), findsOneWidget);
    });

    test("user without any roles gets the 'no landing page' fallback instead of a blank screen", () {
      initRouterFor(FFrameUser(uid: "test", email: "norole@example.com", roles: <String>[]));

      expect(TargetState.instance.defaultRoute.path, "/fframe-no-landing-page");
    });

    test("signed-out visitor is routed to the sign-in page", () {
      initRouterFor(null);

      expect(TargetState.instance.defaultRoute.path, signInPageNavigationTarget.path);
    });
  });

  group("Deep links for signed-in users with limited roles", () {
    testWidgets("deep link to an existing page the user cannot access shows the 'no access' message", (WidgetTester tester) async {
      initRouterFor(FFrameUser(uid: "test", email: "admin@example.com", roles: ["useradmin"]));

      TargetState.instance.fromUri(NavigationNotifier.instance, Uri.parse("/suggestions"));

      final NavigationTarget resolved = TargetState.instance.navigationTarget;
      expect(resolved.path, "/fframe-no-access");

      await pumpTarget(tester, resolved);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text("No access"), findsOneWidget);
      expect(find.textContaining("don't have access rights"), findsOneWidget);
    });

    testWidgets("deep link to an unknown URL shows the example app's error page", (WidgetTester tester) async {
      initRouterFor(FFrameUser(uid: "test", email: "admin@example.com", roles: ["useradmin"]));

      TargetState.instance.fromUri(NavigationNotifier.instance, Uri.parse("/does-not-exist"));

      final NavigationTarget resolved = TargetState.instance.navigationTarget;
      expect(resolved.title, "error");

      await pumpTarget(tester, resolved);
      expect(find.text("Something failed succesfully"), findsOneWidget);

      // Unmount the ErrorPage so its periodic timer is cancelled before the
      // test ends.
      await tester.pumpWidget(const SizedBox.shrink());
    });

    test("deep link to a page the user does have access to routes normally", () {
      initRouterFor(FFrameUser(uid: "test", email: "admin@example.com", roles: ["useradmin"]));

      TargetState.instance.fromUri(NavigationNotifier.instance, Uri.parse("/users"));

      expect(TargetState.instance.navigationTarget.path, "/users");
    });
  });
}
