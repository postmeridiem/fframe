import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListGrid extends StatefulWidget {
  const ListGrid({
    Key? key,
    required this.data,
    required this.columnSettings,
    this.rowBorder = 1,
    this.cellBorder = 0,
    this.cellPadding = const EdgeInsets.all(8.0),
    this.cellVerticalAlignment = TableCellVerticalAlignment.middle,
    this.cellBackgroundColor,
    this.headerHeight,
    this.widgetBackgroundColor,
    this.widgetTextStyle,
    this.footerHeight,
  }) : super(key: key);

  // TODO: rebuild this to a future builder? check how the DocList implemented this.
  final List<Map<String, Object>> data;
  final Map<int, ListGridColumn> columnSettings;

  final double rowBorder;
  final double cellBorder;
  final EdgeInsetsGeometry cellPadding;
  final TableCellVerticalAlignment cellVerticalAlignment;
  final Color? cellBackgroundColor;

  final Color? widgetBackgroundColor;
  final TextStyle? widgetTextStyle;

  final double? headerHeight;
  final double? footerHeight;

  @override
  State<ListGrid> createState() => _ListGridState();
}

class _ListGridState extends State<ListGrid> {
  final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    double calculatedMinWidth = 0;
    //extract column widths from settings for flutter Table
    Map<int, TableColumnWidth> columnWidths = {};
    widget.columnSettings.forEach((key, value) {
      calculatedMinWidth += value.columnWidth;
      if (value.columnSizing == ListGridColumnSizingMode.flex) {
        columnWidths.addAll({key: const FlexColumnWidth(1)});
      } else {
        columnWidths.addAll({key: FixedColumnWidth(value.columnWidth)});
      }
    });
    double viewportWidth = ((MediaQuery.of(context).size.width > 1000)
        ? (MediaQuery.of(context).size.width - 100)
        : (MediaQuery.of(context).size.width + 0));
    double calculatedWidth =
        calculatedMinWidth > viewportWidth ? calculatedMinWidth : viewportWidth;
    // calculatedWidth = (calculatedMinWidth * 3);

    // TODO: probably want to move all the styling defaults into the widget init, since this will not mutate any more, meh
    // set up cell borders,
    //apply passed cell styling settings to grid or default to theme sensible
    Color cellBackgroundColor =
        widget.cellBackgroundColor ?? Theme.of(context).colorScheme.surface;

    //apply passed chrome /widget components styling settings to grid or default to theme sensible
    Color widgetBackgroundColor = widget.widgetBackgroundColor ??
        Theme.of(context).colorScheme.background;
    TextStyle widgetTextStyle = widget.widgetTextStyle ??
        TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onBackground,
        );

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        color: widgetBackgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.headerHeight,
                width: calculatedWidth,
                child: Column(
                  children: [
                    Table(
                      columnWidths: columnWidths,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: renderHeaderCells(
                            columnSettings: widget.columnSettings,
                            padding: widget.cellPadding,
                            color: widgetBackgroundColor,
                            textStyle: widgetTextStyle,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  // height: double.infinity,
                  width: calculatedWidth,
                  child: Scrollbar(
                    controller: _vertical,
                    child: SingleChildScrollView(
                      controller: _vertical,
                      child: Table(
                        columnWidths: columnWidths,
                        defaultColumnWidth: const FlexColumnWidth(),
                        defaultVerticalAlignment: widget.cellVerticalAlignment,
                        textBaseline: TextBaseline.alphabetic,
                        children: renderRows(
                          data: widget.data,
                          columnSettings: widget.columnSettings,
                          backgroundColor: cellBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: widget.footerHeight,
                width: calculatedWidth,
                child: Column(
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    Container(
                      color: widgetBackgroundColor,
                      child: Padding(
                        padding: widget.cellPadding,
                        child: Text(
                          "footer",
                          style: widgetTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> renderRows(
      {required List<Map<String, Object>> data,
      required Map<int, ListGridColumn> columnSettings,
      required Color backgroundColor}) {
    List<TableRow> output = [];

    for (var rowdata in data) {
      output.add(TableRow(
          children: renderCells(
              data: rowdata,
              padding: widget.cellPadding,
              rowBorder: widget.rowBorder,
              cellBorder: widget.cellBorder,
              columnSettings: columnSettings,
              backgroundColor: backgroundColor)));
    }
    return output;
    // return [
    //   TableRow(
    //     children: [
    //       renderCell(
    //         child: Text(
    //           "cell 1",
    //         ),
    //         padding: widget.cellPadding,
    //         color: backgroundColor,
    //       ),
    //       renderCell(
    //         child: Text(
    //           "cell 2",
    //         ),
    //         padding: widget.cellPadding,
    //         color: backgroundColor,
    //       ),
    //       renderCell(
    //         child: Text(
    //           "cell 3",
    //         ),
    //         padding: widget.cellPadding,
    //         color: backgroundColor,
    //         // cellColor:
    //       ),
    //       renderCell(
    //         child: Text(
    //           "cell 4",
    //         ),
    //         padding: widget.cellPadding,
    //         color: backgroundColor,
    //       ),
    //     ],
    //   ),
    // ];
  }

  List<Widget> renderCells(
      {required Map<String, Object> data,
      required Map<int, ListGridColumn> columnSettings,
      required EdgeInsetsGeometry padding,
      required Color backgroundColor,
      required double rowBorder,
      required double cellBorder}) {
    List<Widget> output = [];
    columnSettings.forEach((key, value) {
      ListGridColumn currentColumn = columnSettings[key] as ListGridColumn;
      Object celldata = data[currentColumn.key] as Object;
      if (currentColumn.cellBuilder == null) {
        output.add(
          Padding(
            padding: EdgeInsets.only(bottom: rowBorder, right: cellBorder),
            child: Container(
              color: backgroundColor,
              child: Padding(
                padding: padding,
                child: Text(
                  "$celldata",
                  textAlign: currentColumn.textAlign,
                ),
              ),
            ),
          ),
        );
      } else {
        output.add(
          Padding(
            padding: EdgeInsets.only(bottom: rowBorder, right: cellBorder),
            child: Container(
              color: backgroundColor,
              child: Padding(
                padding: padding,
                child: currentColumn.cellBuilder!(context, celldata),
              ),
            ),
          ),
        );
      }
    });

    return output;
  }

  BoxDecoration getRowDecorations() {
    // return BoxDecoration(
    //   border: Border.all(
    //     width: 1,
    //   ),
    // );
    return BoxDecoration(
      color: const Color(0xff7c94b6),
      image: const DecorationImage(
        image: NetworkImage(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        fit: BoxFit.cover,
      ),
      border: Border.all(
        width: 8,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  List<Widget> renderHeaderCells(
      {required Map<int, ListGridColumn> columnSettings,
      required Color color,
      required EdgeInsetsGeometry padding,
      required TextStyle textStyle}) {
    List<Widget> output = [];
    columnSettings.forEach((key, value) {
      ListGridColumn currentColumn = columnSettings[key] as ListGridColumn;
      output.add(
        Container(
          color: color,
          child: Padding(
            padding: padding,
            child: Text(
              value.header,
              style: textStyle,
              textAlign: currentColumn.textAlign,
            ),
          ),
        ),
      );
    });
    return output;
  }
}

class ListGridColumn {
  ListGridColumn({
    required this.key,
    required this.header,
    this.columnSizing = ListGridColumnSizingMode.flex,
    this.columnWidth = 200,
    this.textAlign = TextAlign.start,
    this.cellColor,
    this.cellBuilder,

    // this.dynamicTextStyle,
    // this.dynamicBackgroundColor,
  });
  String key;
  String header;
  ListGridColumnSizingMode columnSizing;
  double columnWidth;
  TextAlign textAlign;

  Color? cellColor;

  Function? cellBuilder;

  // TODO: needs to expose the current row data for calculations and needs to enforce TextStyle and Color as data type
  // Function? dynamicTextStyle;
  // Function? dynamicBackgroundColor;
}

enum ListGridColumnSizingMode { flex, fixed }
