import 'dart:async';

import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards how [DocumentOpener] opens a document by id in the DocumentScreen on screen.
///
/// A real DocumentScreen reads the document from Firestore, so these tests drive a
/// stand-in screen that registers the way `DocumentScreenLoader` does: in initState,
/// with a reader that takes the config from `widget` when it runs, and that
/// unregisters in dispose. The reader records which config read which id, and its
/// open callback records which config opened which id.
///
/// The board around it can rebuild the screen in two ways. Today each rebuild makes
/// a new screen (a new State), because DocumentScreen makes a new form key on each
/// build. Later the screen may be kept and get the new config through its widget.
/// The opener must give the latest config in both cases.
void main() {
  setUpAll(() => Console(logThreshold: LogLevel.prod));
  setUp(DocumentOpener.reset);
  tearDown(() => SelectionState.instance.pendingUri = null);

  for (final bool newScreenPerBuild in [true, false]) {
    final String rebuild = newScreenPerBuild ? 'a rebuild makes a new screen' : 'the screen is kept';

    group('when $rebuild', () {
      testWidgets('opens after the frame, with the config of the latest build', (WidgetTester tester) async {
        final _Log log = _Log();
        final GlobalKey<_BoardState> board = GlobalKey<_BoardState>();
        await tester.pumpWidget(_Board(key: board, newScreenPerBuild: newScreenPerBuild, read: log.read));

        // The app switches board and asks for the card in the same event.
        board.currentState!.show('B');
        bool? outcome;
        DocumentOpener.open('c1').then((bool value) => outcome = value);
        expect(log.reads, isEmpty, reason: 'the request waits for the frame');

        await tester.pump();
        expect(log.reads, ['B:c1']);
        expect(log.opened, ['B:c1']);
        expect(outcome, isTrue);
      });

      testWidgets('a rebuild after the open does not open the document again', (WidgetTester tester) async {
        final _Log log = _Log();
        final GlobalKey<_BoardState> board = GlobalKey<_BoardState>();
        await tester.pumpWidget(_Board(key: board, newScreenPerBuild: newScreenPerBuild, read: log.read));

        DocumentOpener.open('c1');
        await tester.pump();
        board.currentState!.show('B');
        await tester.pump();
        board.currentState!.show('C');
        await tester.pump();
        expect(log.reads, ['A:c1']);
        expect(log.opened, ['A:c1']);
      });
    });
  }

  testWidgets('asks for a frame when nothing else changed', (WidgetTester tester) async {
    final _Log log = _Log();
    await tester.pumpWidget(_Board(newScreenPerBuild: true, read: log.read));
    expect(tester.binding.hasScheduledFrame, isFalse);

    DocumentOpener.open('c1');
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pump();
    expect(log.opened, ['A:c1']);
  });

  testWidgets('waits while no DocumentScreen is on screen, and opens in the next one', (WidgetTester tester) async {
    final _Log log = _Log();
    await tester.pumpWidget(const SizedBox());

    bool? outcome;
    DocumentOpener.open('c1').then((bool value) => outcome = value);
    await tester.pump();
    await tester.pump();
    expect(outcome, isNull);

    await tester.pumpWidget(_Board(newScreenPerBuild: true, read: log.read));
    expect(log.opened, ['A:c1']);
    expect(outcome, isTrue);
  });

  testWidgets('a screen that went away no longer takes requests', (WidgetTester tester) async {
    final _Log log = _Log();
    await tester.pumpWidget(_Board(newScreenPerBuild: true, read: log.read));
    await tester.pumpWidget(const SizedBox());

    DocumentOpener.open('c1');
    await tester.pump();
    expect(log.reads, isEmpty);
  });

  testWidgets('uses the screen mounted last, and the one before it when that one goes', (WidgetTester tester) async {
    final _Log log = _Log();
    Widget screens(List<String> configs) => Column(children: [for (final String config in configs) _Screen(key: ValueKey(config), config: config, read: log.read)]);

    await tester.pumpWidget(screens(['A', 'B']));
    DocumentOpener.open('c1');
    await tester.pump();
    expect(log.opened, ['B:c1']);

    await tester.pumpWidget(screens(['A']));
    DocumentOpener.open('c2');
    await tester.pump();
    expect(log.opened, ['B:c1', 'A:c2']);
  });

  group('a failed read drops the request', () {
    for (final (String name, Future<VoidCallback?> Function(String, String) read) failure in [
      ('no document', (String config, String id) async => null),
      ('a read error', (String config, String id) async => throw StateError('permission-denied')),
    ]) {
      testWidgets(failure.$1, (WidgetTester tester) async {
        int reads = 0;
        final GlobalKey<_BoardState> board = GlobalKey<_BoardState>();
        await tester.pumpWidget(_Board(
          key: board,
          newScreenPerBuild: true,
          read: (String config, String id) {
            reads++;
            return failure.$2(config, id);
          },
        ));

        bool? outcome;
        DocumentOpener.open('gone').then((bool value) => outcome = value);
        await tester.pump();
        expect(reads, 1);
        expect(outcome, isFalse);

        // New screens at later builds must not try again.
        board.currentState!.show('B');
        await tester.pump();
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(_Board(newScreenPerBuild: true, read: (String config, String id) async => null));
        await tester.pump();
        expect(reads, 1);
      });
    }
  });

  group('a newer request replaces an older one', () {
    testWidgets('before the older one has run', (WidgetTester tester) async {
      final _Log log = _Log();
      await tester.pumpWidget(_Board(newScreenPerBuild: true, read: log.read));

      bool? first;
      DocumentOpener.open('c1').then((bool value) => first = value);
      DocumentOpener.open('c2');
      await tester.pump();
      expect(first, isFalse);
      expect(log.reads, ['A:c2']);
      expect(log.opened, ['A:c2']);
    });

    testWidgets('while the older one reads', (WidgetTester tester) async {
      final List<String> opened = [];
      final Map<String, Completer<void>> reads = {};
      await tester.pumpWidget(_Board(
        newScreenPerBuild: true,
        read: (String config, String id) async {
          await (reads[id] = Completer<void>()).future;
          return () => opened.add('$config:$id');
        },
      ));

      bool? first;
      bool? second;
      DocumentOpener.open('c1').then((bool value) => first = value);
      await tester.pump();
      DocumentOpener.open('c2').then((bool value) => second = value);
      await tester.pump();
      expect(reads.keys, ['c1', 'c2']);

      reads['c2']!.complete();
      await tester.pump();
      reads['c1']!.complete();
      await tester.pump();
      expect(opened, ['A:c2']);
      expect(first, isFalse);
      expect(second, isTrue);
    });
  });

  group('a page-load link', () {
    testWidgets('is left for the DocumentScreen to open', (WidgetTester tester) async {
      final _Log log = _Log();
      final Uri link = Uri.parse('/board?id=fromLink');
      SelectionState.instance.pendingUri = link;

      await tester.pumpWidget(_Board(newScreenPerBuild: true, read: log.read));
      await tester.pump();
      expect(SelectionState.instance.pendingUri, link);
      expect(log.reads, isEmpty);
    });

    testWidgets('is dropped when the app asks for another document', (WidgetTester tester) async {
      SelectionState.instance.pendingUri = Uri.parse('/board?id=fromLink');
      DocumentOpener.open('c1');
      expect(SelectionState.instance.pendingUri, isNull);
    });
  });
}

/// Records which config read which id, and which config opened which id.
class _Log {
  final List<String> reads = [];
  final List<String> opened = [];

  Future<VoidCallback?> read(String config, String id) async {
    reads.add('$config:$id');
    return () => opened.add('$config:$id');
  }
}

/// The app screen: shows board A, and a board switch rebuilds the DocumentScreen.
class _Board extends StatefulWidget {
  const _Board({super.key, required this.newScreenPerBuild, required this.read});

  final bool newScreenPerBuild;
  final Future<VoidCallback?> Function(String config, String id) read;

  @override
  State<_Board> createState() => _BoardState();
}

class _BoardState extends State<_Board> {
  String _board = 'A';

  void show(String board) => setState(() => _board = board);

  @override
  Widget build(BuildContext context) {
    // A new key per build stands in for DocumentScreen's new form key per build.
    return _Screen(key: widget.newScreenPerBuild ? UniqueKey() : const ValueKey('screen'), config: _board, read: widget.read);
  }
}

/// Stands in for DocumentScreenLoader: registers in initState with a reader that
/// reads `widget` when it runs, and unregisters in dispose.
class _Screen extends StatefulWidget {
  const _Screen({super.key, required this.config, required this.read});

  final String config;
  final Future<VoidCallback?> Function(String config, String id) read;

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  @override
  void initState() {
    super.initState();
    DocumentOpener.register(this, (String id) => widget.read(widget.config, id));
  }

  @override
  void dispose() {
    DocumentOpener.unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox(height: 10);
}
