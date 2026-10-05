part of 'package:fframe/fframe.dart';

/// A built card's position in its lane viewport, as measured by [SwimlaneLaneScroll].
typedef SwimlaneMeasuredCard = ({String id, double top, double height});

/// One card a lane was showing when a card opened, and where it sat.
///
/// Opening or closing a card rebuilds the board, so each lane loses its scroll
/// position and its loaded pages. A pixel offset is not a stable reference: by the
/// time the card closes the lane may have re-flowed (the opened card changed lane,
/// a sync moved a card). The cards the user was looking at are.
@immutable
class SwimlaneAnchorCard {
  const SwimlaneAnchorCard({
    required this.id,
    required this.offsetInView,
    required this.shownIndex,
    required this.loadedIndex,
  });

  /// The card's document id.
  final String id;

  /// The card's top edge minus the lane viewport's top edge. Negative when the card
  /// was partly scrolled out at the top.
  final double offsetInView;

  /// Position in the lane's shown (filtered) cards.
  final int shownIndex;

  /// Position in the lane's loaded (unfiltered) documents. Bounds the paging.
  final int loadedIndex;
}

/// What [SwimlaneScrollAnchor.nextStep] tells a lane to do.
enum SwimlaneAnchorAction { scrollTo, fetchMore, giveUp }

/// The decision of [SwimlaneScrollAnchor.nextStep]; [card] is set for [SwimlaneAnchorAction.scrollTo].
@immutable
class SwimlaneAnchorStep {
  const SwimlaneAnchorStep.scrollTo(SwimlaneAnchorCard this.card) : action = SwimlaneAnchorAction.scrollTo;
  const SwimlaneAnchorStep.fetchMore()
      : action = SwimlaneAnchorAction.fetchMore,
        card = null;
  const SwimlaneAnchorStep.giveUp()
      : action = SwimlaneAnchorAction.giveUp,
        card = null;

  final SwimlaneAnchorAction action;
  final SwimlaneAnchorCard? card;
}

/// The vertical position a board keeps for one lane while a card is open.
///
/// Saved when a card opens, in a static store that outlives the lane `State` (the
/// same pattern as the horizontal offset in [_SwimlaneBuilderState]). Each new lane
/// instance for [laneId] restores it. Only the lane of the opened card is kept.
@immutable
class SwimlaneScrollAnchor {
  const SwimlaneScrollAnchor({
    required this.laneId,
    required this.cards,
    required this.scrollOffset,
  });

  /// The [SwimlaneSetting.id] of the lane the card opened from.
  final String laneId;

  /// Up to [maxCards] visible cards, top first.
  final List<SwimlaneAnchorCard> cards;

  /// The lane's scroll offset when the card opened. Only a first guess when the
  /// target card is not built yet.
  final double scrollOffset;

  /// Two or three cards, not one: a sync can move one of them while the card is open.
  static const int maxCards = 3;

  /// How much the gap between two anchor cards may change and still count as "still
  /// together": one card, for the opened card that left the lane between them.
  static const int gapTolerance = 1;

  // Keyed like the horizontal offset: collection AND board (trackerId).
  static final Map<String, SwimlaneScrollAnchor> _saved = {};

  /// The key the board's persisted scroll and filter state is stored under.
  static String boardKey(String collection, String trackerId) => '$collection:$trackerId';

  static SwimlaneScrollAnchor? savedFor(String boardKey) => _saved[boardKey];

  static void save(String boardKey, SwimlaneScrollAnchor anchor) => _saved[boardKey] = anchor;

  /// Clears the anchor of [boardKey]. With [only], clears it only if it is still that
  /// anchor, so a lane that gives up never removes a newer one.
  static void clear(String boardKey, {SwimlaneScrollAnchor? only}) {
    if (only != null && !identical(_saved[boardKey], only)) return;
    _saved.remove(boardKey);
  }

  @visibleForTesting
  static void resetAll() => _saved.clear();

  /// Picks up to [maxCards] cards that are at least partly visible, top first.
  ///
  /// Skips the opened card: it is the card most likely to move (its status or lane
  /// position changes in the card detail). Uses it only if it is the only visible card.
  static List<SwimlaneMeasuredCard> pickVisible(
    Iterable<SwimlaneMeasuredCard> cards, {
    required double viewportHeight,
    String? openedId,
  }) {
    final List<SwimlaneMeasuredCard> visible = cards.where((card) => card.top < viewportHeight && card.top + card.height > 0).toList()..sort((a, b) => a.top.compareTo(b.top));
    final List<SwimlaneMeasuredCard> others = visible.where((card) => card.id != openedId).toList();
    return (others.isNotEmpty ? others : visible).take(maxCards).toList();
  }

  /// Decides what the lane does with the cards it has now, so the view returns to the
  /// cards the user was looking at, without being dragged along by one that moved.
  ///
  /// 1. An anchor card that is still next to another anchor card (same order, gap
  ///    changed by at most [gapTolerance]) wins, top first.
  /// 2. Otherwise, while anchor cards are missing and more pages can hold them: fetch more.
  ///    Paging stops one page past the deepest anchor card: without that cap a lane whose
  ///    anchor cards all left would page through the whole lane.
  /// 3. Otherwise the loaded anchor card whose index moved least, top first on a tie.
  /// 4. Otherwise give up: the lane stays at the top.
  SwimlaneAnchorStep nextStep({
    required List<String> shownIds,
    required int loadedCount,
    required bool hasMore,
    required int pageSize,
  }) {
    final Map<String, int> shownIndexOf = {for (int index = 0; index < shownIds.length; index++) shownIds[index]: index};
    final List<(SwimlaneAnchorCard, int)> present = [
      for (final SwimlaneAnchorCard card in cards)
        if (shownIndexOf[card.id] != null) (card, shownIndexOf[card.id]!),
    ];

    for (final (SwimlaneAnchorCard card, int index) in present) {
      final bool inPlace = present.any((other) => other.$1 != card && _keptTogether(card, index, other.$1, other.$2));
      if (inPlace) return SwimlaneAnchorStep.scrollTo(card);
    }

    final int deepestLoadedIndex = cards.fold(0, (deepest, card) => max(deepest, card.loadedIndex));
    if (present.length < cards.length && hasMore && loadedCount < deepestLoadedIndex + 1 + pageSize) {
      return const SwimlaneAnchorStep.fetchMore();
    }

    if (present.isNotEmpty) {
      (SwimlaneAnchorCard, int) leastMoved = present.first;
      for (final (SwimlaneAnchorCard, int) candidate in present.skip(1)) {
        if ((candidate.$2 - candidate.$1.shownIndex).abs() < (leastMoved.$2 - leastMoved.$1.shownIndex).abs()) {
          leastMoved = candidate;
        }
      }
      return SwimlaneAnchorStep.scrollTo(leastMoved.$1);
    }

    return const SwimlaneAnchorStep.giveUp();
  }

  static bool _keptTogether(SwimlaneAnchorCard a, int aIndex, SwimlaneAnchorCard b, int bIndex) {
    final int oldGap = b.shownIndex - a.shownIndex;
    final int newGap = bIndex - aIndex;
    return oldGap.sign == newGap.sign && (newGap - oldGap).abs() <= gapTolerance;
  }
}

/// Owns one lane's vertical [ScrollController] and keeps the lane at the cards the
/// user was looking at when a card opened (see [SwimlaneScrollAnchor]).
///
/// The lane calls [captureOnOpen] when a card is tapped open and [onDocuments] on each
/// build. Cards register themselves through [SwimlaneCardAnchor] so they can be measured.
class SwimlaneLaneScroll {
  SwimlaneLaneScroll({
    required this.boardKey,
    required this.laneId,
    required this.pageSize,
  }) {
    controller.addListener(_onScroll);
  }

  /// See [SwimlaneScrollAnchor.boardKey]. Updated when the lane widget is reused.
  String boardKey;

  /// The [SwimlaneSetting.id] of this lane. Updated when the lane widget is reused.
  String laneId;

  /// The lane's page size, for the paging cap.
  final int pageSize;

  final ScrollController controller = ScrollController();

  // Matches the 0.5 px tolerance of a jump; more frames than a long lane ever needs.
  static const double _placementTolerance = 0.5;
  static const int _maxPlacementFrames = 60;

  final Map<String, BuildContext> _builtCards = {};
  List<String> _shownIds = const [];
  List<String> _loadedIds = const [];
  SwimlaneScrollAnchor? _placing;
  SwimlaneAnchorCard? _target;
  // Bumped on every new placement, so a stale post-frame callback does nothing.
  int _generation = 0;
  bool _disposed = false;

  /// Called by [SwimlaneCardAnchor] when a card is built for [documentId].
  void registerCard(String documentId, BuildContext context) => _builtCards[documentId] = context;

  /// Called by [SwimlaneCardAnchor] when a card is gone or now shows another document.
  void unregisterCard(String documentId, BuildContext context) {
    // The list reuses its items by index, so another item may already hold this id.
    if (identical(_builtCards[documentId], context)) _builtCards.remove(documentId);
  }

  /// Saves the cards visible in this lane, just before the card [openedId] opens.
  void captureOnOpen(String openedId) {
    if (!controller.hasClients || controller.position.pixels <= 0) {
      // A lane at the top needs nothing kept, and a new open replaces any older anchor.
      SwimlaneScrollAnchor.clear(boardKey);
      return;
    }
    final ScrollPosition position = controller.position;
    final List<SwimlaneMeasuredCard> measured = [];
    for (final MapEntry<String, BuildContext> entry in _builtCards.entries) {
      final RenderBox? box = _renderBoxOf(entry.value);
      if (box == null) continue;
      measured.add((
        id: entry.key,
        top: RenderAbstractViewport.of(box).getOffsetToReveal(box, 0.0).offset - position.pixels,
        height: box.size.height,
      ));
    }

    final List<SwimlaneAnchorCard> cards = [];
    for (final SwimlaneMeasuredCard card in SwimlaneScrollAnchor.pickVisible(measured, viewportHeight: position.viewportDimension, openedId: openedId)) {
      final int shownIndex = _shownIds.indexOf(card.id);
      final int loadedIndex = _loadedIds.indexOf(card.id);
      if (shownIndex < 0 || loadedIndex < 0) continue;
      cards.add(SwimlaneAnchorCard(id: card.id, offsetInView: card.top, shownIndex: shownIndex, loadedIndex: loadedIndex));
    }

    if (cards.isEmpty) {
      SwimlaneScrollAnchor.clear(boardKey);
      return;
    }
    SwimlaneScrollAnchor.save(boardKey, SwimlaneScrollAnchor(laneId: laneId, cards: cards, scrollOffset: position.pixels));
    Console.log(
      "Kept lane $laneId at ${cards.map((card) => card.id).join(', ')}",
      scope: "fframeLog.Swimlanes",
      level: LogLevel.fframe,
    );
  }

  /// Called on each lane build with the cards it shows ([shownIds], filtered) and has
  /// loaded ([loadedIds]). Restores the saved anchor if it belongs to this lane.
  ///
  /// The anchor is kept after a successful restore: the board can be rebuilt again at
  /// unrelated moments, and each new lane instance must restore again. The same call
  /// also keeps the lane in place when cards move while the card is open.
  void onDocuments({
    required List<String> shownIds,
    required List<String> loadedIds,
    required bool hasMore,
    required bool isFetchingMore,
    required VoidCallback fetchMore,
  }) {
    _shownIds = shownIds;
    _loadedIds = loadedIds;

    final SwimlaneScrollAnchor? anchor = SwimlaneScrollAnchor.savedFor(boardKey);
    if (anchor == null || anchor.laneId != laneId) {
      _stopPlacing();
      return;
    }

    final SwimlaneAnchorStep step = anchor.nextStep(shownIds: shownIds, loadedCount: loadedIds.length, hasMore: hasMore, pageSize: pageSize);
    switch (step.action) {
      case SwimlaneAnchorAction.fetchMore:
        _stopPlacing();
        // Safe from build: FirestoreQueryBuilder defers its own setState.
        if (!isFetchingMore) fetchMore();
        break;
      case SwimlaneAnchorAction.giveUp:
        _stopPlacing();
        SwimlaneScrollAnchor.clear(boardKey, only: anchor);
        Console.log(
          "Lane $laneId: the kept cards left the lane, staying at the top",
          scope: "fframeLog.Swimlanes",
          level: LogLevel.fframe,
        );
        break;
      case SwimlaneAnchorAction.scrollTo:
        _placing = anchor;
        _target = step.card;
        _schedulePlacement(++_generation, 0);
        break;
    }
  }

  /// A card drag on the board means the user is working on it: stop keeping the old place.
  void onDragStarted() {
    _stopPlacing();
    SwimlaneScrollAnchor.clear(boardKey);
  }

  void dispose() {
    _disposed = true;
    _stopPlacing();
    controller.removeListener(_onScroll);
    controller.dispose();
  }

  // A scroll by the user (wheel, drag, scrollbar) drops the kept place, so a later rebuild
  // does not pull the lane back. A programmatic jumpTo goes idle first, so it never counts.
  void _onScroll() {
    if (!controller.hasClients || controller.position.userScrollDirection == ScrollDirection.idle) return;
    final SwimlaneScrollAnchor? anchor = SwimlaneScrollAnchor.savedFor(boardKey);
    if (anchor == null || anchor.laneId != laneId) return;
    _stopPlacing();
    SwimlaneScrollAnchor.clear(boardKey, only: anchor);
  }

  void _stopPlacing() {
    _generation++;
    _placing = null;
    _target = null;
  }

  void _schedulePlacement(int generation, int frame) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _place(generation, frame));
  }

  // Puts the target card at its saved distance from the lane top. A lazy list builds only
  // the cards near the viewport, so a card further away is first brought into range.
  void _place(int generation, int frame) {
    final SwimlaneAnchorCard? target = _target;
    final SwimlaneScrollAnchor? anchor = _placing;
    if (_disposed || generation != _generation || target == null || anchor == null || !controller.hasClients) return;
    if (frame >= _maxPlacementFrames) return;
    final ScrollPosition position = controller.position;

    final RenderBox? box = _builtCards[target.id] == null ? null : _renderBoxOf(_builtCards[target.id]!);
    if (box != null) {
      final double reveal = RenderAbstractViewport.of(box).getOffsetToReveal(box, 0.0).offset;
      final double desired = (reveal - target.offsetInView).clamp(position.minScrollExtent, position.maxScrollExtent);
      if ((desired - position.pixels).abs() <= _placementTolerance) return;
      controller.jumpTo(desired);
      // The list's maxScrollExtent is an estimate that can grow after the jump: check again.
      _schedulePlacement(generation, frame + 1);
      return;
    }

    final double step = position.viewportDimension * _directionTo(target.id);
    double next = (frame == 0 ? anchor.scrollOffset : position.pixels + step).clamp(position.minScrollExtent, position.maxScrollExtent);
    if (frame == 0 && (next - position.pixels).abs() <= _placementTolerance) {
      next = (position.pixels + step).clamp(position.minScrollExtent, position.maxScrollExtent);
    }
    if ((next - position.pixels).abs() <= _placementTolerance) return;
    controller.jumpTo(next);
    _schedulePlacement(generation, frame + 1);
  }

  // +1 when the target card is below the built cards, -1 when it is above them.
  double _directionTo(String documentId) {
    final int targetIndex = _shownIds.indexOf(documentId);
    final bool builtBelowTarget = _builtCards.keys.any((id) => _shownIds.indexOf(id) > targetIndex);
    return builtBelowTarget ? -1.0 : 1.0;
  }

  static RenderBox? _renderBoxOf(BuildContext context) {
    if (!context.mounted) return null;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached || !renderObject.hasSize) return null;
    return renderObject;
  }
}

/// Registers a built card with its lane's [SwimlaneLaneScroll], so the lane can measure
/// which cards are visible and scroll back to one of them.
class SwimlaneCardAnchor extends StatefulWidget {
  const SwimlaneCardAnchor({
    super.key,
    required this.laneScroll,
    required this.documentId,
    required this.child,
  });

  final SwimlaneLaneScroll laneScroll;
  final String documentId;
  final Widget child;

  @override
  State<SwimlaneCardAnchor> createState() => _SwimlaneCardAnchorState();
}

class _SwimlaneCardAnchorState extends State<SwimlaneCardAnchor> {
  @override
  void initState() {
    super.initState();
    widget.laneScroll.registerCard(widget.documentId, context);
  }

  @override
  void didUpdateWidget(covariant SwimlaneCardAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The list reuses its items by index, so this item may now show another card.
    if (oldWidget.documentId != widget.documentId || oldWidget.laneScroll != widget.laneScroll) {
      oldWidget.laneScroll.unregisterCard(oldWidget.documentId, context);
      widget.laneScroll.registerCard(widget.documentId, context);
    }
  }

  @override
  void dispose() {
    widget.laneScroll.unregisterCard(widget.documentId, context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
