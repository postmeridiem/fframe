part of fframe;

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
    this.limit = 1000,
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
    required this.field,
  });
  final ListGridSearchMode mode;
  final String field;
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
  // multiFieldString,
  // multiFieldArray,
  underscoreTypeAhead,
}
