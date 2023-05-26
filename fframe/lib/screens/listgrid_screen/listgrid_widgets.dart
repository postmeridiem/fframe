part of fframe;

class ListGridHeader extends StatelessWidget {
  const ListGridHeader({
    super.key,
    required this.calculatedWidth,
    required this.addEndFlex,
    required this.rowsSelectable,
  });
  final double calculatedWidth;
  final bool addEndFlex;
  final bool rowsSelectable;

  @override
  Widget build(BuildContext context) {
    ListGridController listgrid = ListGridController.of(context);
    return SizedBox(
      height: listgrid.headerHeight,
      width: calculatedWidth,
      child: Column(
        children: [
          Table(
            columnWidths: listgrid.columnWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: renderHeaderCells(
                  context: context,
                  columnSettings: listgrid.columnSettings,
                  cellPadding: listgrid.cellPadding,
                  cellBorder: listgrid.cellBorder,
                  widgetBackgroundColor: listgrid.widgetBackgroundColor,
                  widgetTextColor: listgrid.widgetTextColor,
                  widgetTextSize: listgrid.widgetTextSize,
                  widgetColor: listgrid.widgetColor,
                  sortedColumnIndex: listgrid.sortedColumnIndex,
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
    required BuildContext context,
    required List<ListGridColumn> columnSettings,
    required Color widgetBackgroundColor,
    required Color widgetColor,
    required Color widgetTextColor,
    required double widgetTextSize,
    required EdgeInsetsGeometry cellPadding,
    required double cellBorder,
    required int? sortedColumnIndex,
  }) {
    List<Widget> output = [];

    if (rowsSelectable) {
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
            // draw an
            child: Text(
              "",
              style: TextStyle(
                fontSize: widgetTextSize,
              ),
            ),
          ),
        ),
      );
    }

    for (var i = 0; i < columnSettings.length; i++) {
      bool isSorted = (sortedColumnIndex != null && sortedColumnIndex == i);
      ListGridColumn column = columnSettings[i];
      if (column.visible) {
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
            child: Stack(alignment: column.alignment, children: [
              Padding(
                padding: cellPadding,
                child: Text(
                  column.label,
                  style: TextStyle(
                    color: isSorted
                        ? Theme.of(context).colorScheme.onBackground
                        : widgetTextColor,
                    fontSize: widgetTextSize,
                  ),
                ),
              ),
              HeaderSortingWidget(
                column: column,
                columnIndex: i,
                widgetColor: widgetColor,
              )
            ]),
          ),
        );
      }
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
              style: TextStyle(
                fontSize: widgetTextSize,
              ),
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
    required this.listgrid,
  });
  final ListGridController listgrid;

  @override
  Widget build(BuildContext context) {
    Color widgetColor = listgrid.widgetColor;
    double calculatedWidth = listgrid.calculatedWidth;
    List<InputChip> searchChips = [];

    if (listgrid.searchableColumns.length > 1) {
      for (int searchableColumnIndex in listgrid.searchableColumns) {
        ListGridColumn searchableColumn =
            listgrid.columnSettings[searchableColumnIndex];
        searchChips.add(
          InputChip(
            label: Text(
              searchableColumn.label,
              style: TextStyle(color: listgrid.widgetColor),
            ),
            backgroundColor: listgrid.widgetBackgroundColor,
            disabledColor: listgrid.widgetBackgroundColor,
          ),
        );
      }
    }
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
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                focusColor: Theme.of(context).colorScheme.onPrimary,
                // prefix: Card(
                //   // color: Colors.amber,
                //   child: Wrap(
                //     children: searchChips,
                //   ),
                // ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (String value) {
                ListGridController.of(context).searchString = value;
              },
            ),
          ),
        ),
        // color:
      ),
    );
  }
}

class ListGridActionBarWidget<T> extends StatelessWidget {
  const ListGridActionBarWidget({
    super.key,
    required this.listgrid,
  });

  final ListGridController listgrid;

  @override
  Widget build(BuildContext context) {
    double calculatedWidth = listgrid.calculatedWidth;
    Color widgetColor = listgrid.widgetColor;
    Color widgetBackgroundColor = listgrid.widgetBackgroundColor;
    double cellBorder = listgrid.cellBorder;
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
        height: 36,
        width: calculatedWidth,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              color: widgetBackgroundColor,
              border: Border(
                bottom: cellBorder > 0
                    ? BorderSide(
                        color: widgetColor,
                        width: cellBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Row(
              children: [
                ListGridActionMenu(
                  listgrid: listgrid,
                  label: "Set Inactive",
                  icon: Icons.toggle_off_outlined,
                  requireSelection: true,
                ),
                ListGridActionMenu(
                  listgrid: listgrid,
                  label: "Set Active",
                  icon: Icons.toggle_on,
                  requireSelection: true,
                ),
                ListGridActionMenu(
                  listgrid: listgrid,
                  label: "Delete",
                  icon: Icons.delete_outlined,
                  requireSelection: true,
                ),
                ListGridActionMenu(
                  listgrid: listgrid,
                  label: "Help",
                  icon: Icons.help_outline,
                  requireSelection: false,
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

class ListGridActionMenu extends StatefulWidget {
  const ListGridActionMenu({
    super.key,
    required this.listgrid,
    required this.icon,
    required this.label,
    required this.requireSelection,
  });

  final ListGridController listgrid;
  final IconData icon;
  final String label;
  final bool requireSelection;

  @override
  State<ListGridActionMenu> createState() => _ListGridActionMenuState();
}

class _ListGridActionMenuState extends State<ListGridActionMenu> {
  @override
  Widget build(BuildContext context) {
    ListGridController listgrid = widget.listgrid;

    bool isEnabled = (widget.listgrid.selectionCount > 0);
    // enable ActionMenu if selection requirement is not set
    isEnabled = widget.requireSelection ? isEnabled : true;

    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: listgrid.cellBorder > 0
                ? BorderSide(
                    color: listgrid.widgetColor,
                    width: listgrid.cellBorder,
                  )
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: listgrid.widgetColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSortingWidget extends StatelessWidget {
  const HeaderSortingWidget({
    super.key,
    required this.column,
    required this.columnIndex,
    required this.widgetColor,
  });

  final ListGridColumn column;
  final int columnIndex;
  final Color widgetColor;

  @override
  Widget build(BuildContext context) {
    ListGridController controller = ListGridController.of(context);
    if (column.sortable) {
      bool isSorted = (columnIndex == controller.sortedColumnIndex);
      return Positioned.fill(
          child: Align(
              alignment: (column.alignment == Alignment.bottomLeft ||
                      column.alignment == Alignment.topLeft)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          controller.sortColumn(
                              columnIndex: columnIndex, descending: false);
                        },
                        icon: const Icon(Icons.expand_less),
                        iconSize: 12,
                        color: (isSorted && !column.descending)
                            ? Theme.of(context).colorScheme.onBackground
                            : widgetColor,
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
                          controller.sortColumn(
                              columnIndex: columnIndex, descending: true);
                        },
                        icon: const Icon(Icons.expand_more),
                        iconSize: 12,
                        color: (isSorted && column.descending)
                            ? Theme.of(context).colorScheme.onBackground
                            : widgetColor,
                        style: ButtonStyle(
                          surfaceTintColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.shade500,
                          ),
                          padding: const MaterialStatePropertyAll<
                              EdgeInsetsGeometry>(
                            EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )));
    } else {
      return const IgnorePointer();
    }
  }
}

class ListGridFooter<T> extends StatelessWidget {
  const ListGridFooter({
    super.key,
    required this.viewportWidth,
    required this.dataMode,
  });
  final double viewportWidth;
  final ListGridDataMode dataMode;

  @override
  Widget build(BuildContext context) {
    ListGridController listgrid = ListGridController.of(context);
    int collectionCount = listgrid.collectionCount ?? 0;
    int selectionCount = listgrid.selectionCount;
    return SizedBox(
      height: listgrid.footerHeight,
      width: viewportWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Divider(
          //   height: 1,
          // ),
          Container(
            color: listgrid.widgetBackgroundColor,
            child: Padding(
                padding: listgrid.cellPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const IgnorePointer(),
                    (dataMode == ListGridDataMode.autopager ||
                            dataMode == ListGridDataMode.pager)
                        ? ListGridPaginator(
                            collectionCount: collectionCount,
                            widgetTextColor: listgrid.widgetTextColor,
                            widgetTextSize: listgrid.widgetTextSize,
                            widgetBackgroundColor:
                                listgrid.widgetBackgroundColor,
                            widgetColor: listgrid.widgetColor,
                          )
                        : ListGridDefaultFooter(
                            collectionCount: collectionCount,
                            selectionCount: selectionCount,
                            widgetTextColor: listgrid.widgetTextColor,
                            widgetTextSize: listgrid.widgetTextSize,
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
    required this.selectionCount,
    required this.widgetTextColor,
    required this.widgetTextSize,
  });

  final int collectionCount;
  final int selectionCount;
  final Color widgetTextColor;
  final double widgetTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 100.0),
          child: Text(
            "count: $collectionCount",
            style: TextStyle(
              color: widgetTextColor,
              fontSize: widgetTextSize,
            ),
          ),
        ),
        selectionCount > 0
            ? Padding(
                padding: const EdgeInsets.only(right: 100.0),
                child: Text(
                  "(selected: $selectionCount)",
                  style: TextStyle(
                    color: widgetTextColor,
                    fontSize: widgetTextSize,
                  ),
                ),
              )
            : const IgnorePointer(),
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
    required this.widgetTextColor,
    required this.widgetTextSize,
    required this.widgetBackgroundColor,
    required this.widgetColor,
  });

  final int collectionCount;
  final Color widgetTextColor;
  final double widgetTextSize;
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
            style: TextStyle(
              color: widgetTextColor,
              fontSize: widgetTextSize,
            ),
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

class ListGridRowSelector<T> extends StatefulWidget {
  const ListGridRowSelector({
    super.key,
    required this.listgrid,
    required this.documentId,
    required this.document,
  });

  final ListGridController listgrid;
  final String documentId;
  final T document;

  @override
  State<ListGridRowSelector> createState() => _ListGridRowSelectorState();
}

class _ListGridRowSelectorState extends State<ListGridRowSelector> {
  @override
  Widget build(BuildContext context) {
    ListGridController listgrid = widget.listgrid;
    bool isSelected = listgrid.listGridSelection.containsKey(widget.documentId);
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.green,
          color: listgrid.cellBackgroundColor,
          border: Border(
            bottom: listgrid.rowBorder > 0
                ? BorderSide(
                    color: listgrid.widgetBackgroundColor,
                    width: listgrid.rowBorder,
                  )
                : BorderSide.none,
          ),
        ),
        child: MouseRegion(
          child: Opacity(
            opacity: isSelected ? 0.8 : 0.2,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: isSelected
                  ? () {
                      ListGridController.of(context)
                          .unselectRow(documentId: widget.documentId);
                    }
                  : () {
                      ListGridController.of(context).selectRow(
                          documentId: widget.documentId,
                          document: widget.document);
                    },
              icon: Icon(
                isSelected
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank_outlined,
              ),
              color: listgrid.widgetColor,
            ),
          ),
        ),
      ),
    );
  }
}

class ListGridDataCell<T> extends StatefulWidget {
  const ListGridDataCell({
    super.key,
    required this.listgrid,
    required this.column,
    required this.stringValue,
    required this.document,
  });

  final ListGridController listgrid;
  final ListGridColumn column;
  final String stringValue;
  final T document;

  @override
  State<ListGridDataCell> createState() => _ListGridDataCellState<T>();
}

class _ListGridDataCellState<T> extends State<ListGridDataCell<T>> {
  bool cellMouseOver = false;
  bool buttonMouseOver = false;
  @override
  Widget build(BuildContext context) {
    ListGridController listgrid = widget.listgrid;
    ListGridColumn column = widget.column;
    // dynamic dynValue =
    //     column.valueBuilder!(context, widget.document as T);
    String stringValue = widget.stringValue;

    void cellMouseIn(PointerEvent details) {
      setState(() {
        cellMouseOver = true;
      });
    }

    void cellMouseOut(PointerEvent details) {
      setState(() {
        cellMouseOver = false;
      });
    }

    void buttonMouseIn(PointerEvent details) {
      setState(() {
        buttonMouseOver = true;
      });
    }

    void buttonMouseOut(PointerEvent details) {
      setState(() {
        buttonMouseOver = false;
      });
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: MouseRegion(
        onEnter: cellMouseIn,
        onExit: cellMouseOut,
        child: Container(
            decoration: BoxDecoration(
              // color: Colors.green,
              color: listgrid.cellBackgroundColor,
              border: Border(
                right: listgrid.cellBorder > 0
                    ? BorderSide(
                        color: listgrid.widgetBackgroundColor,
                        width: listgrid.cellBorder,
                      )
                    : BorderSide.none,
                bottom: listgrid.rowBorder > 0
                    ? BorderSide(
                        color: listgrid.widgetBackgroundColor,
                        width: listgrid.rowBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Stack(
              alignment: column.alignment,
              children: [
                column.generateTooltip
                    ? Tooltip(
                        message: prepTooltip(stringValue),
                        child: Padding(
                          padding: listgrid.cellPadding,
                          child: column.textSelectable
                              ? SelectableText(
                                  stringValue,
                                  style: listgrid.defaultTextStyle,
                                  // overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  stringValue,
                                  style: listgrid.defaultTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          // child: const Text("cell"),
                        ),
                      )
                    : Padding(
                        padding: listgrid.cellPadding,
                        child: column.textSelectable
                            ? SelectableText(
                                stringValue,
                                style: listgrid.defaultTextStyle,
                                // overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                stringValue,
                                style: listgrid.defaultTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                        // child: const Text("cell"),
                      ),
                (column.cellControlsBuilder != null)
                    ? Row(
                        mainAxisAlignment:
                            (column.alignment == Alignment.bottomLeft ||
                                    column.alignment == Alignment.topLeft)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity:
                                buttonMouseOver ? 1 : (cellMouseOver ? 0.2 : 0),
                            child: MouseRegion(
                              onEnter: buttonMouseIn,
                              onExit: buttonMouseOut,
                              child: Card(
                                color: listgrid.widgetBackgroundColor,
                                child: Row(
                                  children: buttonMouseOver
                                      ? column.cellControlsBuilder!(
                                          context,
                                          Fframe.of(context)!.user,
                                          widget.document,
                                          stringValue,
                                        )
                                      : [
                                          column
                                              .cellControlsBuilder!(
                                            context,
                                            Fframe.of(context)!.user,
                                            widget.document,
                                            stringValue,
                                          )
                                              .first
                                        ],
                                  // children: [],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const IgnorePointer(),
              ],
            )),
      ),
    );
  }

  String prepTooltip(String input) {
    String output = "";
    List<String> words = input.split(" ");
    for (var i = 0; i < words.length; i++) {
      String word = words[i];
      output = "$output $word";
      if (i % 6 == 5) {
        output = "$output \n";
      }
    }

    return output;
  }
}
