part of fframe;

class FirestoreSwimlanes<T> extends ConsumerStatefulWidget {
  const FirestoreSwimlanes({
    Key? key,
    required this.config,
    required this.query,
  }) : super(key: key);

  // the configuration that was provided
  final SwimlanesConfig<T> config;

  /// The firestore core query that was provided
  final Query<T> query;

  @override
  FirestoreSwimlanesState createState() => FirestoreSwimlanesState<T>();
}

class FirestoreSwimlanesState<T> extends ConsumerState<FirestoreSwimlanes<T>> {
  final ScrollController _horizontal = ScrollController();

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

    // setting basic priority if prio is the same: oldest goes first
    Query<T> sourceQuery =
        widget.query.orderBy("creationDate", descending: false);

    return SwimlanesController(
      context: context,
      sourceQuery: sourceQuery,
      config: widget.config,
      documentOpen: documentOpen,
      viewportSize: MediaQuery.of(context).size,
      theme: Theme.of(context),
      child: Builder(
        builder: (BuildContext context) {
          return AnimatedBuilder(
              animation: SwimlanesController.of(context).notifier,
              builder: (context, child) {
                DocumentConfig<SwimlanesTask> documentConfig =
                    DocumentScreenConfig.of(context)?.documentConfig
                        as DocumentConfig<SwimlanesTask>;
                SwimlanesController swimlanes = SwimlanesController.of(context);

                return FirestoreQueryBuilder<SwimlanesTask>(
                    query: swimlanes.currentQuery as Query<SwimlanesTask>,
                    pageSize: 100,
                    builder: (context, snapshot, child) {
                      // queryBuilderSnapshot.
                      if (snapshot.hasError) {
                        return Card(
                          child: Center(
                            child: SizedBox(
                              width: 500,
                              height: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  children: [
                                    const Opacity(
                                      opacity: 0.1,
                                      child: Icon(
                                        Icons.error_outlined,
                                        size: 256,
                                      ),
                                    ),
                                    SelectableText(
                                      "error ${snapshot.error}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.hasData) {
                          int taskCount = snapshot.docs.length;

                          for (var i = 0; i < taskCount; i++) {
                            SwimlanesTask currentTask = snapshot.docs[i].data();
                            swimlanes.database.registerTask(currentTask);
                          }
                          return Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            swimlanes.swimlaneBackgroundColor,
                                      ),
                                      child: Scrollbar(
                                        controller: _horizontal,
                                        thumbVisibility: true,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: _horizontal,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SwimlaneHeaders(
                                                  swimlanes: swimlanes),
                                              Swimlanes(swimlanes: swimlanes),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // swimlanes.showFooter
                              //     ? Column(
                              //         mainAxisAlignment: MainAxisAlignment.end,
                              //         children: [
                              //           SwimlanesFooter(
                              //             viewportWidth:
                              //                 swimlanes.viewportWidth,
                              //           ),
                              //         ],
                              //       )
                              //     : const IgnorePointer(),
                              SwimlanesDocument(
                                swimlanes: swimlanes,
                                documentConfig: documentConfig,
                                documentOpen: documentOpen,
                              ),
                            ],
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.only(top: 64.0),
                            child: Center(
                              child: SizedBox(
                                width: 500,
                                height: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: Column(
                                    children: [
                                      Opacity(
                                        opacity: 0.1,
                                        child: Icon(
                                          Icons.table_chart_outlined,
                                          size: 256,
                                        ),
                                      ),
                                      SelectableText(
                                        "Loading...",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    });
              });
        },
      ),
    );
  }

  double calculateWidth(double calculatedMinWidth, double viewportWidth) {
    double calculatedWidth =
        calculatedMinWidth > viewportWidth ? calculatedMinWidth : viewportWidth;
    return calculatedWidth;
  }

  double getViewportWidth(BuildContext context) {
    double viewportWidth = ((MediaQuery.of(context).size.width > 1000)
        ? (MediaQuery.of(context).size.width - 100)
        : (MediaQuery.of(context).size.width + 0));
    return viewportWidth;
  }

  Future<int> countQueryResult({required Query<T> query}) async {
    AggregateQuerySnapshot snaphot = await query.count().get();
    return snaphot.count;
  }
}
