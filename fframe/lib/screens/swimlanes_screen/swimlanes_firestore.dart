part of 'package:fframe/fframe.dart';

class FirestoreSwimlanes<T> extends StatefulWidget {
  const FirestoreSwimlanes({
    super.key,
    required this.documentConfig,
    required this.query,
  });

  // the configuration that was provided
  // the configuration that was provided
  final DocumentConfig<T> documentConfig;
  // final SwimlanesConfig<T> config;

  /// The firestore core query that was provided
  final Query<T> query;

  @override
  FirestoreSwimlanesState createState() => FirestoreSwimlanesState<T>();
}

class FirestoreSwimlanesState<T> extends State<FirestoreSwimlanes<T>> {
  late List<SwimlaneSetting<T>> swimlaneSettings;

  // Owned here (not in the per-build InheritedModel) so a single instance lives
  // for the lifetime of this screen and is disposed on teardown.
  late final SwimlanesNotifier<T> _notifier;
  late final DragAutoScrollService _dragAutoScrollService;

  @override
  void initState() {
    Console.log(
      "Initializing Swimlanes",
      scope: "fframeLog.Swimlanes",
      level: LogLevel.fframe,
    );
    _dragAutoScrollService = DragAutoScrollService();
    _notifier = SwimlanesNotifier<T>(
      sourceQuery: widget.query,
      swimlaneSettings: (widget.documentConfig.swimlanes as SwimlanesConfig<T>).swimlaneSettings,
    );
    super.initState();
  }

  @override
  void dispose() {
    _notifier.dispose();
    _dragAutoScrollService.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FirestoreSwimlanes<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query.hashCode != oldWidget.query.hashCode) {
      // _query = widget.query;
      // _query = _unwrapQuery(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwimlanesController(
      context: context,
      sourceQuery: widget.query,
      swimlanesConfig: widget.documentConfig.swimlanes as SwimlanesConfig<T>,
      viewportSize: MediaQuery.of(context).size,
      theme: Theme.of(context),
      notifier: _notifier,
      dragAutoScrollService: _dragAutoScrollService,
      child: Builder(
        builder: (BuildContext context) {
          SwimlanesController swimlanesController = SwimlanesController.of(context);
          return SwimlaneBuilder<T>(
            swimlanesController: swimlanesController,
            documentConfig: DocumentScreenConfig.of(context)?.documentConfig as DocumentConfig<T>,
            swimlanesConfig: swimlanesController.swimlanesConfig as SwimlanesConfig<T>,
          );
          // });
        },
      ),
    );
  }

  double calculateWidth(double calculatedMinWidth, double viewportWidth) {
    double calculatedWidth = calculatedMinWidth > viewportWidth ? calculatedMinWidth : viewportWidth;
    return calculatedWidth;
  }

  double getViewportWidth(BuildContext context) {
    double viewportWidth = ((MediaQuery.of(context).size.width > 1000) ? (MediaQuery.of(context).size.width - 100) : (MediaQuery.of(context).size.width + 0));
    return viewportWidth;
  }

  Future<int> countQueryResult({required Query<T> query}) async {
    AggregateQuerySnapshot snaphot = await query.count().get();
    return snaphot.count!;
  }
}

class SwimlaneBuilder<T> extends StatefulWidget {
  const SwimlaneBuilder({
    super.key,
    required this.documentConfig,
    required this.swimlanesController,
    required this.swimlanesConfig,
  });
  final DocumentConfig<T> documentConfig;
  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;

  @override
  State<SwimlaneBuilder<T>> createState() => _SwimlaneBuilderState<T>();
}

class _SwimlaneBuilderState<T> extends State<SwimlaneBuilder<T>> {
  // Persists scroll offsets across state disposal (caused by DocumentScreen
  // rebuilds on route changes). Keyed by collection name.
  static final Map<String, double> _savedOffsets = {};

  // Persists filter state across state disposal, following the same pattern.
  static final Map<String, SwimlanesFilterType> _savedFilters = {};
  static final Map<String, FFrameUser?> _savedAssignedToUsers = {};

  final ScrollController _horizontal = ScrollController();

  // Keyed by collection AND board (trackerId): several boards can share one
  // collection, so keying by collection alone leaked scroll/filter state — and
  // a filter restored onto a board that cannot satisfy it would crash.
  String get _scrollKey => '${widget.documentConfig.collection}:${widget.swimlanesConfig.trackerId}';

  /// Whether this board's config can satisfy [filter]; used to coerce a restored
  /// filter the current board does not support down to `unfiltered`.
  bool _boardSupportsFilter(SwimlanesFilterType filter) {
    final SwimlanesConfig config = widget.swimlanesConfig;
    switch (filter) {
      case SwimlanesFilterType.assignedToMe:
      case SwimlanesFilterType.assignedTo:
        return config.assignee != null;
      case SwimlanesFilterType.followedTasks:
        return config.following != null;
      case SwimlanesFilterType.prioHigh:
      case SwimlanesFilterType.prioNormal:
      case SwimlanesFilterType.prioLow:
        return config.getPriority != null;
      case SwimlanesFilterType.customFilter:
        return config.customFilter != null;
      default:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.swimlanesController.dragAutoScrollService
        .attachHorizontalController(_horizontal);

    // Restore saved scroll position after layout
    final saved = _savedOffsets[_scrollKey];
    if (saved != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_horizontal.hasClients && _horizontal.position.maxScrollExtent >= saved) {
          _horizontal.jumpTo(saved);
        }
      });
    }

    _horizontal.addListener(_onScroll);

    // Listen to filter changes to persist them
    widget.swimlanesController.notifier.addListener(_onFilterChange);

    // Restore saved filter state
    final savedFilter = _savedFilters[_scrollKey];
    if (savedFilter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final user = _savedAssignedToUsers[_scrollKey];
        // Coerce a restored filter this board cannot satisfy (e.g. a priority
        // filter on a board without getPriority) down to unfiltered so the
        // filter switch never force-unwraps a null config.
        final effectiveFilter = _boardSupportsFilter(savedFilter) ? savedFilter : SwimlanesFilterType.unfiltered;
        if (effectiveFilter == SwimlanesFilterType.assignedTo && user != null) {
          widget.swimlanesController.notifier.setAssignedToFilter(user);
        } else {
          widget.swimlanesController.notifier.setFilter(effectiveFilter);
        }
      });
    }
  }

  void _onScroll() {
    _savedOffsets[_scrollKey] = _horizontal.offset;
  }

  void _onFilterChange() {
    _savedFilters[_scrollKey] = widget.swimlanesController.notifier.filter;
    _savedAssignedToUsers[_scrollKey] = widget.swimlanesController.notifier.assignedToUser;
  }

  @override
  void dispose() {
    _horizontal.removeListener(_onScroll);
    widget.swimlanesController.notifier.removeListener(_onFilterChange);
    widget.swimlanesController.dragAutoScrollService
        .detachHorizontalController();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Listener(
                onPointerMove: (PointerMoveEvent event) {
                  // Only trigger auto-scroll when actively dragging a card
                  if (widget.swimlanesController.isDragging) {
                    widget.swimlanesController.dragAutoScrollService
                        .onDragUpdate(event.position, context);
                  }
                },
                onPointerUp: (_) {
                  widget.swimlanesController.dragAutoScrollService.onDragEnd();
                },
                onPointerCancel: (_) {
                  widget.swimlanesController.dragAutoScrollService.onDragEnd();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.swimlanesController.swimlaneBackgroundColor,
                  ),
                  child: Scrollbar(
                    controller: _horizontal,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwimlaneHeaders<T>(
                            swimlanesController: widget.swimlanesController,
                            documentConfig: widget.documentConfig,
                            swimlanesConfig: widget.swimlanesConfig,
                          ),
                          Swimlanes<T>(
                            swimlanesController: widget.swimlanesController,
                            documentConfig: widget.documentConfig,
                            swimlanesConfig: widget.swimlanesConfig,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
