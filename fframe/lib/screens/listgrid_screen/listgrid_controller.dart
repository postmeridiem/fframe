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
    return listGridConfig.cellBackgroundColor ?? theme.colorScheme.surfaceContainerHighest;
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

      if (_columnSettings[sortedColumnIndex!].fieldName != null) {
        String fieldName = _columnSettings[sortedColumnIndex!].fieldName!;
        outputQuery = outputQuery.startsWith(fieldName, searchString!);
      }
    } else {
      if (_searchableColumns.isNotEmpty) {
        if (searchString != null && searchString!.isNotEmpty) {
          Console.log("fframeLog.ListGridNotifier: searching for: $searchString");
          if (_searchableColumns.length > 1) {
            //TODO JPM: make multiple columns supported
            Console.log("fframeLog.ListGridNotifier: ERROR: Multiple searchable columns not supported at this time. Please adjust configuration");
            // List<Filter> currentFilters = [];
            // for (int searchableColumnIndex in _searchableColumns) {
            //   String curSearch = searchString!;
            //   ListGridColumn curColumn = _columnSettings[searchableColumnIndex];
            //   if (curColumn.fieldName != null) {
            //     String fieldName = curColumn.fieldName!;
            //     outputQuery = outputQuery.orderBy(fieldName,
            //         descending: curColumn.descending);
            //     if (curColumn.searchMask != null) {
            //       if (curColumn.searchMask!.toLowerCase) {
            //         curSearch = curSearch.toLowerCase();
            //       }
            //       curSearch = curSearch.replaceAll(
            //         curColumn.searchMask!.from,
            //         curColumn.searchMask!.to,
            //       );
            //     }
            //     currentFilters.add(Filter(fieldName, isEqualTo: curSearch));
            //     outputQuery = outputQuery.startsWith(
            //       fieldName,
            //       curSearch,
            //     );
            //   }
            //   outputQuery = outputQuery
            //       .where(Filter.or(currentFilters[0], currentFilters[1]));
            // }
          } else {
            if (_columnSettings[_searchableColumns.first].fieldName != null) {
              String curSearch = searchString!;
              ListGridColumn curColumn = _columnSettings[_searchableColumns.first];
              String fieldName = curColumn.fieldName!;
              outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending);
              if (curColumn.searchMask == null) {
                outputQuery = outputQuery.startsWith(fieldName, curSearch);
              } else {
                if (curColumn.searchMask!.toLowerCase) {
                  curSearch = curSearch.toLowerCase();
                }
                outputQuery = outputQuery.startsWith(
                  fieldName,
                  curSearch.replaceAll(
                    curColumn.searchMask!.from,
                    curColumn.searchMask!.to,
                  ),
                );
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
    }

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
