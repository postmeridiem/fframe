part of 'package:fframe/fframe.dart';

/// The part of a lane that one page listener reads, in the lane's order.
@immutable
class SwimlanePageBounds<D> {
  const SwimlanePageBounds({this.startAfter, this.endAt, this.limit});

  /// The page starts after this document. Null for the first page.
  final D? startAfter;

  /// The page ends at this document. Set when the page is closed (see [SwimlaneLanePager]).
  final D? endAt;

  /// The most documents the listener reads. Null for a closed page and for the rest of the lane.
  final int? limit;
}

/// Loads one lane page by page. Each page reads only its own cards, never the cards above it.
///
/// The last page is open: it reads up to its size plus one card after the page before it.
/// The extra card tells that the lane has more, and is not shown. [fetchMore] closes the open
/// page at its last shown card and opens a new page after that card. A closed page has no
/// limit, only its two ends. So a card that joins or leaves a closed page cannot push another
/// card out of the page, and no card is shown twice or lost between two pages. To close a page
/// the pager reads that page once more, with the closed bounds.
///
/// [fetchAll] makes the open page read on to the end of the lane, in one listener. The open
/// page's own cards are read once more, as when a page closes. A cursor page needs the last
/// card of the page before it, so a chain of pages would wait one round trip per page. [backToFirstPage] goes back to one page when the lane no longer needs every card.
///
/// Every page is a live listener, so a change to a card shows at once. A page that changes its
/// listener shows its documents until the new listener answers.
///
/// [D] is the document type: a `QueryDocumentSnapshot` in a lane, a plain value in the tests.
class SwimlaneLanePager<D> extends ChangeNotifier {
  SwimlaneLanePager({
    required this.listen,
    required this.idOf,
    required int firstPageSize,
    required this.pageSize,
  }) {
    final _LanePageSlot<D> firstSlot = _LanePageSlot<D>();
    _slots.add(firstSlot);
    _read(firstSlot, _LanePage<D>(size: firstPageSize));
  }

  /// Starts a listener on the part of the lane in [bounds].
  final Stream<List<D>> Function(SwimlanePageBounds<D> bounds) listen;

  /// The document id. The pager shows each id once.
  final String Function(D document) idOf;

  /// The size of each page after the first one.
  final int pageSize;

  final List<_LanePageSlot<D>> _slots = [];
  // The new first page of backToFirstPage. It replaces all slots when it answers.
  _LanePageSlot<D>? _firstPageSlot;
  Object? _error;
  bool _disposed = false;

  /// The loaded documents of all pages, in lane order.
  List<D> get docs {
    final Set<String> shownIds = {};
    return [
      for (final _LanePageSlot<D> slot in _slots)
        for (final D document in slot.current.shown)
          if (shownIds.add(idOf(document))) document,
    ];
  }

  /// True until the first page answers.
  bool get isFetching => _slots.first.current.documents == null;

  /// True while the open page waits for its first answer, or for the rest of the lane.
  bool get isFetchingMore => !isFetching && (_slots.last.current.documents == null || _slots.last.next != null);

  /// True while the lane can have cards after [docs], or more cards are on their way.
  bool get hasMore {
    final _LanePageSlot<D> openSlot = _slots.last;
    if (openSlot.next != null) return true;
    if (openSlot.current.documents == null) return _slots.length > 1;
    return openSlot.current.hasCardsAfter;
  }

  /// The last error of a page listener. A Firestore listener stops after an error.
  Object? get error => _error;

  /// True when the open page reads the rest of the lane (see [fetchAll]).
  bool get readsRestOfLane => (_slots.last.next ?? _slots.last.current).size == null && _firstPageSlot == null;

  /// Loads the next page. Does nothing while a page loads or when the lane has no more cards.
  /// Safe to call during a build: the listeners hear of it after the build.
  void fetchMore() {
    if (_disposed || isFetching || isFetchingMore || !hasMore) return;
    final _LanePageSlot<D> openSlot = _slots.last;
    final _LanePage<D> openPage = openSlot.current;
    final D lastShown = openPage.documents![openPage.size! - 1];
    _read(openSlot, _LanePage<D>(startAfter: openPage.startAfter, endAt: lastShown));
    final _LanePageSlot<D> newSlot = _LanePageSlot<D>();
    _slots.add(newSlot);
    _read(newSlot, _LanePage<D>(startAfter: lastShown, size: pageSize));
    _notifyAfterBuild();
  }

  /// Reads from the start of the open page to the end of the lane, in one listener. The cards
  /// of the open page are read once more. Does nothing when the lane is complete or the rest
  /// is already on its way. Safe to call during a build.
  void fetchAll() {
    if (_disposed) return;
    _stopFirstPageSlot();
    final _LanePageSlot<D> openSlot = _slots.last;
    if ((openSlot.next ?? openSlot.current).size == null) return;
    if (openSlot.current.documents != null && !openSlot.current.hasCardsAfter) return;
    _read(openSlot, _LanePage<D>(startAfter: openSlot.current.startAfter));
    _notifyAfterBuild();
  }

  /// Goes back to the first page after [fetchAll], so the lane stops listening to every card.
  /// The lane shows the cards it has until the first page answers. Does nothing when the lane
  /// does not read the rest of the lane. Safe to call during a build.
  void backToFirstPage() {
    if (_disposed || !readsRestOfLane) return;
    final _LanePageSlot<D> firstPageSlot = _LanePageSlot<D>();
    _firstPageSlot = firstPageSlot;
    _read(firstPageSlot, _LanePage<D>(size: pageSize));
    _notifyAfterBuild();
  }

  @override
  void dispose() {
    _disposed = true;
    _stopFirstPageSlot();
    for (final _LanePageSlot<D> slot in _slots) {
      _stop(slot);
    }
    super.dispose();
  }

  void _stop(_LanePageSlot<D> slot) {
    slot.current.subscription?.cancel();
    slot.next?.subscription?.cancel();
  }

  void _stopFirstPageSlot() {
    final _LanePageSlot<D>? firstPageSlot = _firstPageSlot;
    if (firstPageSlot == null) return;
    _firstPageSlot = null;
    _stop(firstPageSlot);
  }

  /// Starts [page] in [slot]. A slot that shows no documents yet changes its page at once.
  /// Otherwise the slot shows its current page until [page] answers.
  void _read(_LanePageSlot<D> slot, _LanePage<D> page) {
    if (slot.current.documents == null) {
      slot.current.subscription?.cancel();
      slot.current = page;
    } else {
      slot.next?.subscription?.cancel();
      slot.next = page;
    }
    page.subscription = listen(page.bounds).listen(
      (List<D> documents) => _onAnswer(slot, page, documents),
      onError: (Object error) {
        if (_disposed) return;
        _error = error;
        notifyListeners();
      },
    );
  }

  void _onAnswer(_LanePageSlot<D> slot, _LanePage<D> page, List<D> documents) {
    if (_disposed) return;
    if (identical(slot, _firstPageSlot)) {
      _firstPageSlot = null;
      for (final _LanePageSlot<D> oldSlot in _slots) {
        _stop(oldSlot);
      }
      _slots
        ..clear()
        ..add(slot);
    }
    if (identical(slot.next, page)) {
      slot.current.subscription?.cancel();
      slot.current = page;
      slot.next = null;
    }
    if (!identical(slot.current, page)) return;
    page.documents = documents;
    notifyListeners();
  }

  void _notifyAfterBuild() {
    scheduleMicrotask(() {
      if (!_disposed) notifyListeners();
    });
  }
}

/// One place in the lane's page order. It holds the page it shows, and the page that replaces
/// it when that page answers.
class _LanePageSlot<D> {
  _LanePage<D> current = _LanePage<D>();
  _LanePage<D>? next;
}

/// One page listener and its last answer.
class _LanePage<D> {
  _LanePage({this.startAfter, this.endAt, this.size});

  final D? startAfter;
  final D? endAt;

  /// How many documents the page shows. Null for a closed page and for the rest of the lane.
  final int? size;

  StreamSubscription<List<D>>? subscription;

  /// The last answer. Null until the first answer.
  List<D>? documents;

  SwimlanePageBounds<D> get bounds => SwimlanePageBounds<D>(startAfter: startAfter, endAt: endAt, limit: size == null ? null : size! + 1);

  Iterable<D> get shown => documents == null ? const [] : (size == null ? documents! : documents!.take(size!));

  bool get hasCardsAfter => size != null && documents != null && documents!.length > size!;
}
