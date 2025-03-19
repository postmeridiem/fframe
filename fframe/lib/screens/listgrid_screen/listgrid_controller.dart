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
    return notifier.enableSearchBar;
  }

  String? get searchString {
    return notifier.searchString;
  }

  set searchString(String? searchString) {
    notifier.searchString = searchString;
  }

  List<int> get searchableColumns {
    return notifier.searchableColumns;
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
    return notifier.sortedColumnIndex;
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

