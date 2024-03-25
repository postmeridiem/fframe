part of '../../fframe.dart';

class ListGridHeader<T> extends StatelessWidget {
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
    ListGridController listGridController = ListGridController.of(context);
    return SizedBox(
      height: listGridController.headerHeight,
      width: calculatedWidth,
      child: Column(
        children: [
          Table(
            columnWidths: listGridController.columnWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: renderHeaderCells(
                  context: context,
                  columnSettings: listGridController.columnSettings,
                  cellPadding: listGridController.cellPadding,
                  cellBorder: listGridController.cellBorder,
                  widgetBackgroundColor: listGridController.widgetBackgroundColor,
                  widgetTextColor: listGridController.widgetTextColor,
                  widgetAccentColor: listGridController.widgetAccentColor,
                  widgetTextSize: listGridController.widgetTextSize,
                  widgetColor: listGridController.widgetColor,
                  sortedColumnIndex: listGridController.sortedColumnIndex,
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
    required Color widgetAccentColor,
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

    for (var i = 0; i < (columnSettings.length); i++) {
      bool isSorted = (sortedColumnIndex != null && sortedColumnIndex == i);
      ListGridColumn column = columnSettings[i];
      if (column.visible) {
        output.add(
          Container(
            decoration: BoxDecoration(
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
                    color: isSorted ? widgetAccentColor : widgetTextColor,
                    fontSize: widgetTextSize,
                  ),
                ),
              ),
              ListGridHeaderSortingWidget(
                column: column,
                columnIndex: i,
                widgetColor: widgetColor,
                widgetAccentColor: widgetAccentColor,
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

class ListGridSearchWidget<T> extends StatelessWidget {
  const ListGridSearchWidget({
    super.key,
    required this.listGridController,
    // required this.documentOpen,
  });
  final ListGridController listGridController;
  // final bool documentOpen;

  @override
  Widget build(BuildContext context) {
    Color widgetColor = listGridController.widgetColor;
    double calculatedWidth = listGridController.calculatedWidth;

    ///lalalala
    List<InputChip> searchChips = [];

    if (listGridController.searchableColumns.length > 1) {
      for (int searchableColumnIndex in listGridController.searchableColumns) {
        ListGridColumn searchableColumn = listGridController.columnSettings[searchableColumnIndex];
        searchChips.add(
          InputChip(
            label: Text(
              searchableColumn.label,
              style: TextStyle(color: listGridController.widgetColor),
            ),
            backgroundColor: listGridController.widgetBackgroundColor,
            disabledColor: listGridController.widgetBackgroundColor,
          ),
        );
      }
    }
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectionColor: Theme.of(context).colorScheme.onBackground,
          selectionHandleColor: widgetColor,
        ),
        focusColor: widgetColor,
      ),
      child: SizedBox(
        height: 40,
        width: calculatedWidth,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: listGridController.listGridConfig.searchHint,
                hintStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
                contentPadding: const EdgeInsets.all(10.0),
                focusColor: Theme.of(context).colorScheme.onSurfaceVariant,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
    required this.listGridController,
  });

  final ListGridController listGridController;

  @override
  Widget build(BuildContext context) {
    ListGridConfig<T> listGridConfig = listGridController.listGridConfig as ListGridConfig<T>;
    double calculatedWidth = listGridController.calculatedWidth;
    Color widgetColor = listGridController.widgetColor;
    Color widgetBackgroundColor = listGridController.widgetBackgroundColor;
    double cellBorder = listGridController.cellBorder;
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
              children: renderActionBar(actionBar: listGridConfig.actionBar),
            ),
          ),
        ),
        // color:
      ),
    );
  }

  List<ListGridActionMenuWidget<T>> renderActionBar({required List<ListGridActionMenu<T>> actionBar}) {
    List<ListGridActionMenuWidget<T>> output = [];

    for (ListGridActionMenu<T> actionMenu in actionBar) {
      bool isMenuHeader = actionMenu.menuItems.length > 1;
      output.add(
        ListGridActionMenuWidget<T>(
          listGridController: listGridController,
          actionMenu: actionMenu,
          isMenuHeader: isMenuHeader,
        ),
      );
    }
    return output;
    // return [
    //   ListGridActionMenuWidget(
    //     listgrid: listgrid,
    //     label: "Set Inactive",
    //     icon: Icons.toggle_off_outlined,
    //     requireSelection: true,
    //   ),
    //   ListGridActionMenuWidget(
    //     listgrid: listgrid,
    //     label: "Set Active",
    //     icon: Icons.toggle_on,
    //     requireSelection: true,
    //   ),
    //   ListGridActionMenuWidget(
    //     listgrid: listgrid,
    //     label: "Delete",
    //     icon: Icons.delete_outlined,
    //     requireSelection: true,
    //   ),
    //   ListGridActionMenuWidget(
    //     listgrid: listgrid,
    //     label: "Help",
    //     icon: Icons.help_outline,
    //     requireSelection: false,
    //   ),
    // ];
  }
}

class ListGridActionMenuWidget<T> extends StatefulWidget {
  const ListGridActionMenuWidget({
    super.key,
    required this.listGridController,
    required this.actionMenu,
    required this.isMenuHeader,
  });

  final ListGridController listGridController;
  final ListGridActionMenu<T> actionMenu;
  final bool isMenuHeader;

  @override
  State<ListGridActionMenuWidget<T>> createState() => _ListGridActionMenuWidgetState<T>();
}

class _ListGridActionMenuWidgetState<T> extends State<ListGridActionMenuWidget<T>> {
  late OverlayEntry? menuWidget;
  late bool menuOpen = false;
  late bool mouseOver = false;
  @override
  void initState() {
    super.initState();
    menuWidget = null;
  }

  void openMenu({required ListGridController listGridController, required ListGridActionMenu<T> actionMenu}) {
    if (menuOpen) {
      // menu was already open. tap just means close
      closeMenu();
    } else {
      // menu was closed, open menu
      final OverlayState overlay = Overlay.of(context);
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Size size = renderBox.size;
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      List<Widget> menuItems = [];
      for (var actionMenuItem in actionMenu.menuItems) {
        menuItems.add(
          ListGridActionMenuItemWidget<T>(
            listGridController: listGridController,
            actionMenuItem: actionMenuItem,
          ),
        );
      }

      menuWidget = OverlayEntry(
        builder: (context) => Positioned(
          width: size.width + 20,
          left: offset.dx,
          top: (offset.dy + size.height + 7),
          child: Material(
            elevation: 1,
            color: listGridController.widgetBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: menuItems,
              ),
            ),
          ),
        ),
      );

      overlay.insert(menuWidget!);
      mouseOver = false;
      menuOpen = true;
    }
  }

  void closeMenu() {
    if (menuWidget == null || menuWidget?.mounted == false) return;
    menuWidget?.remove();
    menuWidget = null;
    menuOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    ListGridController listGridController = widget.listGridController;
    ListGridActionMenu<T> actionMenu = widget.actionMenu;
    ListGridNotifier<T> listGridNotifier = listGridController.notifier as ListGridNotifier<T>;
    List<SelectedDocument<T>> selectedDocuments = listGridNotifier.selectedDocuments;
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<T>;

    FFrameUser fFrameUser = documentScreenConfig.fFrameUser;
    if (widget.isMenuHeader) {
      String label = actionMenu.label ?? actionMenu.menuItems.first.label;
      IconData icon = actionMenu.icon ?? actionMenu.menuItems.first.icon;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            mouseOver = true;
          });
        },
        onExit: (event) {
          setState(() {
            mouseOver = false;
          });
        },
        child: TapRegion(
          onTapInside: (event) {
            openMenu(listGridController: listGridController, actionMenu: actionMenu);
          },
          onTapOutside: (event) {
            closeMenu();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: listGridController.cellBorder > 0
                    ? BorderSide(
                        color: listGridController.widgetColor,
                        width: listGridController.cellBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: (mouseOver) ? listGridController.widgetAccentColor : listGridController.widgetColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: (mouseOver) ? listGridController.widgetAccentColor : listGridController.widgetColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      ListGridActionMenuItem<T> listGridActionMenuItem = actionMenu.menuItems.first;
      bool isEnabled = (listGridActionMenuItem.processSelection == false) || (listGridNotifier.selectionCount > 0);
      ListGridActionMenuItem<T> headerItem = actionMenu.menuItems.first;
      return Opacity(
        opacity: isEnabled ? 1 : 0.4,
        child: MouseRegion(
          cursor: isEnabled ? SystemMouseCursors.click : MouseCursor.defer,
          onEnter: isEnabled
              ? (event) {
                  setState(() {
                    mouseOver = true;
                  });
                }
              : (event) {},
          onExit: isEnabled
              ? (event) {
                  setState(() {
                    mouseOver = false;
                  });
                }
              : (event) {},
          child: TapRegion(
            onTapInside: isEnabled
                ? (event) {
                    Console.log("Run action ${listGridActionMenuItem.label} selection: ${listGridActionMenuItem.processSelection}", scope: "ListGridActionMenuItem.TapRegion", level: LogLevel.prod);

                    if (listGridActionMenuItem.processSelection == false) {
                      SelectedDocument<T>? updatedDocument = listGridActionMenuItem.onClick(context, fFrameUser, null, documentConfig);
                      if (updatedDocument?.isNew == false) {
                        updatedDocument!.update();
                      }
                    } else {
                      for (SelectedDocument<T> selectedDocument in selectedDocuments) {
                        SelectedDocument<T>? updatedDocument = listGridActionMenuItem.onClick(context, fFrameUser, selectedDocument, documentConfig);
                        if (updatedDocument?.isNew == false) {
                          updatedDocument!.update();
                        }
                      }
                    }
                  }
                : (event) {},
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: listGridController.cellBorder > 0
                      ? BorderSide(
                          color: listGridController.widgetColor,
                          width: listGridController.cellBorder,
                        )
                      : BorderSide.none,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Icon(
                      headerItem.icon,
                      color: (isEnabled && mouseOver) ? listGridController.widgetAccentColor : listGridController.widgetColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        headerItem.label,
                        style: TextStyle(
                          color: (isEnabled && mouseOver) ? listGridController.widgetAccentColor : listGridController.widgetColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  // void createDocument() {
  //   FRouter router = FRouter.of(context);
  //   if (router.queryStringParam("id") == null) {
  //     router.updateQueryString(queryParameters: {"new": "true"});
  //   } else {
  //     Console.log(
  //       "Cannot create new with a document already in scope",
  //       scope: "fframeLog.listGridController",
  //       level: LogLevel.prod,
  //     );
  //   }
  // }
}

class ListGridActionMenuItemWidget<T> extends StatefulWidget {
  const ListGridActionMenuItemWidget({
    super.key,
    required this.listGridController,
    required this.actionMenuItem,
  });
  final ListGridController listGridController;
  final ListGridActionMenuItem<T> actionMenuItem;

  @override
  State<ListGridActionMenuItemWidget<T>> createState() => _ListGridActionMenuItemWidgetState<T>();
}

class _ListGridActionMenuItemWidgetState<T> extends State<ListGridActionMenuItemWidget<T>> {
  late bool mouseOver = false;
  @override
  Widget build(BuildContext context) {
    ListGridController listGridController = widget.listGridController;
    ListGridActionMenuItem<T> actionMenuItem = widget.actionMenuItem;
    ListGridNotifier<T> listGridNotifier = listGridController.notifier as ListGridNotifier<T>;
    List<SelectedDocument<T>> selectedDocuments = listGridNotifier.selectedDocuments;
    bool isEnabled = actionMenuItem.processSelection ? (listGridNotifier.selectionCount > 0) : true;
    DocumentScreenConfig? documentScreenConfig = DocumentScreenConfig.of(context);
    FFrameUser fFrameUser = documentScreenConfig!.fFrameUser;
    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (event) {
          setState(() {
            mouseOver = true;
          });
        },
        onExit: (event) {
          setState(() {
            mouseOver = false;
          });
        },
        child: TapRegion(
          onTapInside: (event) {
            for (SelectedDocument<T> selectedDocument in selectedDocuments) {
              SelectedDocument<T>? updatedDocument = actionMenuItem.onClick(context, fFrameUser, selectedDocument, documentScreenConfig.documentConfig as DocumentConfig<T>);
              updatedDocument!.update();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  actionMenuItem.icon,
                  color: (isEnabled && mouseOver) ? listGridController.widgetAccentColor : listGridController.widgetColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    actionMenuItem.label,
                    style: TextStyle(
                      color: (isEnabled && mouseOver) ? listGridController.widgetAccentColor : listGridController.widgetColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListGridHeaderSortingWidget<T> extends StatelessWidget {
  const ListGridHeaderSortingWidget({super.key, required this.column, required this.columnIndex, required this.widgetColor, required this.widgetAccentColor});

  final ListGridColumn column;
  final int columnIndex;
  final Color widgetColor;
  final Color widgetAccentColor;

  @override
  Widget build(BuildContext context) {
    ListGridController controller = ListGridController.of(context);
    if (column.sortable) {
      bool isSorted = (columnIndex == controller.sortedColumnIndex);
      return Positioned.fill(
          child: Align(
              alignment: (column.alignment == Alignment.bottomLeft || column.alignment == Alignment.topLeft) ? Alignment.centerRight : Alignment.centerLeft,
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
                          controller.sortColumn(columnIndex: columnIndex, descending: false);
                        },
                        icon: const Icon(Icons.expand_less),
                        iconSize: 12,
                        color: (isSorted && !column.descending) ? widgetAccentColor : widgetColor,
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
                          controller.sortColumn(columnIndex: columnIndex, descending: true);
                        },
                        icon: const Icon(Icons.expand_more),
                        iconSize: 12,
                        color: (isSorted && column.descending) ? widgetAccentColor : widgetColor,
                        style: ButtonStyle(
                          surfaceTintColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.shade500,
                          ),
                          padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
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
    ListGridController listGridController = ListGridController.of(context);
    ListGridNotifier<T> listGridNotifier = listGridController.notifier as ListGridNotifier<T>;
    int collectionCount = listGridController.collectionCount;
    int selectionCount = listGridNotifier.selectionCount;
    return SizedBox(
      height: listGridController.footerHeight,
      width: viewportWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Divider(
          //   height: 1,
          // ),
          Container(
            color: listGridController.widgetBackgroundColor,
            child: Padding(
                padding: listGridController.cellPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const IgnorePointer(),
                    (dataMode == ListGridDataMode.autopager || dataMode == ListGridDataMode.pager)
                        ? ListGridPaginator(
                            collectionCount: collectionCount,
                            widgetTextColor: listGridController.widgetTextColor,
                            widgetTextSize: listGridController.widgetTextSize,
                            widgetBackgroundColor: listGridController.widgetBackgroundColor,
                            widgetColor: listGridController.widgetColor,
                          )
                        : ListGridDefaultFooter(
                            collectionCount: collectionCount,
                            selectionCount: selectionCount,
                            widgetTextColor: listGridController.widgetTextColor,
                            widgetTextSize: listGridController.widgetTextSize,
                          ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class ListGridDefaultFooter<T> extends StatelessWidget {
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
          padding: const EdgeInsets.only(left: 16.0, right: 100.0),
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

class ListGridPaginator<T> extends StatelessWidget {
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
    required this.selectedDocument,
  });

  final SelectedDocument<T> selectedDocument;
  // final String? documentId;
  // final T? document;
  // final QueryDocumentSnapshot<T>? queryDocumentSnapshot;

  @override
  State<ListGridRowSelector<T>> createState() => _ListGridRowSelectorState<T>();
}

class _ListGridRowSelectorState<T> extends State<ListGridRowSelector<T>> {
  @override
  Widget build(BuildContext context) {
    ListGridController listGridController = ListGridController.of(context);
    ListGridNotifier<T> listGridNotifier = listGridController.notifier as ListGridNotifier<T>;
    List<SelectedDocument<T>> selectedDocuments = listGridNotifier.selectedDocuments;
    bool isSelected = selectedDocuments.map((selectedDocument) => selectedDocument.documentId).contains(widget.selectedDocument.documentId);

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: Container(
        decoration: BoxDecoration(
          color: listGridController.cellBackgroundColor,
          border: Border(
            bottom: listGridController.rowBorder > 0
                ? BorderSide(
                    color: listGridController.widgetBackgroundColor,
                    width: listGridController.rowBorder,
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
                      listGridNotifier.unselectRow(unSelectedDocument: widget.selectedDocument);
                    }
                  : () {
                      listGridNotifier.selectRow(selectedDocument: widget.selectedDocument);
                    },
              icon: Icon(
                isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
              ),
              color: listGridController.widgetColor,
            ),
          ),
        ),
      ),
    );
  }
}

class ListGridBuilderCell<T> extends StatefulWidget {
  const ListGridBuilderCell({
    super.key,
    required this.listGridController,
    required this.column,
    required this.cellWidget,
    required this.selectedDocument,
  });

  final ListGridController listGridController;
  final ListGridColumn<T> column;
  final SelectedDocument<T> selectedDocument;
  final Widget cellWidget;

  @override
  State<ListGridBuilderCell<T>> createState() => _ListGridBuilderCellState<T>();
}

class _ListGridBuilderCellState<T> extends State<ListGridBuilderCell<T>> {
  bool cellMouseOver = false;

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

  @override
  Widget build(BuildContext context) {
    ListGridController listGridController = widget.listGridController;

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        child: GestureDetector(
          onTap: () {
            if (widget.column.onTableCellClick != null) {
              widget.column.onTableCellClick?.call(
                context,
                widget.selectedDocument,
              );
            } else {
              if (listGridController.listGridConfig.openDocumentOnClick) {
                widget.selectedDocument.select();
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.listGridController.cellBackgroundColor,
              border: Border(
                bottom: widget.listGridController.rowBorder > 0
                    ? BorderSide(
                        color: widget.listGridController.widgetBackgroundColor,
                        width: widget.listGridController.rowBorder,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: widget.listGridController.cellPadding,
              child: widget.cellWidget,
              // child: const Text("cell"),
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
    required this.listGridController,
    required this.column,
    required this.dynValue,
    required this.selectedDocument,
  });

  final ListGridController listGridController;
  final ListGridColumn<T> column;
  final dynamic dynValue;
  final SelectedDocument<T> selectedDocument;

  @override
  State<ListGridDataCell> createState() => _ListGridDataCellState<T>();
}

class _ListGridDataCellState<T> extends State<ListGridDataCell<T>> {
  bool cellMouseOver = false;
  bool buttonMouseOver = false;
  @override
  Widget build(BuildContext context) {
    ListGridController listGridController = widget.listGridController;
    ListGridColumn<T> column = widget.column;

    // TODO JPM: use typeOf to do stuff like:
    //  - automatic timestamp conversions
    //  - rendering of a toggle icon for booleans
    //  - currency masks?
    //  - enums?
    //  - maps to treeview?
    String stringValue = "${widget.dynValue}";

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
        cursor: MaterialStateMouseCursor.clickable,
        onEnter: cellMouseIn,
        onExit: cellMouseOut,
        child: GestureDetector(
          onTap: () {
            if (widget.column.onTableCellClick != null) {
              widget.column.onTableCellClick!.call(
                context,
                widget.selectedDocument,
              );
            } else {
              if (listGridController.listGridConfig.openDocumentOnClick) {
                widget.selectedDocument.open();
              }
            }
          },
          child: Container(
              decoration: BoxDecoration(
                color: listGridController.cellBackgroundColor,
                border: Border(
                  right: listGridController.cellBorder > 0
                      ? BorderSide(
                          color: listGridController.widgetBackgroundColor,
                          width: listGridController.cellBorder,
                        )
                      : BorderSide.none,
                  bottom: listGridController.rowBorder > 0
                      ? BorderSide(
                          color: listGridController.widgetBackgroundColor,
                          width: listGridController.rowBorder,
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
                            padding: listGridController.cellPadding,
                            child: column.textSelectable
                                ? SelectableText(
                                    stringValue,
                                    style: listGridController.defaultTextStyle,
                                    // overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    stringValue,
                                    style: listGridController.defaultTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            // child: const Text("cell"),
                          ),
                        )
                      : Padding(
                          padding: listGridController.cellPadding,
                          child: column.textSelectable
                              ? SelectableText(
                                  stringValue,
                                  style: listGridController.defaultTextStyle,
                                  // overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  stringValue,
                                  style: listGridController.defaultTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          // child: const Text("cell"),
                        ),
                  (column.cellControlsBuilder != null)
                      ? Row(
                          mainAxisAlignment: (column.alignment == Alignment.bottomLeft || column.alignment == Alignment.topLeft) ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: buttonMouseOver ? 1 : (cellMouseOver ? 0.2 : 0),
                              child: MouseRegion(
                                onEnter: buttonMouseIn,
                                onExit: buttonMouseOut,
                                child: Card(
                                  color: listGridController.widgetBackgroundColor,
                                  child: Row(
                                    children: buttonMouseOver
                                        ? column.cellControlsBuilder!(
                                            context,
                                            Fframe.of(context)!.user,
                                            widget.selectedDocument,
                                            stringValue,
                                          )
                                        : [
                                            column
                                                .cellControlsBuilder!(
                                              context,
                                              Fframe.of(context)!.user,
                                              widget.selectedDocument,
                                              stringValue,
                                            )
                                                .first
                                          ],
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
