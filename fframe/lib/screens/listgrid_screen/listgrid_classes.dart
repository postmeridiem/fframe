part of fframe;

// ignore: must_be_immutable
class ListGridController extends InheritedModel<ListGridController> {
  ListGridController({
    super.key,
    required child,
    required this.theme,
    required this.listGridConfig,
    required this.columnWidths,
    required this.columnSettings,
    required this.viewportSize,
  }) : super(child: child) {
    _searchString = null;
    _collectionCount = null;
  }

  final ThemeData theme;

  final ListGridConfig listGridConfig;
  final Map<int, TableColumnWidth> columnWidths;
  final List<ListGridColumn> columnSettings;
  final Size viewportSize;
  late String? _searchString;
  late int? _collectionCount;

  // late Map<int, TableColumnWidth> columnWidths;

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
    return listGridConfig.cellBackgroundColor ?? theme.colorScheme.background;
  }

  Color get widgetColor {
    return listGridConfig.widgetColor ?? theme.colorScheme.onSurface;
  }

  Color get widgetBackgroundColor {
    return listGridConfig.widgetBackgroundColor ?? theme.colorScheme.surface;
  }

  TextStyle get widgetTextStyle {
    return listGridConfig.widgetTextStyle ??
        TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface,
        );
  }

  TextStyle get defaultTextStyle {
    return listGridConfig.defaultTextStyle ??
        TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSecondaryContainer,
        );
  }

  double? get headerHeight {
    return listGridConfig.showHeader ? null : 0;
  }

  double? get footerHeight {
    return listGridConfig.showFooter ? null : 0;
  }

  ListGridSearchConfig? get searchConfig {
    return listGridConfig.searchConfig;
  }

  int? get collectionCount {
    return _collectionCount;
  }

  set collectionCount(int? collectionCount) {
    _collectionCount = collectionCount;
  }

  String? get searchString {
    return _searchString;
  }

  set searchString(String? searchString) {
    //TODO: add some kind of rate limiting
    if (searchString != null && searchString.isNotEmpty) {
      _searchString = searchString;
      debugPrint("Set searching for: $_searchString");
    } else {
      _searchString = null;
    }
  }

  static ListGridController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ListGridController>();
  }

  static ListGridController of(BuildContext context) {
    final ListGridController? result = maybeOf(context);

    assert(result != null, 'No ListGridController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ListGridController oldWidget) {
    bool updated = false;

    // test if any fields are changed that should trigger an update
    updated = (listGridConfig != oldWidget.listGridConfig);
    updated = (columnSettings != oldWidget.columnSettings);
    updated = (columnWidths != oldWidget.columnWidths);
    updated = (theme != oldWidget.theme);
    updated = (_searchString != oldWidget._searchString);

    return updated;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant InheritedModel<ListGridController> oldWidget,
    Set<ListGridController> dependencies,
  ) {
    debugPrint(_searchString);
    // TODO: implement updateShouldNotifyDependent
    return true;
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
