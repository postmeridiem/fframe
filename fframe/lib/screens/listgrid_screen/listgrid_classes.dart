part of 'package:fframe/fframe.dart';

class ListGridConfig<T> extends ListConfig {
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
    this.hideListOnDocumentOpen = false,
    this.openDocumentOnClick = true,
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
  final bool hideListOnDocumentOpen;
  final bool openDocumentOnClick;
  final String? searchHint;
  final List<ListGridActionMenu<T>> actionBar;
}

class ListGridActionMenu<T> {
  const ListGridActionMenu({
    required this.menuItems,
    this.label,
    this.icon,
  });

  final List<ListGridActionMenuItem<T>> menuItems;
  final String? label;
  final IconData? icon;
}

class ListGridActionMenuItem<T> {
  const ListGridActionMenuItem({
    required this.label,
    required this.icon,
    this.processSelection = true,
    required this.onClick,
  });

  final String label;
  final IconData icon;
  final bool processSelection;
  final ListGridActionHandler<T> onClick;
}

typedef ListGridActionHandler<T> = SelectedDocument<T>? Function(
  BuildContext context,
  FFrameUser? user,
  SelectedDocument<T>? selectedDocument,
  DocumentConfig<T> documentConfig,
);

class ListGridColumn<T> {

  final bool startsWithSearch;

  /// Creates a [ListGridColumn] instance.
  ///
  /// The [label] is the text displayed in the column header.
  ///
  /// The [visible] flag determines if the column is visible.
  ///
  /// The [fieldName] is the name of the field in the data object that this column represents.
  ///
  /// The [searchable] flag determines if this column can be searched.
  ///
  /// The [searchMask] allows you to define a search mask for this column.
  ///
  /// The [sortable] flag determines if this column can be sorted.
  ///
  /// The [descending] flag determines the default sort order.
  ///
  /// The [valueBuilder] is a function that builds the value to be displayed in the cell.
  ///
  /// The [cellBuilder] is a function that builds the widget to be displayed in the cell.
  ///
  /// The [columnSizing] determines how the column is sized.
  ///
  /// The [columnWidth] is the width of the column.
  ///
  /// The [alignment] is the alignment of the cell content.
  ///
  /// The [cellColor] is the background color of the cell.
  ///
  /// The [textSelectable] flag determines if the text in the cell can be selected.
  ///
  /// The [generateTooltip] flag determines if a tooltip should be generated for the cell.
  ///
  /// The [cellControlsBuilder] is a function that builds the controls to be displayed in the cell.
  ///
  /// The [onTableCellClick] is a function that is called when the cell is clicked.
  ///
  /// The [startsWithSearch] flag determines if the search should use a "starts with" or "contains" matching strategy.
  ///   - When set to `true`, the search will only match if the field's value *starts with* the search string.
  ///   - When set to `false` (the default), the search will match if the field's value *contains* the search string anywhere within it.
  ///
  /// Example:
  ///   - If `startsWithSearch` is `true` and the search string is "Jo", a field value of "John Doe" will match, but "Doe, John" will not.
  ///   - If `startsWithSearch` is `false` and the search string is "Jo", both "John Doe" and "Doe, John" will match.

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
    this.onTableCellClick,
    this.startsWithSearch = true, // Default to true (instead of contains)
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

  OnTableCellClick<T>? onTableCellClick;
}

typedef OnTableCellClick<T> = void Function(
  BuildContext context,
  SelectedDocument<T> document,
);

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

class ListGridSearchConfig<T> {
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

typedef ListGridValueBuilderFunction<T> = Function(
  BuildContext context,
  T data,
);

typedef ListGridCellBuilderFunction<T> = Widget Function(
  BuildContext context,
  SelectedDocument<T> selectedDocument,
  Function? onChange,
);

typedef ListGridCellControlsBuilderFunction<T> = List<IconButton> Function(
  BuildContext context,
  FFrameUser? user,
  SelectedDocument<T>? selectedDocument,
  String stringValue,
);
