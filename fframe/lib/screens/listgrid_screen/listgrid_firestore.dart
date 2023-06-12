part of fframe;

class FirestoreListGrid<T> extends ConsumerStatefulWidget {
  const FirestoreListGrid({
    Key? key,
    required this.config,
    required this.query,
  }) : super(key: key);

  final ListGridConfig config;

  /// The firestore core query that was provided
  final Query<T> query;

  @override
  FirestoreListGridState createState() => FirestoreListGridState<T>();
}

class FirestoreListGridState<T> extends ConsumerState<FirestoreListGrid<T>> {
  // final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

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
    QueryState queryState = ref.watch(queryStateProvider);

    Map<String, String> params = queryState.queryParameters ?? {};
    bool documentOpen = params.containsKey("id");

    return ListGridController(
      context: context,
      documentOpen: documentOpen,
      sourceQuery: widget.query,
      config: widget.config,
      viewportSize: MediaQuery.of(context).size,
      theme: Theme.of(context),
      child: Builder(builder: (context) {
        return AnimatedBuilder(
            animation: ListGridController.of(context).notifier,
            builder: (context, child) {
              ListGridController listgrid = ListGridController.of(context);
              DocumentConfig<T> documentConfig =
                  DocumentScreenConfig.of(context)?.documentConfig
                      as DocumentConfig<T>;

              if (documentOpen) {
                listgrid.actionBar(false);
              }
              return FirestoreQueryBuilder<T>(
                pageSize: listgrid.dataMode.limit,
                query: ListGridController.of(context).currentQuery as Query<T>,
                builder: (context, snapshot, child) {
                  // int count = snapshot.docs.length;
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          listgrid.enableActionBar
                              ? ListGridActionBarWidget(
                                  listgrid: listgrid,
                                )
                              : const IgnorePointer(),
                          listgrid.enableSearchBar
                              ? ListGridSearchWidget(
                                  listgrid: listgrid,
                                  documentOpen: listgrid.documentOpen,
                                )
                              : const IgnorePointer(),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: listgrid.widgetBackgroundColor,
                                    border: Border(
                                      left: BorderSide(
                                        width: 1,
                                        color: listgrid.widgetBackgroundColor,
                                      ),
                                      top: BorderSide(
                                        width: 1,
                                        color: listgrid.widgetBackgroundColor,
                                      ),
                                      right: BorderSide(
                                        width: 1,
                                        color: listgrid.widgetBackgroundColor,
                                      ),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        listgrid.showHeader
                                            ? ListGridHeader(
                                                calculatedWidth:
                                                    listgrid.calculatedWidth,
                                                addEndFlex: listgrid.addEndFlex,
                                                rowsSelectable: listgrid
                                                    .config.rowsSelectable,
                                              )
                                            : const IgnorePointer(),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: listgrid
                                                  .widgetBackgroundColor,
                                              border: Border(
                                                top: BorderSide(
                                                  width: 1,
                                                  color: listgrid.widgetColor,
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              color: (Fframe.of(context)!
                                                          .getSystemThemeMode ==
                                                      ThemeMode.dark)
                                                  ? Colors.black
                                                      .withOpacity(0.2)
                                                  : Colors.white
                                                      .withOpacity(0.2),
                                              child: SizedBox(
                                                width: documentOpen
                                                    ? 300
                                                    : listgrid.calculatedWidth,
                                                child: snapshot.hasError
                                                    ? Card(
                                                        child: Center(
                                                          child: SizedBox(
                                                            width: 500,
                                                            height:
                                                                double.infinity,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      40.0),
                                                              child:
                                                                  SelectableText(
                                                                "error ${snapshot.error}",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Scrollbar(
                                                        controller: _vertical,
                                                        child:
                                                            ListView.separated(
                                                          itemCount: snapshot
                                                              .docs.length,
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const IgnorePointer();
                                                          },
                                                          itemBuilder:
                                                              (context, index) {
                                                            final isLastItem =
                                                                index + 1 ==
                                                                    snapshot
                                                                        .docs
                                                                        .length;
                                                            if (isLastItem &&
                                                                snapshot
                                                                    .hasMore) {
                                                              snapshot
                                                                  .fetchMore();
                                                            }

                                                            final queryDocumentSnapshot =
                                                                snapshot.docs[
                                                                    index];
                                                            final String
                                                                documentId =
                                                                queryDocumentSnapshot
                                                                    .id;
                                                            final T document =
                                                                queryDocumentSnapshot
                                                                    .data();

                                                            return Table(
                                                                columnWidths:
                                                                    listgrid
                                                                        .columnWidths,
                                                                // defaultColumnWidth: const FlexColumnWidth(),
                                                                defaultVerticalAlignment:
                                                                    listgrid
                                                                        .cellVerticalAlignment,
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .alphabetic,
                                                                children: [
                                                                  TableRow(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: listgrid
                                                                          .cellBackgroundColor,
                                                                      // border: Border(
                                                                      //   bottom: BorderSide(
                                                                      //     color: widgetBackgroundColor,
                                                                      //     width: rowBorder,
                                                                      //   ),
                                                                      // ),
                                                                    ),
                                                                    children:
                                                                        renderRow(
                                                                      context:
                                                                          context,
                                                                      documentId:
                                                                          documentId,
                                                                      queryDocumentSnapshot:
                                                                          queryDocumentSnapshot,
                                                                      document:
                                                                          document,
                                                                      columnSettings: listgrid
                                                                              .columnSettings
                                                                          as List<
                                                                              ListGridColumn<T>>,
                                                                      addEndFlex:
                                                                          listgrid
                                                                              .addEndFlex,
                                                                      rowsSelectable: listgrid
                                                                          .config
                                                                          .rowsSelectable,
                                                                    ),
                                                                  ),
                                                                ]);
                                                          },
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          reverse: false,
                                                          controller: _vertical,
                                                          // primary: primary,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: false,
                                                          // itemExtent: itemExtent,
                                                          // prototypeItem: prototypeItem,
                                                          addAutomaticKeepAlives:
                                                              true,
                                                          addRepaintBoundaries:
                                                              true,
                                                          addSemanticIndexes:
                                                              true,
                                                          // cacheExtent: cacheExtent,
                                                          // cacheExtent: 1000,
                                                          // semanticChildCount: semanticChildCount,
                                                          dragStartBehavior:
                                                              DragStartBehavior
                                                                  .start,
                                                          keyboardDismissBehavior:
                                                              ScrollViewKeyboardDismissBehavior
                                                                  .manual,
                                                          // restorationId: restorationId,
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        listgrid.showFooter
                                            ? ListGridFooter(
                                                viewportWidth:
                                                    listgrid.viewportWidth,
                                                dataMode:
                                                    listgrid.dataMode.mode,
                                              )
                                            : const IgnorePointer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      listgrid.showFooter
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ListGridFooter(
                                  viewportWidth: listgrid.viewportWidth,
                                  dataMode: listgrid.dataMode.mode,
                                ),
                              ],
                            )
                          : const IgnorePointer(),
                      ListGridDocument(
                        listgrid: listgrid,
                        documentConfig: documentConfig,
                        documentOpen: documentOpen,
                      ),
                    ],
                  );
                },
              );
            });
      }),
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

  List<Widget> renderRow({
    required BuildContext context,
    required String documentId,
    required QueryDocumentSnapshot<T> queryDocumentSnapshot,
    required T document,
    required List<ListGridColumn<T>> columnSettings,
    required bool addEndFlex,
    required bool rowsSelectable,
  }) {
    ListGridController listgrid = ListGridController.of(context);
    List<Widget> output = [];

    if (listgrid.documentOpen) {
      ListGridColumn<T> column = columnSettings[0];
      if (column.cellBuilder != null) {
        dynamic cellWidget = column.cellBuilder!(context, document);
        output.add(
          ListGridBuilderCell<T>(
            listgrid: listgrid,
            column: column,
            queryDocumentSnapshot: queryDocumentSnapshot,
            document: document,
            cellWidget: cellWidget,
          ),
        );
      } else if (column.valueBuilder != null) {
        dynamic dynValue = column.valueBuilder!(context, document);
        output.add(
          ListGridDataCell<T>(
            listgrid: listgrid,
            column: column,
            queryDocumentSnapshot: queryDocumentSnapshot,
            document: document,
            dynValue: dynValue,
          ),
        );
      } else {
        dynamic dynValue = "undefined";
        output.add(
          ListGridDataCell<T>(
            listgrid: listgrid,
            column: column,
            queryDocumentSnapshot: queryDocumentSnapshot,
            document: document,
            dynValue: dynValue,
          ),
        );
      }
    } else {
      if (rowsSelectable) {
        output.add(
          ListGridRowSelector(
              listgrid: listgrid, documentId: documentId, document: document),
        );
      }
      for (ListGridColumn<T> column in columnSettings) {
        if (column.visible) {
          if (column.cellBuilder != null) {
            dynamic cellWidget = column.cellBuilder!(context, document);
            output.add(
              ListGridBuilderCell<T>(
                listgrid: listgrid,
                column: column,
                queryDocumentSnapshot: queryDocumentSnapshot,
                document: document,
                cellWidget: cellWidget,
              ),
            );
          } else if (column.valueBuilder != null) {
            dynamic dynValue = column.valueBuilder!(context, document);
            output.add(
              ListGridDataCell<T>(
                listgrid: listgrid,
                column: column,
                queryDocumentSnapshot: queryDocumentSnapshot,
                document: document,
                dynValue: dynValue,
              ),
            );
          } else {
            dynamic dynValue = "undefined";
            output.add(
              ListGridDataCell<T>(
                listgrid: listgrid,
                column: column,
                queryDocumentSnapshot: queryDocumentSnapshot,
                document: document,
                dynValue: dynValue,
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
                color: listgrid.cellBackgroundColor,
                border: Border(
                  bottom: listgrid.rowBorder > 0
                      ? BorderSide(
                          color: listgrid.widgetBackgroundColor,
                          width: listgrid.rowBorder,
                        )
                      : BorderSide.none,
                ),
              ),
              child: Padding(
                padding: listgrid.cellPadding,
                child: const IgnorePointer(),
                // child: const Text("cell"),
              ),
            ),
          ),
        );
      }
    }

    return output;
  }

  Future<int> countQueryResult({required Query<T> query}) async {
    AggregateQuerySnapshot snaphot = await query.count().get();
    return snaphot.count;
  }
}
