part of fframe;

class ListGridHeader extends StatelessWidget {
  const ListGridHeader({
    super.key,
    required this.calculatedWidth,
    required this.columnWidths,
    required this.columnSettings,
    required this.widgetBackgroundColor,
    required this.widgetTextStyle,
    required this.cellBorderColor,
    required this.cellPadding,
    required this.cellBorder,
    required this.headerHeight,
    required this.addEndFlex,
  });
  final double calculatedWidth;
  final Map<int, TableColumnWidth> columnWidths;
  final List<ListGridColumn> columnSettings;
  final Color widgetBackgroundColor;
  final TextStyle widgetTextStyle;
  final Color cellBorderColor;
  final EdgeInsetsGeometry cellPadding;
  final double cellBorder;
  final double? headerHeight;
  final bool addEndFlex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: headerHeight,
      width: calculatedWidth,
      child: Column(
        children: [
          Table(
            columnWidths: columnWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: renderHeaderCells(
                  columnSettings: columnSettings,
                  cellPadding: cellPadding,
                  cellBorder: cellBorder,
                  color: widgetBackgroundColor,
                  widgetTextStyle: widgetTextStyle,
                  cellBorderColor: cellBorderColor,
                ),
              ),
            ],
          ),
          // const Divider(
          //   height: 1,
          // ),
        ],
      ),
    );
  }

  List<Widget> renderHeaderCells({
    required List<ListGridColumn> columnSettings,
    required Color color,
    // required EdgeInsetsGeometry padding,
    required TextStyle widgetTextStyle,
    required EdgeInsetsGeometry cellPadding,
    required double cellBorder,
    required Color cellBorderColor,
  }) {
    List<Widget> output = [];
    for (ListGridColumn column in columnSettings) {
      output.add(
        Container(
          decoration: BoxDecoration(
            // color: Colors.green,
            color: color,
            border: Border(
              right: cellBorder > 0
                  ? BorderSide(
                      color: cellBorderColor,
                      width: cellBorder,
                    )
                  : BorderSide.none,
            ),
          ),
          child: Padding(
            padding: cellPadding,
            child: Text(
              column.label,
              style: widgetTextStyle,
              textAlign: column.textAlign,
            ),
          ),
        ),
      );
    }

    if (addEndFlex) {
      output.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.bottom,
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.green,
              color: color,
              border: Border(
                right: cellBorder > 0
                    ? BorderSide(
                        color: cellBorderColor,
                        width: cellBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: cellPadding,
              child: const IgnorePointer(),
              // child: const Text("cell"),
            ),
          ),
        ),
      );
    }
    return output;
  }
}

class ListGridFooter extends StatelessWidget {
  const ListGridFooter({
    super.key,
    required this.viewportWidth,
    required this.widgetBackgroundColor,
    required this.widgetTextStyle,
    required this.cellPadding,
    required this.footerHeight,
    required this.dataMode,
  });
  final double viewportWidth;
  final Color widgetBackgroundColor;
  final TextStyle widgetTextStyle;
  final EdgeInsetsGeometry cellPadding;
  final double? footerHeight;
  final ListGridDatarMode dataMode;

  @override
  Widget build(BuildContext context) {
    debugPrint("VPW: $viewportWidth");
    return SizedBox(
      height: footerHeight,
      width: viewportWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Divider(
          //   height: 1,
          // ),
          Container(
            color: widgetBackgroundColor,
            child: Padding(
                padding: cellPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const IgnorePointer(),
                    (dataMode == ListGridDatarMode.autopager ||
                            dataMode == ListGridDatarMode.pager)
                        ? Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "page 1 of 9 (count: 82)",
                                  style: widgetTextStyle,
                                ),
                              ),
                              Card(
                                child: Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.skip_previous_outlined),
                                      label: const IgnorePointer(),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.navigate_before_outlined),
                                      label: const IgnorePointer(),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.navigate_next_outlined),
                                      label: const IgnorePointer(),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon:
                                          const Icon(Icons.skip_next_outlined),
                                      label: const IgnorePointer(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text("count: 82"),
                          ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
