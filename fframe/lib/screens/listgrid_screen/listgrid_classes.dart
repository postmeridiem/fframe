part of fframe;

class ListGridConfig<T> {
  ListGridConfig({
    required this.columnSettings,
    this.dataMode = const ListGridDataModeConfig(mode: ListGridDataMode.all),
    this.widgetBackgroundColor,
    this.widgetColor,
    this.widgetAccentColor,
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
    this.searchHint,
    this.actionBar = const [],
  });

  final List<ListGridColumn<T>> columnSettings;
  final ListGridDataModeConfig dataMode;

  final Color? widgetBackgroundColor;
  final Color? widgetColor;
  final Color? widgetAccentColor;
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
  final String? searchHint;
  final List<ListGridActionMenu<T>> actionBar;

  late T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
      fromFirestore;
  late Map<String, Object?> Function(T, SetOptions?) toFirestore;
}

class ListGridActionMenu<T> {
  const ListGridActionMenu({
    required this.menuItems,
    this.label,
    this.icon,
  });
  final List<ListGridActionMenuItem> menuItems;
  final String? label;
  final IconData? icon;
}

class ListGridActionMenuItem<T> {
  const ListGridActionMenuItem({
    required this.label,
    required this.icon,
    this.requireSelection = true,
    required this.clickHandler,
  });
  final String label;
  final IconData icon;
  final bool requireSelection;
  final ListGridActionHandler<T> clickHandler;
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
