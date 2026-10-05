import 'package:fframe/fframe.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards how a swimlane keeps its vertical position while a card is open.
///
/// Opening or closing a card rebuilds the board, so each lane comes back with a fresh
/// State, at the top, with only its first page loaded. The lane saves the cards it was
/// showing when the card opened, and scrolls back to them.
///
/// The widget tests drive a plain [ListView] harness that behaves like a lane (cards of
/// varied height, a pager that loads 20 more on fetchMore, a new State per rebuild), so
/// they run without a Firestore fake. A "rebuild" pumps the lane under a new key.
void main() {
  // The app sets the log threshold at start-up; the lane logs when it keeps or drops a place.
  setUpAll(() => Console(logThreshold: LogLevel.prod));
  setUp(SwimlaneScrollAnchor.resetAll);

  group('SwimlaneScrollAnchor.boardKey', () {
    test('matches the key the horizontal offset and the filter are stored under', () {
      // The horizontal state uses this helper too: a different format would lose it.
      expect(SwimlaneScrollAnchor.boardKey('fframe/lists/boardCards', 'boardCards'), 'fframe/lists/boardCards:boardCards');
    });
  });

  group('SwimlaneScrollAnchor store', () {
    test('saves and clears per board key', () {
      final SwimlaneScrollAnchor anchor = _anchor(['c1']);
      SwimlaneScrollAnchor.save('a', anchor);
      expect(SwimlaneScrollAnchor.savedFor('a'), same(anchor));
      expect(SwimlaneScrollAnchor.savedFor('b'), isNull);
      SwimlaneScrollAnchor.clear('a');
      expect(SwimlaneScrollAnchor.savedFor('a'), isNull);
    });

    test('clear(only:) leaves a newer anchor alone', () {
      // A lane that gives up on an old anchor must not remove the one a new open saved.
      final SwimlaneScrollAnchor older = _anchor(['c1']);
      final SwimlaneScrollAnchor newer = _anchor(['c2']);
      SwimlaneScrollAnchor.save('a', newer);
      SwimlaneScrollAnchor.clear('a', only: older);
      expect(SwimlaneScrollAnchor.savedFor('a'), same(newer));
      SwimlaneScrollAnchor.clear('a', only: newer);
      expect(SwimlaneScrollAnchor.savedFor('a'), isNull);
    });
  });

  group('SwimlaneScrollAnchor.isFor', () {
    test('needs the same lane id and the same lane query', () {
      const SwimlaneScrollAnchor anchor = SwimlaneScrollAnchor(laneId: 'To Do', laneQuery: 'boardId == v5', cards: [], scrollOffset: 0);
      expect(anchor.isFor('To Do', 'boardId == v5'), isTrue);
      // The same lane name on another board: its query has another board filter.
      expect(anchor.isFor('To Do', 'boardId == v6'), isFalse);
      expect(anchor.isFor('Done', 'boardId == v5'), isFalse);
    });
  });

  group('SwimlaneScrollAnchor.pickVisible', () {
    List<String> pick(List<SwimlaneMeasuredCard> cards, {String? openedId}) => SwimlaneScrollAnchor.pickVisible(cards, viewportHeight: 400, openedId: openedId).map((card) => card.id).toList();

    test('a card partly visible at the top or the bottom counts', () {
      expect(pick([(id: 'top', top: -50, height: 60), (id: 'bottom', top: 390, height: 60)]), ['top', 'bottom']);
    });

    test('a card just outside the viewport does not count', () {
      expect(pick([(id: 'above', top: -60, height: 60), (id: 'below', top: 400, height: 60)]), isEmpty);
    });

    test('returns at most three cards, top first, whatever the input order', () {
      expect(
        pick([
          (id: 'd', top: 300, height: 60),
          (id: 'a', top: -10, height: 60),
          (id: 'c', top: 200, height: 60),
          (id: 'b', top: 100, height: 60),
        ]),
        ['a', 'b', 'c'],
      );
    });

    test('skips the opened card, because it is the card most likely to move', () {
      expect(pick([(id: 'a', top: 0, height: 60), (id: 'opened', top: 60, height: 60), (id: 'b', top: 120, height: 60)], openedId: 'opened'), ['a', 'b']);
    });

    test('uses the opened card when it is the only visible card', () {
      expect(pick([(id: 'opened', top: -100, height: 600)], openedId: 'opened'), ['opened']);
    });
  });

  group('SwimlaneScrollAnchor.nextStep', () {
    // Anchor cards a, b, c were shown at 10, 11 and 13 (the opened card sat at 12).
    final SwimlaneScrollAnchor anchor = SwimlaneScrollAnchor(
      laneId: 'lane',
      scrollOffset: 900,
      cards: const [
        SwimlaneAnchorCard(id: 'a', offsetInView: -10, shownIndex: 10, loadedIndex: 10),
        SwimlaneAnchorCard(id: 'b', offsetInView: 60, shownIndex: 11, loadedIndex: 11),
        SwimlaneAnchorCard(id: 'c', offsetInView: 200, shownIndex: 13, loadedIndex: 13),
      ],
    );

    // A shown list with the given cards at the given indexes, padding elsewhere.
    List<String> shown(Map<int, String> at, {int length = 40}) => [for (int index = 0; index < length; index++) at[index] ?? 'x$index'];

    SwimlaneAnchorStep step(List<String> shownIds, {int? loadedCount, bool hasMore = false}) => anchor.nextStep(shownIds: shownIds, loadedCount: loadedCount ?? shownIds.length, hasMore: hasMore, pageSize: 20);

    test('the first anchor card wins when all of them are in place', () {
      expect(step(shown({10: 'a', 11: 'b', 13: 'c'})).card?.id, 'a');
    });

    test('allows the gap to change by one card: the opened card left between them', () {
      final SwimlaneAnchorStep result = step(shown({10: 'a', 11: 'b', 12: 'c'}));
      expect(result.action, SwimlaneAnchorAction.scrollTo);
      expect(result.card?.id, 'a');
    });

    test('ignores an anchor card that moved away from the others', () {
      // A sync moved a from 10 to 30; b and c still sit together, so b is used.
      expect(step(shown({30: 'a', 10: 'b', 12: 'c'})).card?.id, 'b');
      // The same when a moved to the top of the lane.
      expect(step(shown({0: 'a', 11: 'b', 13: 'c'})).card?.id, 'b');
    });

    test('a gap that changed by two cards is not "together"', () {
      // a moved two cards up, b stayed, c is gone: the pair does not agree, nothing more to load.
      final SwimlaneAnchorStep result = step(shown({8: 'a', 11: 'b'}));
      expect(result.action, SwimlaneAnchorAction.scrollTo);
      // So the fallback decides: b moved 0, a moved 2. Taken as "together", a would win.
      expect(result.card?.id, 'b');
    });

    test('a pair that sits together beats a single card that moved less', () {
      // Five cards were added above a and b; c moved up past them. a and b still agree.
      expect(step(shown({15: 'a', 16: 'b', 13: 'c'})).card?.id, 'a');
    });

    test('the only pair can sit across the opened card that left', () {
      // a is gone; b and c had the opened card between them (gap 2, now 1), and both
      // shifted down. Taken as apart, the fallback would pick c, which moved less.
      expect(step(shown({14: 'b', 15: 'c'})).card?.id, 'b');
    });

    test('a pair in the wrong order is not "together"', () {
      // b and c swapped; a is gone. Without a pair, the least-moved card is used: c (1) over b (2).
      expect(step(shown({13: 'b', 12: 'c'})).card?.id, 'c');
    });

    test('falls back to the next anchor cards when the first one is gone', () {
      expect(step(shown({10: 'b', 12: 'c'})).card?.id, 'b');
    });

    test('waits for missing anchor cards while more pages can hold them', () {
      // Only c is loaded: alone it cannot be checked against the others, so load more first.
      expect(step(shown({5: 'c'}, length: 20), hasMore: true).action, SwimlaneAnchorAction.fetchMore);
    });

    test('fetches more when no anchor card is loaded yet', () {
      expect(step(shown({}, length: 20), hasMore: true).action, SwimlaneAnchorAction.fetchMore);
    });

    test('stops paging one page past the deepest anchor card', () {
      // Deepest loadedIndex is 13, so the cap is 13 + 1 + 20 = 34 loaded documents.
      expect(step(shown({}, length: 33), hasMore: true).action, SwimlaneAnchorAction.fetchMore);
      expect(step(shown({}, length: 34), hasMore: true).action, SwimlaneAnchorAction.giveUp);
    });

    test('gives up when nothing is left and no more pages exist', () {
      expect(step(shown({}, length: 20)).action, SwimlaneAnchorAction.giveUp);
    });

    test('uses the only anchor card left when no more pages exist', () {
      expect(step(shown({3: 'b'}, length: 20)).card?.id, 'b');
    });

    test('matches against the shown (filtered) cards, not the loaded ones', () {
      // a and b are loaded but filtered out; only c is shown, and there is nothing more to load.
      final SwimlaneAnchorStep result = anchor.nextStep(shownIds: shown({13: 'c'}), loadedCount: 60, hasMore: false, pageSize: 20);
      expect(result.card?.id, 'c');
    });
  });

  group('SwimlaneLaneScroll in a lane', () {
    // Card n is 60, 90 or 120 high (n % 3), so three cards take 270 px. At 700 px the
    // 400 px viewport shows c8 (top -10), c9 (110), c10 (170), c11 (260) and c12 (380).

    testWidgets('a card open saves the visible cards, the opened card excluded', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      final SwimlaneScrollAnchor? anchor = SwimlaneScrollAnchor.savedFor(_boardKey);
      expect(anchor?.laneId, 'inProgress');
      expect(anchor?.scrollOffset, 700);
      expect(anchor?.cards.map((card) => card.id), ['c8', 'c9', 'c11']);
      expect(anchor?.cards.map((card) => card.offsetInView), [-10, 110, 260]);
    });

    testWidgets('a rebuild with the same cards puts the lane back where it was', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      final _LaneState lane = await _rebuild(tester, _ids(0, 60));
      expect(lane.laneScroll.controller.offset, closeTo(700, 1));
      expect(_topOf(tester, 'c8'), closeTo(-10, 1));
    });

    testWidgets('the opened card left the lane: the cards above it keep their place', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      await _rebuild(tester, _ids(0, 60)..remove('c10'));
      expect(_topOf(tester, 'c8'), closeTo(-10, 1));
      expect(_topOf(tester, 'c9'), closeTo(110, 1));
    });

    testWidgets('anchor card 1 left the lane: anchor card 2 keeps its place', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      await _rebuild(tester, _ids(0, 60)..remove('c8'));
      expect(_topOf(tester, 'c9'), closeTo(110, 1));
    });

    testWidgets('all anchor cards left: the lane is at the top and the anchor is cleared', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      final _LaneState lane = await _rebuild(tester, _ids(0, 60)..removeWhere(['c8', 'c9', 'c11'].contains));
      expect(lane.laneScroll.controller.offset, 0);
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNull);
    });

    testWidgets('anchor cards beyond the first page: the lane pages forward, then scrolls', (tester) async {
      // At 4460 px: c49 (top -80), c50 (10), c51 (130), c52 (190).
      await _scrollAndOpen(tester, cards: _ids(0, 100), scrollTo: 4460, open: 'c52', pageSize: 20, loaded: 100);

      final _Pager pager = _Pager(_ids(0, 100), pageSize: 20);
      await _rebuild(tester, _ids(0, 100), pager: pager);
      // 20 → 40 → 60 loaded: c49 to c51 are in the third page.
      expect(pager.fetchCount, 2);
      expect(_topOf(tester, 'c49'), closeTo(-80, 1));
    });

    testWidgets('anchor cards gone from a long lane: paging stops at the cap', (tester) async {
      // At 4050 px: c45 (top 0), c46 (60), c47 (150), c48 (270).
      await _scrollAndOpen(tester, cards: _ids(0, 200), scrollTo: 4050, open: 'c48', pageSize: 20, loaded: 200);
      expect(SwimlaneScrollAnchor.savedFor(_boardKey)?.cards.map((card) => card.id), ['c45', 'c46', 'c47']);

      final _Pager pager = _Pager(_ids(0, 200)..removeWhere(['c45', 'c46', 'c47'].contains), pageSize: 20);
      final _LaneState lane = await _rebuild(tester, pager.cards, pager: pager);
      // Cap: 47 + 1 + 20 = 68, so 20 → 40 → 60 → 80 and stop. The whole lane would take 9.
      expect(pager.fetchCount, 3);
      expect(lane.laneScroll.controller.offset, 0);
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNull);
    });

    testWidgets('anchor cards moved far up the lane: the lane steps back up to them', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 100), scrollTo: 4460, open: 'c52');

      // 30 cards above them left: c49 is now at index 19, far above the saved offset.
      await _rebuild(tester, _ids(30, 100));
      expect(_topOf(tester, 'c49'), closeTo(-80, 1));
    });

    testWidgets('a sync moved anchor card 1 elsewhere: the view stays on cards 2 and 3', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      await _rebuild(tester, _ids(0, 60)..remove('c8')..insert(40, 'c8'));
      expect(_topOf(tester, 'c9'), closeTo(110, 1));

      await _rebuild(tester, _ids(0, 60)..remove('c8')..insert(0, 'c8'), build: 3);
      expect(_topOf(tester, 'c9'), closeTo(110, 1));
    });

    testWidgets('the opened card moved within its lane: the view does not follow it', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      // The lane position picker in the card detail moved c10 down to index 30.
      await _rebuild(tester, _ids(0, 60)..remove('c10')..insert(30, 'c10'));
      expect(_topOf(tester, 'c8'), closeTo(-10, 1));
    });

    testWidgets('cards change while the lane is not rebuilt: the lane stays on its cards', (tester) async {
      final _LaneState lane = await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      // A card above the viewport leaves while the card is open. Without the anchor the list
      // would keep its pixel offset and every card would shift up by c0's 60 px.
      lane.widget.pager.update(_ids(1, 60));
      await tester.pumpAndSettle();
      expect(_topOf(tester, 'c8'), closeTo(-10, 1));
    });

    testWidgets('a second rebuild after a restore restores again', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');
      await _rebuild(tester, _ids(0, 60));

      final _LaneState lane = await _rebuild(tester, _ids(0, 60), build: 3);
      expect(lane.laneScroll.controller.offset, closeTo(700, 1));
    });

    testWidgets('keeps its place in a filtered lane', (tester) async {
      bool evenOnly(String id) => int.parse(id.substring(1)).isEven;
      final _LaneState lane = await _pumpLane(tester, _Pager(_ids(0, 120), pageSize: 120), build: 1, show: evenOnly);
      lane.laneScroll.controller.jumpTo(1000);
      await tester.pumpAndSettle();
      final List<String> visibleBefore = _visibleIds(tester, _ids(0, 120).where(evenOnly));
      await tester.tap(find.byKey(ValueKey('card-${visibleBefore[1]}')));
      await tester.pumpAndSettle();
      final double topBefore = _topOf(tester, visibleBefore.first);

      await _rebuild(tester, _ids(0, 120), show: evenOnly);
      expect(_topOf(tester, visibleBefore.first), closeTo(topBefore, 1));
    });

    testWidgets('a user scroll drops the anchor; a programmatic jump does not', (tester) async {
      final _LaneState lane = await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      lane.laneScroll.controller.jumpTo(800);
      await tester.pumpAndSettle();
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNotNull);

      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNull);

      final _LaneState rebuilt = await _rebuild(tester, _ids(0, 60));
      expect(rebuilt.laneScroll.controller.offset, 0);
    });

    testWidgets('a mouse wheel scroll drops the anchor', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      final TestPointer mouse = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(mouse.hover(tester.getCenter(find.byType(ListView))));
      await tester.sendEventToBinding(mouse.scroll(const Offset(0, 60)));
      await tester.pumpAndSettle();
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNull);
    });

    testWidgets('a card drag drops the anchor', (tester) async {
      final _LaneState lane = await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      lane.laneScroll.onDragStarted();
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNull);
    });

    testWidgets('another lane does not restore it', (tester) async {
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10');

      final _LaneState other = await _rebuild(tester, _ids(0, 60), laneId: 'done');
      expect(other.laneScroll.controller.offset, 0);
      // The anchor belongs to the other lane, so this lane leaves it in place.
      expect(SwimlaneScrollAnchor.savedFor(_boardKey)?.laneId, 'inProgress');
    });

    testWidgets('a lane with the same name on another board does not restore it', (tester) async {
      // v5 and v6 boards share lane names, and a card placed on both boards is in both
      // lanes. Only the lane query (its board filter) tells the lanes apart.
      await _scrollAndOpen(tester, cards: _ids(0, 60), scrollTo: 700, open: 'c10', laneQuery: 'boardId == v5');

      final _LaneState otherBoard = await _rebuild(tester, _ids(0, 60), laneQuery: 'boardId == v6');
      expect(otherBoard.laneScroll.controller.offset, 0);
      expect(SwimlaneScrollAnchor.savedFor(_boardKey)?.laneQuery, 'boardId == v5');

      final _LaneState sameBoard = await _rebuild(tester, _ids(0, 60), laneQuery: 'boardId == v5', build: 3);
      expect(sameBoard.laneScroll.controller.offset, closeTo(700, 1));
    });

    testWidgets('a card opened with the lane at the top saves nothing and replaces an older anchor', (tester) async {
      // The older anchor is for another lane, so only the open can remove it.
      SwimlaneScrollAnchor.save(_boardKey, _anchor(['old'], laneId: 'done'));
      await _pumpLane(tester, _Pager(_ids(0, 60), pageSize: 200), build: 1);
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNotNull);

      await tester.tap(find.byKey(const ValueKey('card-c2')));
      await tester.pumpAndSettle();
      expect(SwimlaneScrollAnchor.savedFor(_boardKey), isNull);
    });
  });
}

const String _boardKey = 'fframe/lists/boardCards:boardCards';

List<String> _ids(int from, int to) => [for (int n = from; n < to; n++) 'c$n'];

double _heightOf(String id) => 60.0 + (int.parse(id.substring(1)) % 3) * 30.0;

SwimlaneScrollAnchor _anchor(List<String> ids, {String laneId = 'inProgress'}) => SwimlaneScrollAnchor(
      laneId: laneId,
      scrollOffset: 100,
      cards: [for (int index = 0; index < ids.length; index++) SwimlaneAnchorCard(id: ids[index], offsetInView: 0, shownIndex: index, loadedIndex: index)],
    );

double _topOf(WidgetTester tester, String id) => tester.getTopLeft(find.byKey(ValueKey('card-$id'))).dy - tester.getTopLeft(find.byType(ListView)).dy;

List<String> _visibleIds(WidgetTester tester, Iterable<String> ids) => [
      for (final String id in ids)
        if (find.byKey(ValueKey('card-$id')).evaluate().isNotEmpty && _topOf(tester, id) < 400 && _topOf(tester, id) + _heightOf(id) > 0) id,
    ];

Future<_LaneState> _pumpLane(WidgetTester tester, _Pager pager, {required int build, String laneId = 'inProgress', String? laneQuery, bool Function(String id)? show}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            height: 400,
            child: _Lane(key: ValueKey(build), pager: pager, laneId: laneId, laneQuery: laneQuery, show: show),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return tester.state<_LaneState>(find.byType(_Lane));
}

Future<_LaneState> _scrollAndOpen(
  WidgetTester tester, {
  required List<String> cards,
  required double scrollTo,
  required String open,
  int pageSize = 200,
  int? loaded,
  String? laneQuery,
}) async {
  final _LaneState lane = await _pumpLane(tester, _Pager(cards, pageSize: pageSize, loaded: loaded), build: 1, laneQuery: laneQuery);
  lane.laneScroll.controller.jumpTo(scrollTo);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey('card-$open')));
  await tester.pumpAndSettle();
  return lane;
}

/// The board is thrown away and built again: a new lane State, back on page 1.
Future<_LaneState> _rebuild(WidgetTester tester, List<String> cards, {_Pager? pager, int build = 2, String laneId = 'inProgress', String? laneQuery, bool Function(String id)? show}) {
  return _pumpLane(tester, pager ?? _Pager(cards, pageSize: 200), build: build, laneId: laneId, laneQuery: laneQuery, show: show);
}

/// Stands in for FirestoreQueryBuilder: pages of [pageSize], fetchMore deferred like its setState.
class _Pager extends ChangeNotifier {
  _Pager(this.cards, {this.pageSize = 20, int? loaded}) : loaded = loaded ?? pageSize;

  List<String> cards;
  final int pageSize;
  int loaded;
  bool fetching = false;
  int fetchCount = 0;

  List<String> get loadedIds => cards.take(loaded).toList();
  bool get hasMore => cards.length > loaded;

  void fetchMore() {
    if (fetching || !hasMore) return;
    fetching = true;
    fetchCount++;
    Future.microtask(() {
      loaded += pageSize;
      fetching = false;
      notifyListeners();
    });
  }

  void update(List<String> newCards) {
    cards = newCards;
    notifyListeners();
  }
}

/// A lane the way the swimlanes widget builds one, without Firestore.
class _Lane extends StatefulWidget {
  const _Lane({super.key, required this.pager, required this.laneId, this.laneQuery, this.show});

  final _Pager pager;
  final String laneId;
  final String? laneQuery;
  final bool Function(String id)? show;

  @override
  State<_Lane> createState() => _LaneState();
}

class _LaneState extends State<_Lane> {
  late final SwimlaneLaneScroll laneScroll = SwimlaneLaneScroll(boardKey: _boardKey, laneId: widget.laneId, pageSize: widget.pager.pageSize);

  @override
  void dispose() {
    laneScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Like the real lane, which sets it from its Firestore query on each build.
    laneScroll.laneQuery = widget.laneQuery;
    return ListenableBuilder(
      listenable: widget.pager,
      builder: (context, _) {
        final List<String> loadedIds = widget.pager.loadedIds;
        final List<String> shownIds = widget.show == null ? loadedIds : loadedIds.where(widget.show!).toList();
        laneScroll.onDocuments(
          shownIds: shownIds,
          loadedIds: loadedIds,
          hasMore: widget.pager.hasMore,
          isFetchingMore: widget.pager.fetching,
          fetchMore: widget.pager.fetchMore,
        );
        return ListView.builder(
          controller: laneScroll.controller,
          itemCount: shownIds.length,
          itemBuilder: (context, index) {
            final String id = shownIds[index];
            return SwimlaneCardAnchor(
              laneScroll: laneScroll,
              documentId: id,
              child: GestureDetector(
                onTap: () => laneScroll.captureOnOpen(id),
                child: SizedBox(key: ValueKey('card-$id'), height: _heightOf(id), child: Text(id)),
              ),
            );
          },
        );
      },
    );
  }
}
