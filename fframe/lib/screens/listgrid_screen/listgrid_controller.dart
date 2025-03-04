// ignore_for_file: use_super_parameters

part of 'package:fframe/fframe.dart';

// ignore: must_be_immutable
class ListGridController extends InheritedModel<ListGridController> {
  ListGridController({
    super.key,
    required child,
    required this.context,
    required this.theme,
    required this.documentConfig,
    required this.notifier,
    required this.viewportSize,
  }) : super(child: child) {
    listGridConfig = documentConfig.listGridConfig!;
    _columnWidths = {};
    double calculatedMinWidth = 0;
    double selectionColumnWidth = 0;
    // count  action bar items to see if
    // the actionbar should be drawm
    _enableActionBar = (listGridConfig.actionBar.isNotEmpty) ? true : false;

    // track if all columns have fixed width
    // if so, add an extra blank column at the end with flex
    // to fill the screen
    _addEndFlex = true;
    int columnCount = 0;

    if (listGridConfig.rowsSelectable) {
      // this grid has row selection enabled.
      // draw an extra column for the check box
      selectionColumnWidth = 40;
      calculatedMinWidth += selectionColumnWidth;
      _columnWidths.addAll({columnCount: FixedColumnWidth(selectionColumnWidth)});
      columnCount += 1;
    }

    for (var i = 0; i < (listGridConfig.columnSettings.length); i++) {
      // get the settings for the current column
      ListGridColumn columnSetting = columnSettings[i];

      // calculate the grid width based on visibility
      if (columnSetting.visible) {
        columnSetting.columnIndex = i;
        // add this column's width to the min width.
        // each flex column will add the default column width
        // unless specified otherwise
        calculatedMinWidth += columnSetting.columnWidth;

        // apply the sizing enum to actual table column widths
        if (columnSetting.columnSizing == ListGridColumnSizingMode.flex) {
          _addEndFlex = false;
          _columnWidths.addAll({columnCount: const FlexColumnWidth(1)});
        } else {
          _columnWidths.addAll({columnCount: FixedColumnWidth(columnSetting.columnWidth)});
        }
        columnCount += 1;
      }
    }

    if (_addEndFlex) {
      _columnWidths.addAll({columnCount: const FlexColumnWidth(1)});
    }
    _viewportWidth = _getViewportWidth(viewportSize: viewportSize);
    _calculatedWidth = _calculateWidth(calculatedMinWidth, viewportWidth);

    if ((documentConfig.listGridConfig?.hideListOnDocumentOpen ?? false) == false) {
      SelectionState.instance.padding = EdgeInsets.only(left: listGridConfig.columnSettings.first.columnWidth + selectionColumnWidth);
    }
  }

  final ListGridNotifier notifier;
  final BuildContext context;
  late ListGridConfig listGridConfig;
  final DocumentConfig documentConfig;
  final ThemeData theme;
  final Size viewportSize;

  late Map<int, TableColumnWidth> _columnWidths;
  late bool _enableActionBar;
  late double _calculatedWidth;
  late double _viewportWidth;
  late bool _addEndFlex;

  // late Map<String, bool> listGridSelection = {};

  double get rowBorder {
    return listGridConfig.rowBorder;
  }

  double get cellBorder {
    return listGridConfig.rowBorder;
  }

  EdgeInsetsGeometry get cellPadding {
    return listGridConfig.cellPadding;
  }

  TableCellVerticalAlignment get cellVerticalAlignment {
    return listGridConfig.cellVerticalAlignment;
  }

  Color get cellBackgroundColor {
    return listGridConfig.cellBackgroundColor ?? theme.colorScheme.tertiaryContainer;
  }

  Color get widgetColor {
    return listGridConfig.widgetColor ?? theme.colorScheme.onSurface;
  }

  Color get widgetAccentColor {
    return listGridConfig.widgetAccentColor ?? theme.indicatorColor;
  }

  Color get widgetBackgroundColor {
    return listGridConfig.widgetBackgroundColor ?? theme.colorScheme.surface;
  }

  double get widgetTextSize {
    return listGridConfig.widgetTextSize;
  }

  Color get widgetTextColor {
    return listGridConfig.widgetTextColor ?? theme.colorScheme.onSurface;
  }

  ListGridDataModeConfig get dataMode {
    return listGridConfig.dataMode;
  }

  TextStyle get defaultTextStyle {
    return listGridConfig.defaultTextStyle ??
        TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSecondaryContainer,
        );
  }

  double get calculatedWidth {
    return _calculatedWidth;
  }

  double get viewportWidth {
    return _viewportWidth;
  }

  bool get showHeader {
    return listGridConfig.showHeader;
  }

  double? get headerHeight {
    return listGridConfig.showHeader ? null : 0;
  }

  bool get showFooter {
    return listGridConfig.showFooter;
  }

  double? get footerHeight {
    return listGridConfig.showFooter ? null : 0;
  }

  List<ListGridColumn> get columnSettings {
    return listGridConfig.columnSettings;
  }

  Map<int, TableColumnWidth> get columnWidths {
    return _columnWidths;
  }

  bool get addEndFlex {
    return _addEndFlex;
  }

  int get collectionCount {
    return notifier.collectionCount;
  }

  bool get enableSearchBar {
    return notifier._enableSearchBar;
  }

  String? get searchString {
    return notifier.searchString;
  }

  set searchString(String? searchString) {
    notifier.searchString = searchString;
  }

  List<int> get searchableColumns {
    return notifier._searchableColumns;
  }

  bool get enableActionBar {
    return _enableActionBar;
  }

  void actionBar(bool enabled) {
    _enableActionBar = enabled;
  }

  void sortColumn({required int columnIndex, bool descending = false}) {
    notifier.sortColumn(columnIndex: columnIndex, descending: descending);
  }

  int? get sortedColumnIndex {
    return notifier._sortedColumnIndex;
  }

  double _calculateWidth(double calculatedMinWidth, double viewportWidth) {
    double calculatedWidth = calculatedMinWidth > viewportWidth ? calculatedMinWidth : viewportWidth;
    return calculatedWidth;
  }

  double _getViewportWidth({required Size viewportSize}) {
    double viewportWidth = ((viewportSize.width > 1000) ? (viewportSize).width - 100 : (viewportSize.width + 0));
    return viewportWidth;
  }

  @override
  bool updateShouldNotify(covariant ListGridController oldWidget) {
    bool updated = false;

    // test if any fields are changed that should trigger an update
    updated = (listGridConfig != oldWidget.listGridConfig) ? true : updated;
    updated = (columnSettings != oldWidget.columnSettings) ? true : updated;
    updated = (columnWidths != oldWidget.columnWidths) ? true : updated;
    updated = (theme != oldWidget.theme) ? true : updated;
    updated = (searchString != oldWidget.searchString) ? true : updated;
    updated = (collectionCount != oldWidget.collectionCount) ? true : updated;

    notifier.update();
    return updated;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant InheritedModel oldWidget,
    Set dependencies,
  ) {
    // TODO JPM: implement updateShouldNotifyDependent
    return true;
  }

  static ListGridController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ListGridController>();
  }

  static ListGridController of(BuildContext context) {
    final ListGridController? result = maybeOf(context);

    assert(result != null, 'No ListGridController found in context');
    return result!;
  }
}

class ListGridNotifier<T> extends ChangeNotifier {
  ListGridNotifier({
    required Query<T> initialQuery,
    required DocumentConfig<T> documentConfig,
  }) : super() {
    // not empty
    _searchString = '';
    _collectionCount = 0;
    _initialQuery = initialQuery;
    _currentQuery = initialQuery;
    // initialize the sorting object
    _sortedColumnIndex = null;
    _searchableColumns = [];
    // initialize the row selections

    _listGridConfig = documentConfig.listGridConfig;
    _columnSettings = _listGridConfig!.columnSettings;
    _enableSearchBar = false;

    for (var i = 0; i < (_columnSettings.length); i++) {
      // get the settings for the current column
      ListGridColumn columnSetting = _columnSettings[i];

      // calculate the list of searchable fields for the search box
      if (columnSetting.searchable && columnSetting.fieldName != null) {
        _enableSearchBar = true;
        _searchableColumns.add(i);
      }
    }

    // initialize the current query, based on sorting and settings
    _queryBuilder();

    //update the collection count
    // _updateCollectionCount(query: _currentQuery as Query<T>);
  }

  set currentQuery(Query newQuery) {
    _currentQuery = newQuery as Query<T>;
  }

  Query<T> get currentQuery => _currentQuery as Query<T>;

  // final ListGridSearchConfig? searchConfig;
  // late List<ListGridColumn> columnSettings;
  late List<int> _searchableColumns;
  late bool _enableSearchBar;
  late String? _searchString;
  late int _collectionCount;
  Query<T>? _initialQuery;
  Query<T>? _currentQuery;
  late ListGridConfig<T>? _listGridConfig;
  late List<ListGridColumn<T>> _columnSettings;
  late int? _sortedColumnIndex;
  final List<SelectedDocument<T>> _selectedDocuments = [];

  String? get searchString {
    return _searchString;
  }

  set searchString(String? searchString) {
    //TODO JPM: add some kind of rate limiting
    if (searchString != null && searchString.isNotEmpty) {
      _searchString = searchString;
    } else {
      _searchString = null;
    }
    _queryBuilder();
  }

  // void _queryBuilder() {
  //   Query outputQuery = _initialQuery as Query<T>;

  //   // handle sorting
  //   if (sortedColumnIndex != null) {
  //     ListGridColumn sortedColumn = _columnSettings[sortedColumnIndex!];
  //     Console.log(
  //       "fframeLog.ListGridNotifier: column sorted, search on the ${sortedColumn.fieldName!} column",
  //       level: LogLevel.fframe,
  //     );

  //     outputQuery = outputQuery.orderBy(sortedColumn.fieldName!, descending: sortedColumn.descending);

  //     if (_columnSettings[sortedColumnIndex!].fieldName != null) {
  //       String fieldName = _columnSettings[sortedColumnIndex!].fieldName!;
  //       outputQuery = outputQuery.startsWith(fieldName, searchString!);
  //     }
  //   } else {
  //     if (_searchableColumns.isNotEmpty) {
  //       if (searchString != null && searchString!.isNotEmpty) {
  //         Console.log("fframeLog.ListGridNotifier: searching for: $searchString");
  //         if (_searchableColumns.length > 1) {
  //           //TODO JPM: make multiple columns supported
  //           //   Console.log("fframeLog.ListGridNotifier: ERROR: Multiple searchable columns not supported at this time. Please adjust configuratiossssssssssssssn");
  //           //   List<Filter> currentFilters = [];
  //           for (int searchableColumnIndex in _searchableColumns) {
  //             String curSearch = searchString!;
  //             ListGridColumn curColumn = _columnSettings[searchableColumnIndex];
  //             if (curColumn.fieldName != null) {
  //               String fieldName = curColumn.fieldName!;
  //               if (curColumn.searchMask != null) {
  //                 if (curColumn.searchMask!.toLowerCase) {
  //                   curSearch = curSearch.toLowerCase();
  //                 }
  //                 curSearch = curSearch.replaceAll(
  //                   curColumn.searchMask!.from,
  //                   curColumn.searchMask!.to,
  //                 );
  //               }
  //               // outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending); // Remove orderBy here, it's not needed and causes ordering issues
  //               //currentFilters.add(Filter(fieldName, isEqualTo: curSearch));// Remove this too. isEqualTo is not supported with the startsWith query we use.
  //               outputQuery = outputQuery.where(fieldName, isGreaterThanOrEqualTo: curSearch).where(fieldName, isLessThan: curSearch); //Use startswith like approach but multiple
  //             }
  //           }
  //         } else {
  //           if (_columnSettings[_searchableColumns.first].fieldName != null) {
  //             String curSearch = searchString!;
  //             ListGridColumn curColumn = _columnSettings[_searchableColumns.first];
  //             String fieldName = curColumn.fieldName!;
  //             // outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending); // Move the order by to the top.
  //             if (curColumn.searchMask == null) {
  //               outputQuery = outputQuery.startsWith(fieldName, curSearch);
  //             } else {
  //               if (curColumn.searchMask!.toLowerCase) {
  //                 curSearch = curSearch.toLowerCase();
  //               }
  //               outputQuery = outputQuery.startsWith(
  //                 fieldName,
  //                 curSearch.replaceAll(
  //                   curColumn.searchMask!.from,
  //                   curColumn.searchMask!.to,
  //                 ),
  //               );
  //             }
  //           }
  //         }
  //       } else {
  //         // no search string provided, and no column user sorted. make sure to sort the primary search column if available.

  //         if (_columnSettings[_searchableColumns.first].fieldName != null) {
  //           ListGridColumn curColumn = _columnSettings[_searchableColumns.first];
  //           String fieldName = curColumn.fieldName!;
  //           outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending);
  //         }
  //       }
  //     } else {
  //       Console.log(
  //         "fframeLog.ListGridNotifier: no searchable column specified",
  //         level: LogLevel.fframe,
  //       );
  //     }
  //   }

  //   // apply the newly computedQuery as the current query
  //   _currentQuery = outputQuery as Query<T>;
  //   Console.log(
  //     "fframeLog.ListGridNotifier: ${outputQuery.parameters.toString()}",
  //     level: LogLevel.fframe,
  //   );

  //   // the query has changed; recalculate the result collection count
  //   _updateCollectionCount(query: _currentQuery as Query<T>);

  //   // notify the listeners that a redraw is needed
  //   notifyListeners();
  // }

  /// Builds the Firestore query based on the current search string and sorting preferences.
  ///
  /// This function is responsible for constructing the final Firestore query that will be
  /// used to fetch data for the ListGrid. It takes into account the user's search input,
  /// any applied sorting, and the configuration of searchable columns.
  ///
  /// The process involves several steps:
  /// 1. **Sorting:** If a column is selected for sorting (`sortedColumnIndex` is not null),
  ///    the query is ordered by that column's field, in either ascending or descending order.
  /// 2. **Searching:** If a search string is provided (`searchString` is not null and not empty),
  ///    and there are searchable columns, the query is filtered based on the search string.
  ///    - **Multiple Searchable Columns:** If there are multiple searchable columns,
  ///      it constructs a compound query using `whereIn`. This is achieved by running
  ///      separate queries for each searchable column and then combining the results
  ///      by their document IDs.
  ///    - **Single Searchable Column:** If there's only one searchable column, it applies
  ///      a `where` clause using `isGreaterThanOrEqualTo` and `isLessThan` to achieve
  ///      a "starts with" effect.
  ///    - **Search Masks:** If a column has a search mask, it applies the mask to the search string.
  ///    - **Case Insensitive** If the search mask has the toLowerCase flag set, the search will be case insensitive
  /// 3. **No Search or Sort:** If no search string is provided and no column is sorted,
  ///    it defaults to sorting by the first searchable column (if available).
  /// 4. **No Searchable Columns:** If no searchable columns are defined, a warning is logged.
  /// 5. **Post-Query Processing:** The final query is then passed to the `_postQueryBuild`
  ///    method for further processing and notification.
  ///
  /// If multiple searches are done, the query will be an 'or' query. If no search is performed, the results are orderd on the first sortable column.
  ///
  /// The `_postQueryBuild` function will then:
  /// 1. apply the newly computedQuery as the current query
  /// 2. recalculate the result collection count
  /// 3. notify the listeners that a redraw is needed
  void _queryBuilder() {
    Query outputQuery = _initialQuery as Query<T>;

    // handle sorting
    if (sortedColumnIndex != null) {
      ListGridColumn sortedColumn = _columnSettings[sortedColumnIndex!];
      Console.log(
        "fframeLog.ListGridNotifier: column sorted, search on the ${sortedColumn.fieldName!} column",
        level: LogLevel.fframe,
      );

      outputQuery = outputQuery.orderBy(sortedColumn.fieldName!, descending: sortedColumn.descending);
    }

    if (_searchableColumns.isNotEmpty) {
      if (searchString != null && searchString!.isNotEmpty) {
        Console.log("fframeLog.ListGridNotifier: searching for: $searchString");

        if (_searchableColumns.length > 1) {
          // Multiple searchable columns: build compound query
          List<Future<QuerySnapshot<T>>> orQueries = []; // Changed the type here
          for (int searchableColumnIndex in _searchableColumns) {
            String curSearch = searchString!;
            ListGridColumn curColumn = _columnSettings[searchableColumnIndex];

            if (curColumn.fieldName != null) {
              String fieldName = curColumn.fieldName!;
              if (curColumn.searchMask != null) {
                if (curColumn.searchMask!.toLowerCase) {
                  curSearch = curSearch.toLowerCase();
                }
                curSearch = curSearch.replaceAll(
                  curColumn.searchMask!.from,
                  curColumn.searchMask!.to,
                );
              }

              // Create a query for this specific searchable column
              Query<T> fieldQuery = _initialQuery as Query<T>;
              // check if the field is null
              fieldQuery = fieldQuery.where(fieldName, isNotEqualTo: null);
              fieldQuery = fieldQuery.where(fieldName, isGreaterThanOrEqualTo: curSearch).where(fieldName, isLessThan: '${curSearch}z');
              orQueries.add(fieldQuery.get()); // add get() here
            }
          }
          // Combine the queries using where in
          if (orQueries.isNotEmpty) {
            Future.wait(orQueries).then((List<QuerySnapshot<T>> querySnapshots) {
              // changed this to await the futures
              List<String> ids = [];
              for (QuerySnapshot<T> querySnapshot in querySnapshots) {
                for (var doc in querySnapshot.docs) {
                  ids.add(doc.id);
                }
              }
              if (ids.isNotEmpty) {
                outputQuery = outputQuery.where(FieldPath.documentId, whereIn: ids);
                _postQueryBuild(outputQuery);
              } else {
                _postQueryBuild(outputQuery);
              }
            });

            return; // Return here to prevent further execution.
          }
        } else {
          // Single searchable column
          if (_columnSettings[_searchableColumns.first].fieldName != null) {
            String curSearch = searchString!;
            ListGridColumn curColumn = _columnSettings[_searchableColumns.first];
            String fieldName = curColumn.fieldName!;

            if (curColumn.searchMask == null) {
              outputQuery = outputQuery.where(fieldName, isNotEqualTo: null).where(fieldName, isGreaterThanOrEqualTo: curSearch).where(fieldName, isLessThan: '${curSearch}z');
            } else {
              if (curColumn.searchMask!.toLowerCase) {
                curSearch = curSearch.toLowerCase();
              }
              curSearch = curSearch.replaceAll(curColumn.searchMask!.from, curColumn.searchMask!.to);
              outputQuery = outputQuery.where(fieldName, isNotEqualTo: null).where(fieldName, isGreaterThanOrEqualTo: curSearch).where(fieldName, isLessThan: '${curSearch}z');
            }
          }
        }
      } else {
        // no search string provided, and no column user sorted. make sure to sort the primary search column if available.
        if (_columnSettings[_searchableColumns.first].fieldName != null) {
          ListGridColumn curColumn = _columnSettings[_searchableColumns.first];
          String fieldName = curColumn.fieldName!;
          outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending);
        }
      }
    } else {
      Console.log(
        "fframeLog.ListGridNotifier: no searchable column specified",
        level: LogLevel.fframe,
      );
    }
    _postQueryBuild(outputQuery);

  }

  void _postQueryBuild(Query outputQuery) {
    // apply the newly computedQuery as the current query
    _currentQuery = outputQuery as Query<T>;
    Console.log(
      "fframeLog.ListGridNotifier: ${outputQuery.parameters.toString()}",
      level: LogLevel.fframe,
    );

    // the query has changed; recalculate the result collection count
    _updateCollectionCount(query: _currentQuery as Query<T>);

    // notify the listeners that a redraw is needed
    notifyListeners();
  }

  void sortColumn({required int columnIndex, bool descending = false}) {
    // get the config for the selected column
    ListGridColumn selectedColumn = _columnSettings.where((element) => element.columnIndex == columnIndex).first;

    if (columnIndex == _sortedColumnIndex && descending == selectedColumn.descending) {
      // this column and sort direction were already selected. user is deselecting sort
      _sortedColumnIndex = null;
    } else {
      // change the sort to the selected state
      // set the currently sorted column to this one
      _sortedColumnIndex = columnIndex;

      // set the columns search direction to the input
      _columnSettings[columnIndex].descending = descending;

      Console.log(
        "Sorting column: ${selectedColumn.fieldName} (column: ${columnIndex + 1}) ${descending ? "descending" : "ascending"}",
        scope: "fframeLog.ListGrid",
        level: LogLevel.fframe,
      );
    }

    // run the query builder to interpret the new sorting settings
    // and call notifyListeners
    _queryBuilder();
  }

  int? get sortedColumnIndex {
    return _sortedColumnIndex;
  }

  int get collectionCount {
    return _collectionCount;
  }

  List<SelectedDocument<T>> get selectedDocuments {
    return _selectedDocuments;
  }

  int get selectionCount {
    return _selectedDocuments.isNotEmpty ? _selectedDocuments.length : 0;
  }

  void selectRow({required SelectedDocument<T> selectedDocument}) {
    _selectedDocuments.add(selectedDocument);
    notifyListeners();
  }

  void unselectRow({required SelectedDocument<T> unSelectedDocument}) {
    _selectedDocuments.removeWhere((selectedDocument) => selectedDocument.documentId == unSelectedDocument.documentId);
    notifyListeners();
  }

  set collectionCount(int collectionCount) {
    _collectionCount = collectionCount;
    notifyListeners();
  }

  void _updateCollectionCount({required Query<T> query}) async {
    AggregateQuerySnapshot snapshot = await query.count().get();
    int collectionCount = snapshot.count!;
    _collectionCount = collectionCount;
  }

  void update() {
    notifyListeners();
  }
}
