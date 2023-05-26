part of fframe;

// ignore: must_be_immutable
class ListGridController<T> extends InheritedModel {
  ListGridController({
    super.key,
    required child,
    required this.sourceQuery,
    required this.theme,
    required this.config,
    required this.viewportSize,
  }) : super(child: child) {
    _columnWidths = {};
    _searchableColumns = [];
    double calculatedMinWidth = 0;

    // track if all columns have fixed width
    // if so, add an extra blank column at the end with flex
    // to fill the screen
    _addEndFlex = true;
    _enableSearchBar = false;
    _enableActionBar = true;
    int columnCount = 0;

    if (config.rowsSelectable) {
      // this grid has row selection enabled.
      // draw an extra column for the check box
      double selectionColumnWidth = 40;
      calculatedMinWidth += selectionColumnWidth;
      _columnWidths
          .addAll({columnCount: FixedColumnWidth(selectionColumnWidth)});
      columnCount += 1;
    }

    for (var i = 0; i < (config.columnSettings.length); i++) {
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
          _columnWidths.addAll(
              {columnCount: FixedColumnWidth(columnSetting.columnWidth)});
        }
        columnCount += 1;
      }
      // calculate the list of searchable fields for the search box
      if (columnSetting.searchable && columnSetting.fieldName != null) {
        _enableSearchBar = true;
        _searchableColumns.add(i);
      }
    }
    if (_addEndFlex) {
      _columnWidths.addAll({columnCount: const FlexColumnWidth(1)});
    }
    _viewportWidth = _getViewportWidth(viewportSize: viewportSize);
    _calculatedWidth = _calculateWidth(calculatedMinWidth, viewportWidth);

    // register the grid controller update notifier
    notifier = ListGridNotifier(
      sourceQuery: sourceQuery,
      columnSettings: columnSettings,
      searchableColumns: _searchableColumns,
    );
  }
  late ListGridNotifier notifier;

  final ListGridConfig config;
  final ThemeData theme;
  final Size viewportSize;

  late Map<int, TableColumnWidth> _columnWidths;
  late bool _enableSearchBar;
  late bool _enableActionBar;
  late List<int> _searchableColumns;
  late Query sourceQuery;
  late double _calculatedWidth;
  late double _viewportWidth;
  late bool _addEndFlex;

  // late Map<String, bool> listGridSelection = {};

  double get rowBorder {
    return config.rowBorder;
  }

  double get cellBorder {
    return config.rowBorder;
  }

  EdgeInsetsGeometry get cellPadding {
    return config.cellPadding;
  }

  TableCellVerticalAlignment get cellVerticalAlignment {
    return config.cellVerticalAlignment;
  }

  Color get cellBackgroundColor {
    return config.cellBackgroundColor ?? theme.colorScheme.background;
  }

  Color get widgetColor {
    return config.widgetColor ?? theme.colorScheme.onSurface;
  }

  Color get widgetBackgroundColor {
    return config.widgetBackgroundColor ?? theme.colorScheme.surface;
  }

  double get widgetTextSize {
    return config.widgetTextSize;
  }

  Color get widgetTextColor {
    return config.widgetTextColor ?? theme.colorScheme.onSurface;
  }

  ListGridDataModeConfig get dataMode {
    return config.dataMode;
  }

  TextStyle get defaultTextStyle {
    return config.defaultTextStyle ??
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
    return config.showHeader;
  }

  double? get headerHeight {
    return config.showHeader ? null : 0;
  }

  bool get showFooter {
    return config.showFooter;
  }

  double? get footerHeight {
    return config.showFooter ? null : 0;
  }

  List<ListGridColumn> get columnSettings {
    return config.columnSettings;
  }

  Map<int, TableColumnWidth> get columnWidths {
    return _columnWidths;
  }

  Map<String, T> get listGridSelection {
    return notifier.listGridSelection as Map<String, T>;
  }

  int get selectionCount {
    return notifier.selectionCount;
  }

  void selectRow({required String documentId, required T document}) {
    notifier.selectRow(documentId: documentId, document: document);
  }

  void unselectRow({required String documentId}) {
    notifier.unselectRow(documentId: documentId);
  }

  bool get addEndFlex {
    return _addEndFlex;
  }

  int? get collectionCount {
    return notifier.collectionCount;
  }

  bool get enableSearchBar {
    return _enableSearchBar;
  }

  String? get searchString {
    return notifier.searchString;
  }

  set searchString(String? searchString) {
    notifier.searchString = searchString;
  }

  List<int> get searchableColumns {
    return _searchableColumns;
  }

  bool get enableActionBar {
    return _enableActionBar;
  }

  void sortColumn({required int columnIndex, bool descending = false}) {
    notifier.sortColumn(columnIndex: columnIndex, descending: descending);
  }

  int? get sortedColumnIndex {
    return notifier._sortedColumnIndex;
  }

  Query get currentQuery {
    return notifier._currentQuery;
  }

  double _calculateWidth(double calculatedMinWidth, double viewportWidth) {
    double calculatedWidth =
        calculatedMinWidth > viewportWidth ? calculatedMinWidth : viewportWidth;
    return calculatedWidth;
  }

  double _getViewportWidth({required Size viewportSize}) {
    double viewportWidth = ((viewportSize.width > 1000)
        ? (viewportSize).width - 100
        : (viewportSize.width + 0));
    return viewportWidth;
  }

  @override
  bool updateShouldNotify(covariant ListGridController oldWidget) {
    bool updated = false;

    // test if any fields are changed that should trigger an update
    updated = (config != oldWidget.config) ? true : updated;
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
    // TODO: implement updateShouldNotifyDependent
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
    required this.sourceQuery,
    // required this.searchConfig,
    required this.columnSettings,
    required this.searchableColumns,
  }) : super() {
    // not empyy
    _searchString = '';
    _collectionCount = 0;

    // initialize the sorting object
    _sortedColumnIndex = null;

    // initialize the row selections
    _listGridSelection = {};

    // initialize the current query, based on sorting and settings
    _currentQuery = sourceQuery;
    _queryBuilder();

    //update the collection count
    _updateCollectionCount(query: _currentQuery);
  }
  final Query sourceQuery;
  // final ListGridSearchConfig? searchConfig;
  final List<ListGridColumn> columnSettings;
  final List<int> searchableColumns;
  late String? _searchString;
  late int _collectionCount;
  late Query _currentQuery;

  late int? _sortedColumnIndex;

  late Map<String, T> _listGridSelection;

  String? get searchString {
    return _searchString;
  }

  set searchString(String? searchString) {
    //TODO: add some kind of rate limiting
    if (searchString != null && searchString.isNotEmpty) {
      _searchString = searchString;
    } else {
      _searchString = null;
    }
    _queryBuilder();
  }

  void _queryBuilder() {
    Query outputQuery = sourceQuery;

    // handle sorting
    if (sortedColumnIndex != null) {
      ListGridColumn sortedColumn = columnSettings[sortedColumnIndex!];

      outputQuery = outputQuery.orderBy(sortedColumn.fieldName!,
          descending: sortedColumn.descending);

      if (columnSettings[sortedColumnIndex!].fieldName != null) {
        String fieldName = columnSettings[sortedColumnIndex!].fieldName!;
        outputQuery = outputQuery.startsWith(fieldName, searchString!);
      }
    } else {
      if (searchableColumns.isNotEmpty) {
        if (searchString != null && searchString!.isNotEmpty) {
          if (searchableColumns.length > 1) {
            //TODO make multiple columns supported
            // Console.log(
            //     "ListGrid: ERROR: Multiple searchable columns not supported at this time. Defaulting to first one");
            List<Filter> currentFilters = [];
            for (int searchableColumnIndex in searchableColumns) {
              String curSearch = searchString!;
              ListGridColumn curColumn = columnSettings[searchableColumnIndex];
              if (curColumn.fieldName != null) {
                String fieldName = curColumn.fieldName!;
                outputQuery = outputQuery.orderBy(fieldName,
                    descending: curColumn.descending);
                if (curColumn.searchMask != null) {
                  if (curColumn.searchMask!.toLowerCase) {
                    curSearch = curSearch.toLowerCase();
                  }
                  curSearch = curSearch.replaceAll(
                    curColumn.searchMask!.from,
                    curColumn.searchMask!.to,
                  );
                }
                currentFilters.add(Filter(fieldName, isEqualTo: curSearch));
                // outputQuery = outputQuery.startsWith(
                //   fieldName,
                //   curSearch,
                // );
              }
              // outputQuery = outputQuery
              //     .where(Filter.or(currentFilters[0], currentFilters[1]));
            }
          } else {
            if (columnSettings[searchableColumns.first].fieldName != null) {
              String curSearch = searchString!;
              ListGridColumn curColumn =
                  columnSettings[searchableColumns.first];
              String fieldName = curColumn.fieldName!;
              outputQuery = outputQuery.orderBy(fieldName,
                  descending: curColumn.descending);
              if (curColumn.searchMask == null) {
                outputQuery = outputQuery.startsWith(fieldName, curSearch);
              } else {
                debugPrint("applying search mask");
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
        }
      }
    }

    // apply the newly computedQuery as the current query
    _currentQuery = outputQuery;

    // the query has changed; recalculate the result collection count
    _updateCollectionCount(query: _currentQuery);

    // notify the listeners that a redraw is needed
    notifyListeners();
  }

  void sortColumn({required int columnIndex, bool descending = false}) {
    // get the config for the selected column
    ListGridColumn selectedColumn = columnSettings
        .where((element) => element.columnIndex == columnIndex)
        .first;

    if (columnIndex == _sortedColumnIndex &&
        descending == selectedColumn.descending) {
      // this column and sort direction were already selected. user is deselecting sort
      _sortedColumnIndex = null;
      debugPrint(
          "deselecting column: ${selectedColumn.fieldName}($columnIndex)");
    } else {
      // change the sort to the selected state
      // set the currently sorted column to this one
      _sortedColumnIndex = columnIndex;

      // set the columns search direction to the input
      columnSettings[columnIndex].descending = descending;

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

  Map<String, T> get listGridSelection {
    return _listGridSelection;
  }

  int get selectionCount {
    return _listGridSelection.isNotEmpty ? _listGridSelection.length : 0;
  }

  void selectRow({required String documentId, required T document}) {
    _listGridSelection[documentId] = document;
    notifyListeners();
  }

  void unselectRow({required String documentId}) {
    _listGridSelection.remove(documentId);
    notifyListeners();
  }

  set collectionCount(int collectionCount) {
    _collectionCount = collectionCount;
    notifyListeners();
  }

  void _updateCollectionCount({required Query query}) async {
    AggregateQuerySnapshot snapshot = await query.count().get();
    int collectionCount = snapshot.count;
    _collectionCount = collectionCount;
  }

  void update() {
    notifyListeners();
  }
}

class ListGridColumn<T> {
  ListGridColumn({
    this.label = '',
    this.visible = true,
    this.fieldName,
    this.searchable = false,
    this.searchMask,
    this.sortable = false,
    this.descending = false,
    this.valueBuilder,
    this.cellBuilder,
    this.columnSizing = ListGridColumnSizingMode.flex,
    this.columnWidth = 200,
    this.alignment = Alignment.bottomLeft,
    this.cellColor,
    this.textSelectable = false,
    this.generateTooltip = false,
    this.cellControlsBuilder,

    // this.dynamicTextStyle,
    // this.dynamicBackgroundColor,
  });
  String label;
  bool visible;
  String? fieldName;
  bool searchable;
  ListGridSearchMask? searchMask;
  bool sortable;
  bool descending;
  ListGridColumnSizingMode columnSizing;
  double columnWidth;
  Alignment alignment;

  Color? cellColor;

  ListGridValueBuilderFunction<T>? valueBuilder;
  ListGridCellBuilderFunction<T>? cellBuilder;
  ListGridCellControlsBuilderFunction<T>? cellControlsBuilder;
  // List<IconButton>? cellControls;

  bool textSelectable;
  bool generateTooltip;

  late int? columnIndex;
  late bool sortedColumn = false;
}

class ListGridDataModeConfig {
  const ListGridDataModeConfig({
    this.mode = ListGridDataMode.limit,
    this.limit = 100,
    // this.autopagerRowHeight,
  });
  final ListGridDataMode mode;
  final int limit;
  // final double? autopagerRowHeight;
}

class ListGridConfig<T> {
  ListGridConfig({
    required this.columnSettings,
    this.dataMode = const ListGridDataModeConfig(mode: ListGridDataMode.all),
    this.widgetBackgroundColor,
    this.widgetColor,
    this.widgetTextColor,
    this.widgetTextSize = 16,
    this.rowBorder = 1,
    this.cellBorder = 0,
    this.cellPadding = const EdgeInsets.all(8.0),
    this.cellVerticalAlignment = TableCellVerticalAlignment.middle,
    this.cellBackgroundColor,
    this.defaultTextStyle,
    this.showHeader = true,
    this.showFooter = true,
    this.rowsSelectable = false,
    // this.gridActions,
  });

  final List<ListGridColumn<T>> columnSettings;
  final ListGridDataModeConfig dataMode;

  final Color? widgetBackgroundColor;
  final Color? widgetColor;
  final Color? widgetTextColor;
  final double widgetTextSize;

  final double rowBorder;
  final double cellBorder;
  final EdgeInsetsGeometry cellPadding;
  final TableCellVerticalAlignment cellVerticalAlignment;
  final Color? cellBackgroundColor;
  final TextStyle? defaultTextStyle;

  final bool showHeader;
  final bool showFooter;
  final bool rowsSelectable;
  // final Map<int,ListGridActionMenu> gridActions;

  late T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
      fromFirestore;
  late Map<String, Object?> Function(T, SetOptions?) toFirestore;
}

class ListGridSearchConfig {
  const ListGridSearchConfig({
    required this.mode,
    this.field,
    this.multiFields,
  });
  final ListGridSearchMode mode;
  final String? field;
  final List<String>? multiFields;
}

class ListGridSearchMask {
  const ListGridSearchMask({
    required this.from,
    required this.to,
    this.toLowerCase = false,
  });
  final String from;
  final String to;
  final bool toLowerCase;
}

enum ListGridColumnSizingMode {
  flex,
  fixed,
}

enum ListGridDataMode {
  all,
  autopager,
  lazy,
  limit,
  pager,
}

enum ListGridSearchMode {
  singleFieldString,
  multiFieldString,
  underscoreTypeAhead,
}
