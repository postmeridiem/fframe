import 'dart:async';

import 'package:fframe/fframe.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards how a swimlane loads its cards page by page.
///
/// The tests drive [SwimlaneLanePager] with a fake lane instead of Firestore. A document is
/// a card snapshot: its id and its place in the lane order when it was read. A cursor uses
/// the place in the snapshot, as a Firestore cursor uses the field values of its snapshot,
/// so a cursor still works after its card moved or left the lane. The fake answers a
/// listener only when the test says so, the way a server answers later.
void main() {
  group('the first page', () {
    test('reads one page plus one card, and shows one page', () async {
      final _FakeLane lane = _FakeLane.ofSize(50);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      expect(pager.isFetching, isTrue);
      expect(lane.listeners.single.bounds.limit, 21);

      lane.answerNew();
      await _settle();
      expect(pager.isFetching, isFalse);
      expect(_idsOf(pager), _ids(0, 20));
      expect(pager.hasMore, isTrue);
    });

    test('a short lane has no more cards', () async {
      final _FakeLane lane = _FakeLane.ofSize(20);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      expect(_idsOf(pager), _ids(0, 20));
      expect(pager.hasMore, isFalse);

      pager.fetchMore();
      pager.fetchAll();
      expect(lane.listeners, hasLength(1));
    });

    test('a larger first page (a restore) reads its size at once', () async {
      final _FakeLane lane = _FakeLane.ofSize(200);
      final SwimlaneLanePager<_Card> pager = lane.pager(firstPageSize: 72);
      expect(lane.listeners.single.bounds.limit, 73);
      lane.answerNew();
      await _settle();
      expect(pager.docs, hasLength(72));
    });
  });

  group('fetchMore', () {
    test('the next page starts after the last shown card and reads only its own cards', () async {
      final _FakeLane lane = _FakeLane.ofSize(50);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();

      pager.fetchMore();
      final _FakeListener closedPage = lane.listeners[1];
      final _FakeListener nextPage = lane.listeners[2];
      // The open page is closed at its last shown card: two ends, no limit.
      expect(closedPage.bounds.startAfter, isNull);
      expect(closedPage.bounds.endAt?.id, 'c19');
      expect(closedPage.bounds.limit, isNull);
      // The next page starts after that card, not at the top of the lane.
      expect(nextPage.bounds.startAfter?.id, 'c19');
      expect(nextPage.bounds.endAt, isNull);
      expect(nextPage.bounds.limit, 21);

      lane.answerNew();
      await _settle();
      expect(_idsOf(pager), _ids(0, 40));
      expect(pager.hasMore, isTrue);
      // The listener of the open page stops when the closed page answers.
      expect(lane.listeners.first.cancelled, isTrue);
    });

    test('the loaded cards stay on screen and hasMore stays true while the next page loads', () async {
      // The lane restore pages forward while hasMore is true: a false would make it give up.
      final _FakeLane lane = _FakeLane.ofSize(50);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();

      pager.fetchMore();
      await _settle();
      expect(_idsOf(pager), _ids(0, 20));
      expect(pager.isFetchingMore, isTrue);
      expect(pager.hasMore, isTrue);
    });

    test('tells its listeners after the build, not during it', () async {
      final _FakeLane lane = _FakeLane.ofSize(50);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      int notifications = 0;
      pager.addListener(() => notifications++);

      pager.fetchMore();
      expect(notifications, 0);
      await _settle();
      expect(notifications, 1);
    });

    test('does nothing while a page loads', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      pager.fetchMore();
      expect(lane.listeners, hasLength(1), reason: 'the first page has not answered');

      lane.answerNew();
      await _settle();
      pager.fetchMore();
      pager.fetchMore();
      expect(lane.listeners, hasLength(3));
    });

    test('a scroll to the end of a long lane reads each card at most twice', () async {
      // To Do: Trims from Asia: 34 pages streamed 11,928 cards to show 675, because each
      // page read the whole lane again with a larger limit.
      final _FakeLane lane = _FakeLane.ofSize(675);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      while (pager.hasMore) {
        pager.fetchMore();
        lane.answerNew();
        await _settle();
      }
      expect(_idsOf(pager), _ids(0, 675));
      // Each card is read by its open page, and again when that page closes.
      expect(lane.cardsRead, lessThanOrEqualTo(2 * 675 + 34));
      expect(lane.listeners.where((listener) => !listener.cancelled), hasLength(34));
    });
  });

  group('fetchAll (a filter is on)', () {
    test('the open page reads the rest of the lane in one listener', () async {
      final _FakeLane lane = _FakeLane.ofSize(700);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();

      pager.fetchAll();
      final _FakeListener rest = lane.listeners.last;
      expect(rest.bounds.startAfter, isNull);
      expect(rest.bounds.limit, isNull);
      expect(pager.isFetchingMore, isTrue);
      expect(pager.hasMore, isTrue);

      lane.answerNew();
      await _settle();
      expect(_idsOf(pager), _ids(0, 700));
      expect(pager.hasMore, isFalse);
      expect(pager.isFetchingMore, isFalse);
      expect(lane.listeners, hasLength(2));
      expect(lane.listeners.first.cancelled, isTrue);
    });

    test('after paging, it reads only the cards after the closed pages', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      pager.fetchMore();
      lane.answerNew();
      await _settle();

      pager.fetchAll();
      expect(lane.listeners.last.bounds.startAfter?.id, 'c19');
      expect(lane.listeners.last.bounds.limit, isNull);
      lane.answerNew();
      await _settle();
      expect(_idsOf(pager), _ids(0, 100));
    });

    test('before the first answer, the first page reads the whole lane', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      pager.fetchAll();
      expect(lane.listeners.first.cancelled, isTrue);
      expect(lane.listeners.last.bounds.limit, isNull);
      expect(pager.isFetching, isTrue);

      lane.answerNew();
      await _settle();
      expect(_idsOf(pager), _ids(0, 100));
    });

    test('backToFirstPage (the filter goes): the cards stay until the first page answers, then one page', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      pager.fetchAll();
      lane.answerNew();
      await _settle();
      expect(pager.readsRestOfLane, isTrue);
      final _FakeListener rest = lane.listeners.last;

      pager.backToFirstPage();
      final _FakeListener firstPage = lane.listeners.last;
      expect(firstPage.bounds.startAfter, isNull);
      expect(firstPage.bounds.limit, 21);
      await _settle();
      expect(pager.docs, hasLength(100), reason: 'no empty lane while the first page loads');
      expect(pager.readsRestOfLane, isFalse);

      lane.answerNew();
      await _settle();
      expect(_idsOf(pager), _ids(0, 20));
      expect(pager.hasMore, isTrue);
      expect(rest.cancelled, isTrue, reason: 'the lane stops listening to every card');
      expect(lane.listeners.where((listener) => !listener.cancelled), [firstPage]);
    });

    test('a filter that comes back before the first page answers keeps the rest of the lane', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      pager.fetchAll();
      lane.answerNew();
      await _settle();
      final _FakeListener rest = lane.listeners.last;

      pager.backToFirstPage();
      final _FakeListener firstPage = lane.listeners.last;
      // hasMore is false in this wait, so a lane must call fetchAll without a hasMore check.
      expect(pager.hasMore, isFalse);
      pager.fetchAll();
      expect(firstPage.cancelled, isTrue);
      expect(rest.cancelled, isFalse);
      expect(pager.readsRestOfLane, isTrue);
      expect(_idsOf(pager), _ids(0, 100));
    });

    test('backToFirstPage does nothing when the lane does not read the rest', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      pager.fetchMore();
      lane.answerNew();
      await _settle();

      pager.backToFirstPage();
      expect(lane.listeners, hasLength(3));
      expect(_idsOf(pager), _ids(0, 40));
    });

    test('a second call does not read again', () async {
      final _FakeLane lane = _FakeLane.ofSize(100);
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      pager.fetchAll();
      pager.fetchAll();
      lane.answerNew();
      await _settle();
      pager.fetchAll();
      expect(lane.listeners, hasLength(2));
    });
  });

  group('live changes', () {
    // Card cN sits at place N * 10, so a card can join between two cards.
    Future<(_FakeLane, SwimlaneLanePager<_Card>)> twoPages() async {
      final _FakeLane lane = _FakeLane({for (int number = 0; number < 60; number++) 'c$number': number * 10});
      final SwimlaneLanePager<_Card> pager = lane.pager();
      lane.answerNew();
      await _settle();
      pager.fetchMore();
      lane.answerNew();
      await _settle();
      return (lane, pager);
    }

    test('a card that joins a closed page shows in it, and no card is lost', () async {
      final (_FakeLane lane, SwimlaneLanePager<_Card> pager) = await twoPages();
      lane.places['new'] = 55;
      lane.tell();
      await _settle();

      final List<String> ids = _idsOf(pager);
      expect(ids, hasLength(41));
      expect(ids.indexOf('new'), 6);
      // The last card of the first page and the first card of the second are both shown.
      expect(ids, containsAll(['c19', 'c20']));
    });

    test('a card that leaves a closed page shows no other card twice', () async {
      final (_FakeLane lane, SwimlaneLanePager<_Card> pager) = await twoPages();
      lane.places.remove('c5');
      lane.tell();
      await _settle();

      final List<String> ids = _idsOf(pager);
      expect(ids, hasLength(39));
      expect(ids.toSet(), hasLength(39));
    });

    test('a card that moves to a later page shows once, also while the pages answer one by one', () async {
      final (_FakeLane lane, SwimlaneLanePager<_Card> pager) = await twoPages();
      lane.places['c5'] = 305;
      // The second page answers first: for a moment both pages hold the card.
      lane.tell(only: (listener) => listener.bounds.startAfter?.id == 'c19');
      await _settle();
      expect(_idsOf(pager).where((id) => id == 'c5'), hasLength(1));

      lane.tell();
      await _settle();
      final List<String> ids = _idsOf(pager);
      expect(ids.where((id) => id == 'c5'), hasLength(1));
      expect(ids.indexOf('c5'), greaterThan(ids.indexOf('c19')));
    });
  });

  test('a listener error is kept and told', () async {
    final _FakeLane lane = _FakeLane.ofSize(50);
    final SwimlaneLanePager<_Card> pager = lane.pager();
    int notifications = 0;
    pager.addListener(() => notifications++);
    lane.listeners.single.controller.addError(StateError('permission-denied'));
    await _settle();
    expect(pager.error, isA<StateError>());
    expect(notifications, 1);
  });

  test('dispose stops every listener', () async {
    final _FakeLane lane = _FakeLane.ofSize(100);
    final SwimlaneLanePager<_Card> pager = lane.pager();
    lane.answerNew();
    await _settle();
    pager.fetchMore();
    pager.dispose();
    expect(lane.listeners.every((listener) => listener.cancelled), isTrue);
  });
}

/// A card as one read saw it: its id and its place in the lane order.
typedef _Card = ({String id, int place});

List<String> _ids(int from, int to) => [for (int number = from; number < to; number++) 'c$number'];

List<String> _idsOf(SwimlaneLanePager<_Card> pager) => [for (final _Card card in pager.docs) card.id];

/// Lets the stream events and the pager's deferred notifications run.
Future<void> _settle() => pumpEventQueue();

/// Lane order: by place, then by id (as Firestore orders by the document id last).
int _compare(_Card first, _Card second) => first.place != second.place ? first.place.compareTo(second.place) : first.id.compareTo(second.id);

/// One page listener of the fake lane.
class _FakeListener {
  _FakeListener(this.bounds);

  final SwimlanePageBounds<_Card> bounds;
  late final StreamController<List<_Card>> controller = StreamController<List<_Card>>(onCancel: () => cancelled = true);
  bool cancelled = false;
  bool answered = false;
}

/// A lane of cards. It answers listeners like Firestore: a first answer with all the cards
/// in the bounds, and a new answer after a change.
class _FakeLane {
  _FakeLane(this.places);

  _FakeLane.ofSize(int size) : places = {for (int number = 0; number < size; number++) 'c$number': number};

  /// The place of each card in the lane order. Change it, then [tell].
  final Map<String, int> places;
  final List<_FakeListener> listeners = [];

  /// The cards in the first answers, as Firestore bills a new listener.
  int cardsRead = 0;

  SwimlaneLanePager<_Card> pager({int firstPageSize = 20}) => SwimlaneLanePager<_Card>(
        listen: listen,
        idOf: (_Card card) => card.id,
        firstPageSize: firstPageSize,
        pageSize: 20,
      );

  Stream<List<_Card>> listen(SwimlanePageBounds<_Card> bounds) {
    final _FakeListener listener = _FakeListener(bounds);
    listeners.add(listener);
    return listener.controller.stream;
  }

  List<_Card> resultFor(SwimlanePageBounds<_Card> bounds) {
    Iterable<_Card> result = [for (final MapEntry<String, int> entry in places.entries) (id: entry.key, place: entry.value)]..sort(_compare);
    if (bounds.startAfter != null) result = result.where((card) => _compare(card, bounds.startAfter!) > 0);
    if (bounds.endAt != null) result = result.where((card) => _compare(card, bounds.endAt!) <= 0);
    if (bounds.limit != null) result = result.take(bounds.limit!);
    return result.toList();
  }

  /// Gives each new listener its first answer.
  void answerNew() {
    for (final _FakeListener listener in listeners) {
      if (listener.cancelled || listener.answered) continue;
      listener.answered = true;
      final List<_Card> result = resultFor(listener.bounds);
      cardsRead += result.length;
      listener.controller.add(result);
    }
  }

  /// Sends a new answer to each listener that answered before, or only to those that match [only].
  void tell({bool Function(_FakeListener listener)? only}) {
    for (final _FakeListener listener in listeners) {
      if (listener.cancelled || !listener.answered) continue;
      if (only != null && !only(listener)) continue;
      listener.controller.add(resultFor(listener.bounds));
    }
  }
}
