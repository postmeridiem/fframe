part of '../../fframe.dart';

class FirestoreSwimlanes<T> extends ConsumerStatefulWidget {
  const FirestoreSwimlanes({
    super.key,
    required this.config,
    required this.query,
  });

  // the configuration that was provided
  final SwimlanesConfig<T> config;

  /// The firestore core query that was provided
  final Query<T> query;

  @override
  FirestoreSwimlanesState createState() => FirestoreSwimlanesState<T>();
}

class FirestoreSwimlanesState<T> extends ConsumerState<FirestoreSwimlanes<T>> {
  late List<SwimlaneSetting<T>> swimlaneSettings;

  @override
  void initState() {
    Console.log(
      "Initializing Swimlanes",
      scope: "fframeLog.Swimlanes",
      level: LogLevel.fframe,
    );
    super.initState();
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
    QueryState queryState = ref.watch(queryStateProvider);

    Map<String, String> params = queryState.queryParameters ?? {};
    bool documentOpen = params.containsKey("id");

    return SwimlanesController(
      context: context,
      sourceQuery: widget.query,
      swimlanesConfig: widget.config,
      documentOpen: documentOpen,
      viewportSize: MediaQuery.of(context).size,
      theme: Theme.of(context),
      child: Builder(
        builder: (BuildContext context) {
          return AnimatedBuilder(
              animation: SwimlanesController.of(context).notifier,
              builder: (context, child) {
                SwimlanesController swimlanesController = SwimlanesController.of(context);
                return SwimlaneBuilder<T>(
                  swimlanesController: swimlanesController,
                  documentConfig: DocumentScreenConfig.of(context)?.documentConfig as DocumentConfig<T>,
                  swimlanesConfig: swimlanesController.swimlanesConfig as SwimlanesConfig<T>,
                );
              });
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
  final ScrollController _horizontal = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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
                        // widget.swimlanesConfig.showFooter
                        //     ? Column(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           SwimlanesFooter(
                        //             viewportWidth: swimlanes.viewportWidth,
                        //           ),
                        //         ],
                        //       )
                        //     : const IgnorePointer(),
                      ],
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
