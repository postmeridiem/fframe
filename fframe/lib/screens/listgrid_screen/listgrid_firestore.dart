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

  late double rowBorder;
  late double cellBorder;
  late EdgeInsetsGeometry cellPadding;
  late TableCellVerticalAlignment cellVerticalAlignment;
  late Color cellBackgroundColor;
  late TextStyle? cellTextStyle;

  late Color? widgetBackgroundColor;
  late TextStyle? widgetTextStyle;

  late double? headerHeight;
  late double? footerHeight;

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

    // TODO: probably want to move all the styling defaults into the widget init, since this will not mutate any more, meh
    // set up cell borders,
    //apply passed cell styling settings to grid or default to theme sensible
    Color cellBackgroundColor = listGridConfig.cellBackgroundColor ??
        Theme.of(context).colorScheme.background;
    TextStyle defaultTextStyle = listGridConfig.defaultTextStyle ??
        TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        );

    //apply passed chrome /widget components styling settings to grid or default to theme sensible
    Color widgetBackgroundColor = listGridConfig.widgetBackgroundColor ??
        Theme.of(context).colorScheme.primary;
    TextStyle widgetTextStyle = listGridConfig.widgetTextStyle ??
        TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onPrimary,
        );
    Color widgetColor =
        listGridConfig.widgetColor ?? Theme.of(context).colorScheme.onPrimary;

    double? headerHeight = listGridConfig.showHeader ? null : 0;
    double? footerHeight = listGridConfig.showFooter ? null : 0;
    double rowBorder = listGridConfig.rowBorder;
    EdgeInsetsGeometry cellPadding = listGridConfig.cellPadding;

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

    return FirestoreQueryBuilder<T>(
      pageSize: listGridConfig.dataMode.limit,
      query: computedQuery,
      builder: (context, snapshot, child) {
        // fFrameDataTableSource.fromSnapShot(snapshot);
        List<QueryDocumentSnapshot<T>> data = snapshot.docs;
        return Stack(
          children: [
            Container(
              color: widgetBackgroundColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListGridHeader(
                      calculatedWidth: calculatedWidth,
                      columnWidths: columnWidths,
                      columnSettings: columnSettings,
                      widgetBackgroundColor: widgetBackgroundColor,
                      widgetColor: widgetColor,
                      widgetTextStyle: widgetTextStyle,
                      cellPadding: cellPadding,
                      cellBorder: listGridConfig.cellBorder,
                      headerHeight: headerHeight,
                      addEndFlex: addEndFlex,
                    ),
                    Expanded(
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
                                        columnWidths: columnWidths,
                                        // defaultColumnWidth: const FlexColumnWidth(),
                                        defaultVerticalAlignment: listGridConfig
                                            .cellVerticalAlignment,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: cellBackgroundColor,
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
                                              padding:
                                                  listGridConfig.cellPadding,
                                              cellBorder:
                                                  listGridConfig.cellBorder,
                                              rowBorder: rowBorder,
                                              columnSettings: columnSettings,
                                              cellBackgroundColor:
                                                  cellBackgroundColor,
                                              defaultTextStyle:
                                                  defaultTextStyle,
                                              widgetBackgroundColor:
                                                  widgetBackgroundColor,
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
                                  shrinkWrap: false,
                                  // padding: padding,
                                  // // itemExtent: itemExtent,
                                  // // prototypeItem: prototypeItem,
                                  addAutomaticKeepAlives: true,
                                  addRepaintBoundaries: true,
                                  addSemanticIndexes: true,
                                  // cacheExtent: cacheExtent,
                                  // semanticChildCount: semanticChildCount,
                                  dragStartBehavior: DragStartBehavior.start,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.manual,
                                  // restorationId: restorationId,
                                  clipBehavior: Clip.hardEdge,
                                ),
                              ),
                      ),
                    ),
                    ListGridFooter(
                      query: computedQuery,
                      viewportWidth: viewportWidth,
                      widgetBackgroundColor: widgetBackgroundColor,
                      widgetColor: widgetColor,
                      widgetTextStyle: widgetTextStyle,
                      cellPadding: cellPadding,
                      footerHeight: footerHeight,
                      dataMode: listGridConfig.dataMode.mode,
                      updateCount: (listGridConfig.showHeader) ? true : false,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListGridFooter(
                  query: computedQuery,
                  viewportWidth: viewportWidth,
                  widgetBackgroundColor: widgetBackgroundColor,
                  widgetColor: widgetColor,
                  widgetTextStyle: widgetTextStyle,
                  cellPadding: cellPadding,
                  footerHeight: footerHeight,
                  dataMode: listGridConfig.dataMode.mode,
                  updateCount: false,
                ),
              ],
            ),
          ],
        );
      },
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
    required EdgeInsetsGeometry padding,
    required Color widgetBackgroundColor,
    required Color cellBackgroundColor,
    required TextStyle defaultTextStyle,
    required double cellBorder,
    required double rowBorder,
    required bool addEndFlex,
  }) {
    List<Widget> output = [];
    for (ListGridColumn<T> column in columnSettings) {
      if (column.cellBuilder != null) {
        output.add(
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.green,
                color: cellBackgroundColor,
                border: Border(
                  bottom: rowBorder > 0
                      ? BorderSide(
                          color: widgetBackgroundColor,
                          width: rowBorder,
                        )
                      : BorderSide.none,
                ),
              ),
              child: Padding(
                padding: padding,
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
                color: cellBackgroundColor,
                border: Border(
                  right: cellBorder > 0
                      ? BorderSide(
                          color: widgetBackgroundColor,
                          width: cellBorder,
                        )
                      : BorderSide.none,
                  bottom: rowBorder > 0
                      ? BorderSide(
                          color: widgetBackgroundColor,
                          width: rowBorder,
                        )
                      : BorderSide.none,
                ),
              ),
              child: column.generateTooltip
                  ? Tooltip(
                      message: prepTooltip(stringValue),
                      child: Padding(
                        padding: padding,
                        child: column.textSelectable
                            ? SelectableText(
                                stringValue,
                                textAlign: column.textAlign,
                                style: defaultTextStyle,
                                // overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                stringValue,
                                textAlign: column.textAlign,
                                style: defaultTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                        // child: const Text("cell"),
                      ),
                    )
                  : Padding(
                      padding: padding,
                      child: column.textSelectable
                          ? SelectableText(
                              stringValue,
                              textAlign: column.textAlign,
                              style: defaultTextStyle,
                              // overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              stringValue,
                              textAlign: column.textAlign,
                              style: defaultTextStyle,
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
                color: cellBackgroundColor,
                border: Border(
                  right: cellBorder > 0
                      ? BorderSide(
                          color: widgetBackgroundColor,
                          width: cellBorder,
                        )
                      : BorderSide.none,
                  bottom: rowBorder > 0
                      ? BorderSide(
                          color: widgetBackgroundColor,
                          width: rowBorder,
                        )
                      : BorderSide.none,
                ),
              ),
              child: Padding(
                padding: padding,
                child: Text(
                  "undefined",
                  style: defaultTextStyle,
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
              color: cellBackgroundColor,
              border: Border(
                bottom: rowBorder > 0
                    ? BorderSide(
                        color: widgetBackgroundColor,
                        width: rowBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: padding,
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
