part of fframe;

class FirestoreListGrid<T> extends StatefulWidget {
  const FirestoreListGrid({
    Key? key,
    required this.listGridConfig,
    required this.query,
  }) : super(key: key);

  final ListGridConfig listGridConfig;

  /// The firestore query that will be displayed
  final Query<T> query;
  @override
  FirestoreListGridState createState() => FirestoreListGridState<T>();
}

class FirestoreListGridState<T> extends State<FirestoreListGrid<T>> {
  // final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  late List<ListGridColumn<T>> columnSettings;

  late Query<T> _query;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
  }

  @override
  void didUpdateWidget(covariant FirestoreListGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query.hashCode != oldWidget.query.hashCode) {
      _query = widget.query;
      // _query = _unwrapQuery(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    ListGridConfig listGridConfig = widget.listGridConfig;
    columnSettings = listGridConfig.columnSettings as List<ListGridColumn<T>>;
    double calculatedMinWidth = 0;
    //extract column widths from settings for flutter Table
    Map<int, TableColumnWidth> columnWidths = {};

    // track if all columns have fixed width
    // if so, add an extra blank column at the end with flex
    // to fill the screen
    bool addEndFlex = true;
    int columnCount = 0;
    for (var i = 0; i < columnSettings.length; i++) {
      columnCount += 1;
      // get the settings for the current column
      ListGridColumn columnSetting = columnSettings[i];
      // add this column's width to the min width.
      // each flex column will add the default column width
      // unless specified otherwise
      calculatedMinWidth += columnSetting.columnWidth;

      // apply the sizing enum to actual table column widths
      if (columnSetting.columnSizing == ListGridColumnSizingMode.flex) {
        addEndFlex = false;
        columnWidths.addAll({i: const FlexColumnWidth(1)});
      } else {
        columnWidths.addAll({i: FixedColumnWidth(columnSetting.columnWidth)});
      }
    }
    if (addEndFlex) {
      columnWidths.addAll({columnCount: const FlexColumnWidth(1)});
    }
    double viewportWidth = getViewportWidth(context);
    double calculatedWidth = calculateWidth(calculatedMinWidth, viewportWidth);
    // calculatedWidth = (calculatedMinWidth * 2);

    // Query<T> computedQuery = _query.orderBy("creationDate", descending: true);
    Query<T> computedQuery = _query;

    // Future<int> collectionCount = countQueryResult(query: computedQuery);
    // collectionCount.then(
    //   (value) {
    //     setState(() {
    //       _count = value;
    //     });
    //   },
    // );
    void getCollectionCount(
        {required BuildContext context,
        required ListGridController controller,
        required Query<T> query}) async {
      AggregateQuerySnapshot snapshot = await query.count().get();
      int collectionCount = snapshot.count;
      controller.collectionCount = collectionCount;
      controller.updateShouldNotify(controller);
    }

    return ListGridController(
      listGridConfig: listGridConfig,
      columnSettings: columnSettings,
      columnWidths: columnWidths,
      viewportSize: MediaQuery.of(context).size,
      theme: Theme.of(context),
      child: FirestoreQueryBuilder<T>(
        pageSize: listGridConfig.dataMode.limit,
        query: computedQuery,
        builder: (context, snapshot, child) {
          ListGridController listgrid = ListGridController.of(context);
          // int count = snapshot.docs.length;
          getCollectionCount(
              context: context,
              controller: ListGridController.of(context),
              query: computedQuery);
          return Stack(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListGridHeader(
                        calculatedWidth: calculatedWidth,
                        addEndFlex: addEndFlex,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: listgrid.widgetBackgroundColor,
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: listgrid.widgetColor,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: calculatedWidth,
                            child: snapshot.hasError
                                ? Card(
                                    child: SizedBox(
                                      width: 500,
                                      height: double.infinity,
                                      child: Text(
                                        "error ${snapshot.error}",
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  )
                                : Scrollbar(
                                    controller: _vertical,
                                    child: ListView.separated(
                                      itemCount: snapshot.docs.length,
                                      separatorBuilder: (context, index) {
                                        return const IgnorePointer();
                                      },
                                      itemBuilder: (context, index) {
                                        final isLastItem =
                                            index + 1 == snapshot.docs.length;
                                        if (isLastItem && snapshot.hasMore) {
                                          snapshot.fetchMore();
                                        }

                                        final queryDocumentSnapshot =
                                            snapshot.docs[index];
                                        final T rowdata =
                                            queryDocumentSnapshot.data();
                                        return Table(
                                            columnWidths: listgrid.columnWidths,
                                            // defaultColumnWidth: const FlexColumnWidth(),
                                            defaultVerticalAlignment:
                                                listgrid.cellVerticalAlignment,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              TableRow(
                                                decoration: BoxDecoration(
                                                  color: listgrid
                                                      .cellBackgroundColor,
                                                  // border: Border(
                                                  //   bottom: BorderSide(
                                                  //     color: widgetBackgroundColor,
                                                  //     width: rowBorder,
                                                  //   ),
                                                  // ),
                                                ),
                                                children: renderRow(
                                                  context: context,
                                                  rowdata: rowdata,
                                                  columnSettings:
                                                      columnSettings,
                                                  addEndFlex: addEndFlex,
                                                ),
                                              ),
                                            ]);
                                      },
                                      scrollDirection: Axis.vertical,
                                      reverse: false,
                                      controller: _vertical,
                                      // primary: primary,
                                      // physics: physics,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: false,
                                      // padding: padding,
                                      // // itemExtent: itemExtent,
                                      // // prototypeItem: prototypeItem,
                                      addAutomaticKeepAlives: true,
                                      addRepaintBoundaries: true,
                                      addSemanticIndexes: true,
                                      // cacheExtent: cacheExtent,
                                      // cacheExtent: 1000,
                                      // semanticChildCount: semanticChildCount,
                                      dragStartBehavior:
                                          DragStartBehavior.start,
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .manual,
                                      // restorationId: restorationId,
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      listGridConfig.showFooter
                          ? ListGridFooter(
                              viewportWidth: viewportWidth,
                              dataMode: listGridConfig.dataMode.mode,
                            )
                          : const IgnorePointer(),
                    ],
                  ),
                ),
              ),
              listGridConfig.showFooter
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListGridFooter(
                          viewportWidth: viewportWidth,
                          dataMode: listGridConfig.dataMode.mode,
                        ),
                      ],
                    )
                  : const IgnorePointer(),
            ],
          );
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

  List<Widget> renderRow({
    required BuildContext context,
    required T rowdata,
    required List<ListGridColumn<T>> columnSettings,
    required bool addEndFlex,
  }) {
    ListGridController listgrid = ListGridController.of(context);
    List<Widget> output = [];
    for (ListGridColumn<T> column in columnSettings) {
      if (column.cellBuilder != null) {
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
                child: column.cellBuilder!(context, rowdata),
                // child: const Text("cell"),
              ),
            ),
          ),
        );
      } else if (column.valueBuilder != null) {
        dynamic dynValue = column.valueBuilder!(context, rowdata);
        String stringValue = "$dynValue";
        output.add(
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.green,
                color: listgrid.cellBackgroundColor,
                border: Border(
                  right: listgrid.cellBorder > 0
                      ? BorderSide(
                          color: listgrid.widgetBackgroundColor,
                          width: listgrid.cellBorder,
                        )
                      : BorderSide.none,
                  bottom: listgrid.rowBorder > 0
                      ? BorderSide(
                          color: listgrid.widgetBackgroundColor,
                          width: listgrid.rowBorder,
                        )
                      : BorderSide.none,
                ),
              ),
              child: column.generateTooltip
                  ? Tooltip(
                      message: prepTooltip(stringValue),
                      child: Padding(
                        padding: listgrid.cellPadding,
                        child: column.textSelectable
                            ? SelectableText(
                                stringValue,
                                textAlign: column.textAlign,
                                style: listgrid.defaultTextStyle,
                                // overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                stringValue,
                                textAlign: column.textAlign,
                                style: listgrid.defaultTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                        // child: const Text("cell"),
                      ),
                    )
                  : Padding(
                      padding: listgrid.cellPadding,
                      child: column.textSelectable
                          ? SelectableText(
                              stringValue,
                              textAlign: column.textAlign,
                              style: listgrid.defaultTextStyle,
                              // overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              stringValue,
                              textAlign: column.textAlign,
                              style: listgrid.defaultTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                      // child: const Text("cell"),
                    ),
            ),
          ),
        );
      } else {
        output.add(
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.green,
                color: listgrid.cellBackgroundColor,
                border: Border(
                  right: listgrid.cellBorder > 0
                      ? BorderSide(
                          color: listgrid.widgetBackgroundColor,
                          width: listgrid.cellBorder,
                        )
                      : BorderSide.none,
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
                child: Text(
                  "undefined",
                  style: listgrid.defaultTextStyle,
                ),
                // child: const Text("cell"),
              ),
            ),
          ),
        );
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

    return output;
  }

  Future<int> countQueryResult({required Query<T> query}) async {
    AggregateQuerySnapshot snaphot = await query.count().get();
    return snaphot.count;
  }

  String prepTooltip(String input) {
    String output = "";
    List<String> words = input.split(" ");
    for (var i = 0; i < words.length; i++) {
      String word = words[i];
      output = "$output $word";
      if (i % 6 == 5) {
        output = "$output \n";
      }
    }

    return output;
  }
}
