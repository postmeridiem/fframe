part of fframe;

class ListGridHeader extends StatelessWidget {
  const ListGridHeader({
    super.key,
    required this.searchConfig,
    required this.calculatedWidth,
    required this.columnWidths,
    required this.columnSettings,
    required this.widgetBackgroundColor,
    required this.widgetColor,
    required this.widgetTextStyle,
    required this.cellPadding,
    required this.cellBorder,
    required this.headerHeight,
    required this.addEndFlex,
  });
  final ListGridSearchConfig? searchConfig;
  final double calculatedWidth;
  final Map<int, TableColumnWidth> columnWidths;
  final List<ListGridColumn> columnSettings;
  final Color widgetBackgroundColor;
  final Color widgetColor;
  final TextStyle widgetTextStyle;
  final EdgeInsetsGeometry cellPadding;
  final double cellBorder;
  final double? headerHeight;
  final bool addEndFlex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchConfig != null
            ? ListGridSearchWidget(
                searchConfig: searchConfig as ListGridSearchConfig,
                calculatedWidth: calculatedWidth,
                widgetColor: widgetColor,
                cellBorder: cellBorder,
              )
            : const IgnorePointer(),
        SizedBox(
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
                      widgetBackgroundColor: widgetBackgroundColor,
                      widgetTextStyle: widgetTextStyle,
                      widgetColor: widgetColor,
                    ),
                  ),
                ],
              ),
              // const Divider(
              //   height: 1,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> renderHeaderCells({
    required List<ListGridColumn> columnSettings,
    required Color widgetBackgroundColor,
    required Color widgetColor,
    // required EdgeInsetsGeometry padding,
    required TextStyle widgetTextStyle,
    required EdgeInsetsGeometry cellPadding,
    required double cellBorder,
  }) {
    List<Widget> output = [];
    for (ListGridColumn column in columnSettings) {
      output.add(
        Container(
          decoration: BoxDecoration(
            // color: Colors.green,
            color: widgetBackgroundColor,
            border: Border(
              right: cellBorder > 0
                  ? BorderSide(
                      color: widgetColor,
                      width: cellBorder,
                    )
                  : BorderSide.none,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: cellPadding,
                child: Text(
                  column.label,
                  textAlign: column.textAlign,
                  style: widgetTextStyle,
                ),
              ),
              HeaderSortingWidget(
                column: column,
                widgetColor: widgetColor,
                widgetBackgroundColor: widgetBackgroundColor,
              ),
            ],
          ),
        ),
      );
    }

    if (addEndFlex) {
      output.add(
        Container(
          decoration: BoxDecoration(
            // color: Colors.green,
            color: widgetBackgroundColor,
            border: const Border(
              right: BorderSide.none,
            ),
          ),
          child: Padding(
            padding: cellPadding,
            // child: const IgnorePointer(),
            child: Text(
              "",
              style: widgetTextStyle,
            ),
          ),
        ),
      );
    }
    return output;
  }
}

class ListGridSearchWidget extends StatelessWidget {
  const ListGridSearchWidget({
    super.key,
    required this.searchConfig,
    required this.calculatedWidth,
    required this.widgetColor,
    required this.cellBorder,
  });

  final ListGridSearchConfig searchConfig;
  final double calculatedWidth;
  final Color widgetColor;
  final double cellBorder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectionColor: Colors.grey.shade400,
          selectionHandleColor: widgetColor,
        ),
        focusColor: widgetColor,
      ),
      child: SizedBox(
        height: 40,
        width: calculatedWidth,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            // border: Border(
            //   bottom: BorderSide(
            //     color: widgetColor,
            //     width: cellBorder,
            //   ),
            // ),
          ),
          // color: Colors.white,
          child: Padding(
            // padding: EdgeInsets.only(left: 8.0, right: 8.0),
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.search),
                ),
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 40.0, right: 8.0),
                    focusColor: Theme.of(context).colorScheme.onPrimary,
                    // border: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        // color:
      ),
    );
  }
}

class HeaderSortingWidget extends StatelessWidget {
  const HeaderSortingWidget({
    super.key,
    required this.column,
    required this.widgetBackgroundColor,
    required this.widgetColor,
  });

  final ListGridColumn column;
  final Color widgetBackgroundColor;
  final Color widgetColor;

  @override
  Widget build(BuildContext context) {
    switch (column.columnSorting) {
      case ListGridColumnSortingMode.both:
        return Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 12,
                    width: 12,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        debugPrint(column.label);
                      },
                      icon: const Icon(Icons.expand_less),
                      iconSize: 12,
                      color: widgetBackgroundColor,
                      style: const ButtonStyle(
                        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.all(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                    width: 12,
                    child: IconButton(
                      isSelected: true,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        debugPrint(column.label);
                      },
                      icon: const Icon(Icons.expand_more),
                      iconSize: 12,
                      color: widgetColor,
                      style: ButtonStyle(
                        surfaceTintColor: MaterialStatePropertyAll<Color>(
                          Colors.grey.shade500,
                        ),
                        padding:
                            const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.all(0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case ListGridColumnSortingMode.asc:
        return const IgnorePointer();

      case ListGridColumnSortingMode.desc:
        return const IgnorePointer();

      case ListGridColumnSortingMode.none:
      default:
        return const IgnorePointer();
    }
  }
}

class ListGridFooter<T> extends StatelessWidget {
  const ListGridFooter({
    super.key,
    required this.viewportWidth,
    required this.widgetBackgroundColor,
    required this.widgetColor,
    required this.widgetTextStyle,
    required this.cellPadding,
    required this.footerHeight,
    required this.dataMode,
    required this.count,
  });
  final double viewportWidth;
  final Color widgetBackgroundColor;
  final Color widgetColor;
  final TextStyle widgetTextStyle;
  final EdgeInsetsGeometry cellPadding;
  final double? footerHeight;
  final ListGridDataMode dataMode;
  final int count;

  @override
  Widget build(BuildContext context) {
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
                    (dataMode == ListGridDataMode.autopager ||
                            dataMode == ListGridDataMode.pager)
                        ? ListGridPaginator(
                            collectionCount: count,
                            widgetTextStyle: widgetTextStyle,
                            widgetBackgroundColor: widgetBackgroundColor,
                            widgetColor: widgetColor,
                          )
                        : ListGridDefaultFooter(
                            collectionCount: count,
                            widgetTextStyle: widgetTextStyle,
                          ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class ListGridDefaultFooter extends StatelessWidget {
  const ListGridDefaultFooter({
    super.key,
    required this.collectionCount,
    required this.widgetTextStyle,
  });

  final int collectionCount;
  final TextStyle widgetTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 100.0),
          child: Text("count: $collectionCount", style: widgetTextStyle),
        ),
        const SizedBox(
          width: 280,
          child: IgnorePointer(),
        )
      ],
    );
  }
}

class ListGridPaginator extends StatelessWidget {
  const ListGridPaginator({
    super.key,
    required this.collectionCount,
    required this.widgetTextStyle,
    required this.widgetBackgroundColor,
    required this.widgetColor,
  });

  final int collectionCount;
  final TextStyle widgetTextStyle;
  final Color widgetBackgroundColor;
  final Color widgetColor;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      iconColor: MaterialStatePropertyAll(widgetBackgroundColor),
      backgroundColor: MaterialStatePropertyAll(widgetColor),
    );
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            "page 1 of 9 (count: $collectionCount)",
            style: widgetTextStyle,
          ),
        ),
        SizedBox(
          width: 280,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous_outlined),
                    label: const IgnorePointer(),
                    style: buttonStyle,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.navigate_before_outlined),
                    label: const IgnorePointer(),
                    style: buttonStyle,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.navigate_next_outlined),
                    label: const IgnorePointer(),
                    style: buttonStyle,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next_outlined),
                    label: const IgnorePointer(),
                    style: buttonStyle,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
