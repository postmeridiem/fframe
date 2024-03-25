part of '../../fframe.dart';

class FirestoreListGrid<T> extends ConsumerStatefulWidget {
  const FirestoreListGrid({
    super.key,
    required this.documentConfig,
    required this.query,
  });

  // the configuration that was provided
  final DocumentConfig<T> documentConfig;

  /// The firestore core query that was provided
  final Query<T> query;

  @override
  FirestoreListGridState createState() => FirestoreListGridState<T>();
}

class FirestoreListGridState<T> extends ConsumerState<FirestoreListGrid<T>> {
  final ScrollController _horizontal = ScrollController();

  late List<ListGridColumn<T>> columnSettings;

  @override
  void initState() {
    Console.log(
      "Initializing ListGrid",
      scope: "fframeLog.ListGrid",
      level: LogLevel.fframe,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FirestoreListGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query.hashCode != oldWidget.query.hashCode) {
      // _query = widget.query;
      // _query = _unwrapQuery(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    // QueryState queryState = ref.watch(queryStateProvider);

    // Map<String, String> params = queryState.queryParameters ?? {};
    // bool documentOpen = params.containsKey("id");

    // if (params.containsKey("new") && params["new"] == "true") {
    //   documentOpen = true;
    // }

    return ListGridController(
      context: context,
      documentConfig: widget.documentConfig,
      viewportSize: MediaQuery.of(context).size,
      theme: Theme.of(context),
      notifier: ListGridNotifier<T>(
        documentConfig: widget.documentConfig,
        initialQuery: widget.query,
      ),
      child: Builder(
        builder: (BuildContext context) {
          return AnimatedBuilder(
              animation: ListGridController.of(context).notifier,
              builder: (context, child) {
                ListGridController listGridController = ListGridController.of(context);
                // DocumentConfig<T> documentConfig = listGridController.documentConfig as DocumentConfig<T>;
                ListGridNotifier<T> listGridNotifier = listGridController.notifier as ListGridNotifier<T>;

                // if (documentOpen) {
                //   listGridController.actionBar(false);
                // }
                return FirestoreQueryBuilder<T>(
                  pageSize: listGridController.dataMode.limit,
                  query: listGridNotifier.currentQuery,
                  builder: (
                    BuildContext context,
                    FirestoreQueryBuilderSnapshot<T> queryBuilderSnapshot,
                    Widget? child,
                  ) {
                    // int count = queryBuilderSnapshot.docs.length;
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            listGridController.enableActionBar
                                ? ListGridActionBarWidget<T>(
                                    listGridController: listGridController,
                                  )
                                : const IgnorePointer(),
                            listGridController.enableSearchBar
                                ? ListGridSearchWidget<T>(
                                    listGridController: listGridController,
                                    // documentOpen: listGridController.documentOpen,
                                  )
                                : const IgnorePointer(),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: listGridController.widgetBackgroundColor,
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: listGridController.widgetBackgroundColor,
                                    ),
                                    top: BorderSide(
                                      width: 1,
                                      color: listGridController.widgetBackgroundColor,
                                    ),
                                    right: BorderSide(
                                      width: 1,
                                      color: listGridController.widgetBackgroundColor,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: listGridController.showFooter ? 38.0 : 0.0,
                                  ),
                                  child: Scrollbar(
                                    controller: _horizontal,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: _horizontal,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          listGridController.showHeader
                                              ? ListGridHeader<T>(
                                                  calculatedWidth: listGridController.calculatedWidth,
                                                  addEndFlex: listGridController.addEndFlex,
                                                  rowsSelectable: listGridController.listGridConfig.rowsSelectable,
                                                )
                                              : const IgnorePointer(),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: listGridController.widgetBackgroundColor,
                                                border: Border(
                                                  top: BorderSide(
                                                    width: 1,
                                                    color: listGridController.widgetColor,
                                                  ),
                                                ),
                                              ),
                                              child: Container(
                                                color: (Fframe.of(context)!.getSystemThemeMode == ThemeMode.dark) ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                                                child: SizedBox(
                                                  width: listGridController.calculatedWidth,
                                                  child: queryBuilderSnapshot.hasError
                                                      ? Card(
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 500,
                                                              height: double.infinity,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(40.0),
                                                                child: SelectableText(
                                                                  "error ${queryBuilderSnapshot.error}",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : ListGridEndless<T>(
                                                          queryBuilderSnapshot: queryBuilderSnapshot,
                                                          listGridController: listGridController,
                                                        ),
                                                ),
                                              ),
                                            ),
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
                        listGridController.showFooter
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ListGridFooter<T>(
                                    viewportWidth: listGridController.viewportWidth,
                                    dataMode: listGridController.dataMode.mode,
                                  ),
                                ],
                              )
                            : const IgnorePointer(),
                        // ListGridDocument<T>(
                        //   listGridController: listGridController,
                        //   documentConfig: documentConfig,
                        //   documentOpen: documentOpen,
                        // ),
                        // if (listGridController.processing)
                        //   const Opacity(
                        //     opacity: 0.8,
                        //     child: ModalBarrier(
                        //       dismissible: false,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // if (listGridController.processing)
                        //   Center(
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         const CircularProgressIndicator(),
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text(
                        //               "${listGridController.processingProgress} documents left to process..."),
                        //         ),
                        //       ],
                        //     ),
                        //   )
                      ],
                    );
                  },
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
    return snaphot.count ?? 0;
  }
}

class ListGridEndless<T> extends StatelessWidget {
  const ListGridEndless({
    super.key,
    required this.queryBuilderSnapshot,
    required this.listGridController,
  });

  // the configuration that was provided
  final FirestoreQueryBuilderSnapshot<T> queryBuilderSnapshot;
  final ListGridController listGridController;

  @override
  Widget build(BuildContext context) {
    final ScrollController verticalScroll = ScrollController();
    return Scrollbar(
      controller: verticalScroll,
      thumbVisibility: true,
      child: ListView.separated(
        itemCount: queryBuilderSnapshot.docs.length,
        scrollDirection: Axis.vertical,
        reverse: false,
        controller: verticalScroll,
        // primary: primary,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: false,
        // itemExtent: itemExtent,
        // prototypeItem: prototypeItem,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
        // cacheExtent: cacheExtent,
        // cacheExtent: 1000,
        // semanticChildCount: semanticChildCount,
        dragStartBehavior: DragStartBehavior.start,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        // restorationId: restorationId,
        clipBehavior: Clip.hardEdge,
        separatorBuilder: (context, index) {
          return const IgnorePointer();
        },
        itemBuilder: (context, index) {
          final isLastItem = index + 1 == queryBuilderSnapshot.docs.length;
          if (isLastItem && queryBuilderSnapshot.hasMore) {
            queryBuilderSnapshot.fetchMore();
          }

          final DocumentSnapshot<T> documentSnapshot = queryBuilderSnapshot.docs[index];

          final SelectedDocument<T> selectedDocument = SelectedDocument(
            id: documentSnapshot.id,
            documentConfig: listGridController.documentConfig as DocumentConfig<T>,
            data: documentSnapshot.data(),
          );
          // final String documentId = selectedDocument.id;
          // final T document = queryDocumentSnapshot.data();

          return Table(
              columnWidths: listGridController.columnWidths,
              // defaultColumnWidth: const FlexColumnWidth(),
              defaultVerticalAlignment: listGridController.cellVerticalAlignment,
              textBaseline: TextBaseline.alphabetic,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: listGridController.cellBackgroundColor,
                    // border: Border(
                    //   bottom: BorderSide(
                    //     color: widgetBackgroundColor,
                    //     width: rowBorder,
                    //   ),
                    // ),
                  ),
                  children: renderRow(
                    context: context,
                    selectedDocument: selectedDocument,
                    columnSettings: listGridController.columnSettings as List<ListGridColumn<T>>,
                    addEndFlex: listGridController.addEndFlex,
                    rowsSelectable: listGridController.listGridConfig.rowsSelectable,
                  ),
                ),
              ]);
        },
      ),
    );
  }

  List<Widget> renderRow({
    required BuildContext context,
    required SelectedDocument<T> selectedDocument,
    required List<ListGridColumn<T>> columnSettings,
    required bool addEndFlex,
    required bool rowsSelectable,
  }) {
    // ListGridController listGridController = ListGridController.of(context);
    List<Widget> output = [];

    // if (listGridController.documentOpen) {
    //   ListGridColumn<T> columnSetting = columnSettings[0];
    //   if (columnSetting.cellBuilder != null) {
    //     Widget cellWidget = columnSetting.cellBuilder!(context, document.data, () {});
    //     output.add(
    //       ListGridBuilderCell<T>(
    //         listGridController: listGridController,
    //         document: document,
    //         column: columnSetting,
    //         cellWidget: cellWidget,
    //       ),
    //     );
    //   } else if (columnSetting.valueBuilder != null) {
    //     dynamic dynValue = columnSetting.valueBuilder!(context, document.data as T);
    //     output.add(
    //       ListGridDataCell<T>(
    //         listGridController: listGridController,
    //         document: document,
    //         column: columnSetting,
    //         dynValue: dynValue,
    //       ),
    //     );
    //   } else {
    //     dynamic dynValue = "undefined";
    //     output.add(
    //       ListGridDataCell<T>(
    //         listGridController: listGridController,
    //         document: document,
    //         column: columnSetting,
    //         dynValue: dynValue,
    //       ),
    //     );
    //   }
    // } else {
    if (rowsSelectable) {
      output.add(
        ListGridRowSelector<T>(selectedDocument: selectedDocument),
      );
    }

    for (ListGridColumn<T> columnSetting in columnSettings) {
      if (columnSetting.visible) {
        if (columnSetting.cellBuilder != null) {
          Widget cellWidget = columnSetting.cellBuilder!(context, selectedDocument.data, () {});
          output.add(
            ListGridBuilderCell<T>(
              listGridController: listGridController,
              column: columnSetting,
              selectedDocument: selectedDocument,
              cellWidget: cellWidget,
            ),
          );
        } else if (columnSetting.valueBuilder != null) {
          dynamic dynValue = columnSetting.valueBuilder!(context, selectedDocument.data);
          output.add(
            ListGridDataCell<T>(
              listGridController: listGridController,
              selectedDocument: selectedDocument,
              column: columnSetting,
              dynValue: dynValue,
            ),
          );
        } else {
          output.add(
            ListGridDataCell<T>(
              listGridController: listGridController,
              selectedDocument: selectedDocument,
              column: columnSetting,
              dynValue: const Text("undefined"),
            ),
          );
        }
      }
    }
    if (addEndFlex) {
      output.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.bottom,
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.green,
              color: listGridController.cellBackgroundColor,
              border: Border(
                bottom: listGridController.rowBorder > 0
                    ? BorderSide(
                        color: listGridController.widgetBackgroundColor,
                        width: listGridController.rowBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: listGridController.cellPadding,
              child: const IgnorePointer(),
              // child: const Text("cell"),
            ),
          ),
        ),
      );
    }
    // }
    return output;
  }
}
