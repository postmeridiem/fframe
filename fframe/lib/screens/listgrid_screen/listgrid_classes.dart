part of fframe;

// ignore: must_be_immutable
class ListGridController extends InheritedModel {
  ListGridController({
    super.key,
    required child,
    required this.query,
    required this.theme,
    required this.config,
    required this.viewportSize,
  }) : super(child: child) {
    _columnWidths = {};
    double calculatedMinWidth = 0;

    // track if all columns have fixed width
    // if so, add an extra blank column at the end with flex
    // to fill the screen
    _addEndFlex = true;
    int columnCount = 0;
    for (var i = 0; i < config.columnSettings.length; i++) {
      columnCount += 1;
      // get the settings for the current column
      ListGridColumn columnSetting = columnSettings[i];
      // add this column's width to the min width.
      // each flex column will add the default column width
      // unless specified otherwise
      calculatedMinWidth += columnSetting.columnWidth;

      // apply the sizing enum to actual table column widths
      if (columnSetting.columnSizing == ListGridColumnSizingMode.flex) {
        _addEndFlex = false;
        _columnWidths.addAll({i: const FlexColumnWidth(1)});
      } else {
        _columnWidths.addAll({i: FixedColumnWidth(columnSetting.columnWidth)});
      }
    }
    if (_addEndFlex) {
      _columnWidths.addAll({columnCount: const FlexColumnWidth(1)});
    }
    _viewportWidth = _getViewportWidth(viewportSize: viewportSize);
    _calculatedWidth = _calculateWidth(calculatedMinWidth, viewportWidth);

    // register the grid controller update notifier
    notifier = ListGridNotifier(
      query: query,
    );
  }
  late ListGridNotifier notifier;

  final ListGridConfig config;
  final ThemeData theme;
  final Size viewportSize;

  late Map<int, TableColumnWidth> _columnWidths;
  late Query query;
  late double _calculatedWidth;
  late double _viewportWidth;
  late bool _addEndFlex;

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

  TextStyle get widgetTextStyle {
    return config.widgetTextStyle ??
        TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface,
        );
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

  ListGridSearchConfig? get searchConfig {
    return config.searchConfig;
  }

  List<ListGridColumn> get columnSettings {
    return config.columnSettings;
  }

  Map<int, TableColumnWidth> get columnWidths {
    return _columnWidths;
  }

  bool get addEndFlex {
    return _addEndFlex;
  }

  int? get collectionCount {
    return notifier.collectionCount;
  }

  String? get searchString {
    return notifier.searchString;
  }

  set searchString(String? searchString) {
    notifier.searchString = searchString;
  }

  Query get computedQuery {
    if (searchString == null) {
      return query;
    } else {
      if (config.searchConfig != null) {
        ListGridSearchConfig searchConfig =
            config.searchConfig as ListGridSearchConfig;
        switch (searchConfig.mode) {
          case ListGridSearchMode.singleFieldString:
            if (searchConfig.field == null) {
              Console.log(
                  "ListGrid computedQuery: ListGridSearchConfig: ListGridSearchMode.singleFieldString requires field to be provided");
            }
            debugPrint(
                "ListGridSearchMode.singleFieldString search in ${searchConfig.field}");
            return query
                .startsWith("${searchConfig.field}", searchString!)
                .orderBy("${searchConfig.field}");
          case ListGridSearchMode.multiFieldString:
            if (searchConfig.field == null) {
              Console.log(
                  "ListGrid computedQuery: ListGridSearchConfig: ListGridSearchMode.multiFieldString to be provided");
            }
            //unsupported for now
            // return query.startsWith("createdBy", "Arn").orderBy("createdBy");
            return query;
          case ListGridSearchMode.underscoreTypeAhead:
            if (searchConfig.field == null) {
              Console.log(
                  "ListGrid computedQuery: ListGridSearchConfig: ListGridSearchMode.underscoreTypeAhead to be provided");
            }
            return query
                .startsWith(
                    "${searchConfig.field}", searchString!.replaceAll(' ', '_'))
                .orderBy("${searchConfig.field}");
        }
      } else {
        return query;
      }
    }
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

class ListGridNotifier extends ChangeNotifier {
  ListGridNotifier({
    required this.query,
  }) : super() {
    // not empyy
    _searchString = '';
    _collectionCount = 0;

    //update the collection count
    _updateCollectionCount(query: query);
  }
  late Query query;
  late String? _searchString;
  late int _collectionCount;

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
    _updateCollectionCount(query: query);
    notifyListeners();
  }

  int get collectionCount {
    return _collectionCount;
  }

  void _updateCollectionCount({required Query query}) async {
    AggregateQuerySnapshot snapshot = await query.count().get();
    int collectionCount = snapshot.count;
    _collectionCount = collectionCount;
  }

  set collectionCount(int collectionCount) {
    _collectionCount = collectionCount;
    notifyListeners();
  }

  void update() {
    debugPrint("notifier fired");
    notifyListeners();
  }
}

class ListGridColumn<T> {
  ListGridColumn({
    this.label = '',
    this.valueBuilder,
    this.cellBuilder,
    this.columnSizing = ListGridColumnSizingMode.flex,
    this.columnWidth = 200,
    this.textAlign = TextAlign.start,
    this.cellColor,
    this.textSelectable = false,
    this.generateTooltip = false,
    this.columnSorting = ListGridColumnSortingMode.none,

    // this.dynamicTextStyle,
    // this.dynamicBackgroundColor,
  });
  String label;
  ListGridColumnSizingMode columnSizing;
  double columnWidth;
  TextAlign textAlign;

  Color? cellColor;

  ListGridValueBuilderFunction<T>? valueBuilder;
  ListGridCellBuilderFunction<T>? cellBuilder;

  bool textSelectable;
  bool generateTooltip;
  ListGridColumnSortingMode columnSorting;
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
    this.widgetTextStyle,
    this.rowBorder = 1,
    this.cellBorder = 0,
    this.cellPadding = const EdgeInsets.all(8.0),
    this.cellVerticalAlignment = TableCellVerticalAlignment.middle,
    this.cellBackgroundColor,
    this.defaultTextStyle,
    this.showHeader = true,
    this.showFooter = false,
    this.searchConfig,
  });

  final List<ListGridColumn<T>> columnSettings;
  final ListGridDataModeConfig dataMode;

  final Color? widgetBackgroundColor;
  final Color? widgetColor;
  final TextStyle? widgetTextStyle;

  final double rowBorder;
  final double cellBorder;
  final EdgeInsetsGeometry cellPadding;
  final TableCellVerticalAlignment cellVerticalAlignment;
  final Color? cellBackgroundColor;
  final TextStyle? defaultTextStyle;

  final bool showHeader;
  final bool showFooter;

  final ListGridSearchConfig? searchConfig;

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

enum ListGridColumnSortingMode {
  none,
  asc,
  desc,
  both,
}

enum ListGridColumnSizingMode {
  flex,
  fixed,
}

enum ListGridConfigColumnSortMode {
  descending,
  ascending,
  none,
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
  // singleFieldArray,
  multiFieldString,
  underscoreTypeAhead,
}
