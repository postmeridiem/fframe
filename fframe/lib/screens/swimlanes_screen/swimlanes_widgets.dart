part of fframe;

class SwimlaneHeaders extends StatefulWidget {
  const SwimlaneHeaders({
    super.key,
    required this.swimlanes,
  });

  final SwimlanesController swimlanes;

  @override
  State<SwimlaneHeaders> createState() => _SwimlaneHeadersState();
}

class _SwimlaneHeadersState extends State<SwimlaneHeaders> {
  final List<Widget> swimlaneHeaders = [];
  bool filterMenuOpen = false;
  bool filterMenuHover = false;

  @override
  Widget build(BuildContext context) {
    SwimlanesController swimlanes = widget.swimlanes;
    void headerMouseIn(PointerEvent details) {
      setState(() {
        filterMenuOpen = true;
      });
    }

    void headerMouseOut(PointerEvent details) {
      setState(() {
        filterMenuOpen = false;
      });
    }

    void buttonBarMouseIn(PointerEvent details) {
      setState(() {
        filterMenuOpen = true;
        filterMenuHover = true;
      });
    }

    void buttonBarMouseOut(PointerEvent details) {
      setState(() {
        if (filterMenuOpen) {
          filterMenuOpen = false;
        }
        filterMenuHover = false;
      });
    }

    // check if the swimlane headers have already been processed
    if (swimlaneHeaders.isEmpty) {
      // process all swimlanes into swimlane settings
      for (SwimlaneSetting swimlane in swimlanes.swimlaneSettings) {
        // check role access to the swimlane
        if (swimlane.hasAccess) {
          swimlaneHeaders.add(
            SwimlaneHeader(
              swimlanes: swimlanes,
              swimlane: swimlane,
            ),
          );
        }
      }
    }
    double filterOpacity = 0.2;
    if ((swimlanes.notifier.filter != SwimlanesFilterType.unfiltered) ||
        filterMenuOpen) {
      filterOpacity = 1;
    }
    return SizedBox(
      height: swimlanes.headerHeight,
      child: Stack(
        children: [
          MouseRegion(
            onEnter: headerMouseIn,
            onExit: headerMouseOut,
            child: Container(
              color: swimlanes.swimlaneHeaderColor,
              child: Row(
                children: swimlaneHeaders,
              ),
            ),
          ),
          Positioned(
            child: Opacity(
              opacity: filterOpacity,
              // opacity: 1,
              child: MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                onEnter: buttonBarMouseIn,
                onExit: buttonBarMouseOut,
                child: Card(
                  color: swimlanes.config.taskCardColor,
                  child: Row(
                    children: !filterMenuOpen
                        ? [
                            SwimlaneHeaderFilterButton(
                              swimlanes: swimlanes,
                            )
                          ]
                        : [
                            SwimlaneHeaderFilterButton(
                              swimlanes: swimlanes,
                            ),
                            SwimlanesFilterBar(swimlanes: swimlanes),
                          ],

                    // children: [],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwimlaneHeaderFilterButton extends StatelessWidget {
  const SwimlaneHeaderFilterButton({
    super.key,
    required this.swimlanes,
  });

  final SwimlanesController swimlanes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Center(
        child: Icon(
          Icons.filter_alt_outlined,
          color: swimlanes.notifier.filter == SwimlanesFilterType.unfiltered
              ? swimlanes.taskCardTextColor
              : Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}

class SwimlanesFilterBar extends StatelessWidget {
  const SwimlanesFilterBar({
    super.key,
    required this.swimlanes,
  });

  final SwimlanesController swimlanes;

  @override
  Widget build(BuildContext context) {
    SwimlanesFilterType curFilter = swimlanes.notifier.filter;
    Color inactive = swimlanes.taskCardTextColor;
    Color active = Theme.of(context).colorScheme.onBackground;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      toggleFilter(SwimlanesFilterType.assignedToMe);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      side: BorderSide(
                        width: 2,
                        color: (curFilter == SwimlanesFilterType.assignedToMe)
                            ? active
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Icon(
                        Icons.person_outline,
                        size: 16,
                        color: (curFilter == SwimlanesFilterType.assignedToMe)
                            ? active
                            : inactive,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "assigned to me",
                      style: TextStyle(
                        fontSize: 11,
                        color: swimlanes.taskCardTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       OutlinedButton(
            //         onPressed: () {
            //           toggleFilter(SwimlanesFilterType.followedTasks);
            //         },
            //         style: OutlinedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(28),
            //           ),
            //           side: BorderSide(
            //             width: 2,
            //             color: (curFilter == SwimlanesFilterType.followedTasks)
            //                 ? active
            //                 : Theme.of(context).disabledColor,
            //           ),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.only(top: 4, bottom: 4),
            //           child: Icon(
            //             Icons.visibility_outlined,
            //             size: 16,
            //             color: (curFilter == SwimlanesFilterType.followedTasks)
            //                 ? active
            //                 : inactive,
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 4.0),
            //         child: Text(
            //           "following",
            //           style: TextStyle(
            //             color: swimlanes.taskCardTextColor,
            //             fontSize: 11,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      toggleFilter(SwimlanesFilterType.prioHigh);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      side: BorderSide(
                        width: 2,
                        color: (curFilter == SwimlanesFilterType.prioHigh)
                            ? active
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Icon(
                        Icons.priority_high_outlined,
                        size: 16,
                        color: (curFilter == SwimlanesFilterType.prioHigh)
                            ? active
                            : inactive,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "high (1-3)",
                      style: TextStyle(
                        color: swimlanes.taskCardTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      toggleFilter(SwimlanesFilterType.prioNormal);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      side: BorderSide(
                        width: 2,
                        color: (curFilter == SwimlanesFilterType.prioNormal)
                            ? active
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Icon(
                        Icons.task_outlined,
                        size: 16,
                        color: (curFilter == SwimlanesFilterType.prioNormal)
                            ? active
                            : inactive,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "normal (4-6)",
                      style: TextStyle(
                        color: swimlanes.taskCardTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      toggleFilter(SwimlanesFilterType.prioLow);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      side: BorderSide(
                        width: 2,
                        color: (curFilter == SwimlanesFilterType.prioLow)
                            ? active
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Icon(
                        Icons.low_priority_outlined,
                        size: 16,
                        color: (curFilter == SwimlanesFilterType.prioLow)
                            ? active
                            : inactive,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "low (7-9)",
                      style: TextStyle(
                        color: swimlanes.taskCardTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       OutlinedButton(
            //         onPressed: () {
            //           toggleFilter(SwimlanesFilterType.assignedTo);
            //         },
            //         style: OutlinedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(28),
            //           ),
            //           side: BorderSide(
            //             width: 2,
            //             color: (curFilter == SwimlanesFilterType.assignedTo)
            //                 ? active
            //                 : Theme.of(context).disabledColor,
            //           ),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.only(top: 4, bottom: 4),
            //           child: Icon(
            //             Icons.person_search_outlined,
            //             size: 16,
            //             color: (curFilter == SwimlanesFilterType.assignedTo)
            //                 ? active
            //                 : inactive,
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 4.0),
            //         child: Text(
            //           "assigned to...",
            //           style: TextStyle(
            //             color: swimlanes.taskCardTextColor,
            //             fontSize: 11,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void toggleFilter(SwimlanesFilterType filter) {
    if (swimlanes.filter != filter) {
      swimlanes.notifier.setFilter(filter);
    } else {
      swimlanes.notifier.setFilter(SwimlanesFilterType.unfiltered);
    }
  }
}

class SwimlaneHeader extends StatelessWidget {
  const SwimlaneHeader({
    super.key,
    required this.swimlanes,
    required this.swimlane,
  });

  final SwimlanesController swimlanes;
  final SwimlaneSetting swimlane;

  @override
  Widget build(BuildContext context) {
    // int swimlaneTaskCount =
    //     swimlanes.database.getSwimlaneCount(swimlaneStatus: swimlane.status);
    // int swimlaneTaskCountFiltered =
    //     swimlanes.getSwimlaneCountFiltered(swimlaneStatus: swimlane.status);

    int swimlaneTaskCount = swimlanes.database
        .getSwimlaneTasks(swimlanes: swimlanes, swimlane: swimlane)
        .length;

    String lanecountMessage = "$swimlaneTaskCount tasks";
    // if (swimlaneTaskCount != swimlaneTaskCountFiltered) {
    //   lanecountMessage = "$swimlaneTaskCount tasks";
    // }
    return Container(
      decoration: BoxDecoration(
        // color: Colors.yellowAccent,
        border: Border(
          right: BorderSide(
            width: 2,
            color: swimlanes.swimlaneHeaderSeparatorColor,
          ),
          // bottom: BorderSide(
          //   width: 1,
          //   color: swimlanes.taskCardColor,
          // ),
        ),
      ),
      child: SizedBox(
        width: swimlanes.config.swimlaneWidth,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                swimlane.header,
                style: TextStyle(
                  fontSize: 20,
                  color: swimlanes.swimlaneHeaderTextColor,
                ),
              ),
              Text(
                lanecountMessage,
                style: TextStyle(
                  fontSize: 10,
                  color: swimlanes.swimlaneHeaderTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwimlanesBuilderCell<SwimlanesTask> extends StatefulWidget {
  const SwimlanesBuilderCell({
    super.key,
    required this.swimlanes,
    required this.swimlane,
    required this.queryDocumentSnapshot,
    required this.document,
    required this.cellWidget,
  });

  final SwimlanesController swimlanes;
  final SwimlaneSetting swimlane;
  final QueryDocumentSnapshot<SwimlanesTask> queryDocumentSnapshot;
  final SwimlanesTask document;
  final Widget cellWidget;

  @override
  State<SwimlanesBuilderCell<SwimlanesTask>> createState() =>
      _SwimlanesBuilderCellState<SwimlanesTask>();
}

class _SwimlanesBuilderCellState<SwimlanesTask>
    extends State<SwimlanesBuilderCell<SwimlanesTask>> {
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
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        child: GestureDetector(
          onTap: () {
            documentScreenConfig.selectDocument(
                context, widget.queryDocumentSnapshot);
          },
          child: widget.cellWidget,
        ),
      ),
    );
  }
}

class SwimlanesDocument<SwimlanesTask> extends ConsumerStatefulWidget {
  const SwimlanesDocument({
    super.key,
    required this.documentConfig,
    required this.swimlanes,
    required this.documentOpen,
  });
  final DocumentConfig<SwimlanesTask> documentConfig;
  final SwimlanesController swimlanes;
  final bool documentOpen;

  @override
  ConsumerState<SwimlanesDocument<SwimlanesTask>> createState() =>
      _SwimlanesDocumentState<SwimlanesTask>();
}

class _SwimlanesDocumentState<SwimlanesTask>
    extends ConsumerState<SwimlanesDocument<SwimlanesTask>> {
  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    DocumentConfig<SwimlanesTask> documentConfig =
        documentScreenConfig.documentConfig as DocumentConfig<SwimlanesTask>;
    return widget.documentOpen
        ? Row(
            children: [
              SwimlanesDocumentTaskCard(widget: widget),
              Expanded(
                child: ScreenBody<SwimlanesTask>(
                  key: ValueKey("ScreenBody_${documentConfig.collection}"),
                ),
              ),
            ],
          )
        : const IgnorePointer();
  }
}

class SwimlanesDocumentTaskCard extends StatelessWidget {
  const SwimlanesDocumentTaskCard({
    super.key,
    required this.widget,
  });

  final SwimlanesDocument widget;

  Widget build(BuildContext context) {
    // register shared validator class for common patterns
    Validator validator = Validator();
    bool readOnly = true;

    return Container(
      color: Colors.black,
      child: SizedBox(
        width: widget.swimlanes.config.swimlaneWidth,
        child: const Placeholder(),
        // child: Card(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(bottom: 16.0),
        //           child: TextFormField(
        //             readOnly: readOnly,
        //             decoration: const InputDecoration(
        //               // hoverColor: Color(0xFFFF00C8),
        //               // hoverColor: Theme.of(context).indicatorColor,
        //               border: OutlineInputBorder(),
        //               labelText: "Name",
        //             ),
        //             initialValue: swimlanesTask.name ?? '',
        //             validator: (curValue) {
        //               if (validator.validString(curValue)) {
        //                 swimlanesTask.name = curValue;
        //                 return null;
        //               } else {
        //                 return 'Enter a valid name';
        //               }
        //             },
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(bottom: 16.0),
        //           child: TextFormField(
        //             readOnly: true,
        //             onSaved: (String? value) {
        //               swimlanesTask.status = value ?? "";
        //             },
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: "Status",
        //             ),
        //             initialValue: swimlanesTask.status ?? '',
        //             validator: (value) {
        //               if (!validator.validString(value)) {
        //                 return 'Enter a valid value';
        //               }
        //               return null;
        //             },
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(bottom: 16.0),
        //           child: TextFormField(
        //             minLines: 5,
        //             maxLines: 10,
        //             onSaved: (String? value) {
        //               swimlanesTask.description = value ?? "";
        //             },
        //             readOnly: readOnly,
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: "Description",
        //             ),
        //             initialValue: swimlanesTask.description ?? '',
        //             validator: (value) {
        //               if (!validator.validString(value)) {
        //                 return 'Enter a valid value';
        //               }
        //               return null;
        //             },
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(bottom: 16.0),
        //           child: TextFormField(
        //             readOnly: true,
        //             initialValue: swimlanesTask.createdBy ?? "unknown",
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: "Author",
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class Swimlanes<SwimlanesTask> extends StatelessWidget {
  Swimlanes({
    super.key,
    required this.swimlanes,
  });

  final SwimlanesController swimlanes;
  final List<Widget> swimlanesList = [];

  @override
  Widget build(BuildContext context) {
    // swimlanesList.add(
    //   SwimlanesFilterBar(swimlanes: swimlanes),
    // );
    for (SwimlaneSetting swimlane in swimlanes.swimlaneSettings) {
      if (swimlane.hasAccess) {
        swimlanesList.add(
          Swimlane(
            swimlanes: swimlanes,
            swimlane: swimlane,
          ),
        );
      }
    }
    return Container(
        color: swimlanes.swimlaneBackgroundColor,
        child: Row(
          children: swimlanesList,
        )
        // child: Row(
        //   children: swimlaneWidgets,
        // ),
        );
  }
}

class Swimlane extends StatelessWidget {
  Swimlane({
    super.key,
    required this.swimlanes,
    required this.swimlane,
  });
  final ScrollController _vertical = ScrollController();

  final SwimlanesController swimlanes;
  final SwimlaneSetting swimlane;

  @override
  Widget build(BuildContext context) {
    List<SwimlanesTask> currentTasks = swimlanes.database.getSwimlaneTasks(
      swimlanes: swimlanes,
      swimlane: swimlane,
    );
    List<Widget> taskCards = [];
    for (SwimlanesTask currentTask in currentTasks) {
      taskCards.add(
        LongPressDraggable(
          delay: const Duration(milliseconds: 200),
          data: currentTask,
          dragAnchorStrategy: childDragAnchorStrategy,
          onDragStarted: () {
            swimlanes.notifier.setDraggingMode(true);
          },
          onDragEnd: (details) {
            swimlanes.notifier.setDraggingMode(false);
          },
          childWhenDragging: Opacity(
            opacity: 0.4,
            child: SwimlanesTaskCard(
              swimlanes: swimlanes,
              currentTask: currentTask,
            ),
          ),
          feedback: SwimlanesTaskCard(
            swimlanes: swimlanes,
            currentTask: currentTask,
          ),
          child: SwimlanesTaskCard(
            swimlanes: swimlanes,
            currentTask: currentTask,
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 2,
            color: swimlanes.swimlaneSeparatorColor,
          ),
        ),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: (swimlanes.viewportSize.height -
                (105 + swimlanes.headerHeight)),
            width: swimlanes.config.swimlaneWidth,
            child: Scrollbar(
              controller: _vertical,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _vertical,
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: taskCards,
                  ),
                ),
              ),
            ),
          ),
          swimlanes.isDragging
              ? DragTarget<SwimlanesTask>(
                  onAccept: (SwimlanesTask droppedTask) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: ListTile(
                        leading: const Icon(
                          Icons.move_to_inbox_outlined,
                        ),
                        title: Text(
                            "Moved '${droppedTask.name}' to [${swimlane.header}]"),
                        textColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  );
                }, builder: (context, candidateData, rejectedData) {
                  return Stack(
                    children: [
                      Opacity(
                        opacity: 1,
                        child: Container(
                          color: swimlanes.swimlaneBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: DottedBorder(
                              color: swimlanes.swimlaneSeparatorColor,
                              strokeWidth: 4,
                              radius: const Radius.circular(32),
                              borderType: BorderType.RRect,
                              dashPattern: const [12, 6],
                              child: SizedBox(
                                height: (swimlanes.viewportSize.height -
                                    (156 + swimlanes.headerHeight)),
                                width: swimlanes.config.swimlaneWidth - 53,
                                child: const IgnorePointer(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: (swimlanes.viewportSize.height -
                              (156 + swimlanes.headerHeight)),
                          width: swimlanes.config.swimlaneWidth - 53,
                          child: Center(
                            child: Card(
                              color: swimlanes.taskCardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 180,
                                  height: 110,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Opacity(
                                        opacity: 0.6,
                                        child: Icon(
                                          Icons.move_to_inbox_outlined,
                                          size: 48,
                                          color:
                                              swimlanes.swimlaneSeparatorColor,
                                        ),
                                      ),
                                      const Text("set status to"),
                                      Text(swimlane.header,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                })
              : const IgnorePointer(),
        ],
      ),
    );
  }
}

class SwimlanesTaskCard extends StatefulWidget {
  const SwimlanesTaskCard({
    super.key,
    required this.swimlanes,
    required this.currentTask,
    this.condensed = false,
  });

  final SwimlanesController swimlanes;
  final SwimlanesTask currentTask;
  final bool condensed;

  @override
  State<SwimlanesTaskCard> createState() => _SwimlanesTaskCardState();
}

class _SwimlanesTaskCardState extends State<SwimlanesTaskCard> {
  @override
  Widget build(BuildContext context) {
    SwimlanesTask currentTask = widget.currentTask;
    SwimlanesController swimlanes = widget.swimlanes;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          color: swimlanes.taskCardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: SizedBox(
            width: swimlanes.config.swimlaneWidth - 40,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 8.0,
                      left: 4.0,
                      right: 70.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: SizedBox(
                            width: swimlanes.config.swimlaneWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${currentTask.name ?? ""}-${currentTask.id ?? ""}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: swimlanes.taskCardHeaderTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        widget.condensed
                            ? const IgnorePointer()
                            : Container(
                                color: swimlanes.taskCardColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SwimlanesTaskCardContent(
                                        currentTask: currentTask,
                                        swimlanes: swimlanes),
                                    const SizedBox(
                                      width: 1,
                                      height: 0,
                                      child: IgnorePointer(),
                                    )
                                  ],
                                ),
                              ),
                        Divider(
                          color: swimlanes.taskCardHeaderColor,
                        ),
                        widget.condensed
                            ? const IgnorePointer()
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "comments: 0",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                        Divider(
                          color: swimlanes.taskCardHeaderColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                currentTask.dueTime != null
                                    ? Text(
                                        "due: ${L10n.stringFromTimestamp(
                                          timestamp:
                                              currentTask.dueTime as Timestamp,
                                        )}",
                                        style: const TextStyle(fontSize: 9),
                                      )
                                    : const IgnorePointer(),
                                Text(
                                  "created: ${L10n.stringFromTimestamp(
                                    timestamp:
                                        currentTask.creationDate as Timestamp,
                                  )}",
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${currentTask.priority}",
                              style: TextStyle(
                                color: currentTask.color,
                                fontSize: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 48,
                  child: Opacity(
                    opacity: 0.6,
                    child: SizedBox(
                      width: 60,
                      height: 54,
                      child: AssignedAvatar(
                        assignedTo: currentTask.assignedTo,
                        assignmentTime: L10n.stringFromTimestamp(
                            timestamp:
                                currentTask.assignmentTime ?? Timestamp.now()),
                        swimlanes: swimlanes,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                      width: 72,
                      height: 54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              currentTask.icon,
                              color: currentTask.color,
                              size: 48,
                            ),
                          ],
                        ),
                      ),
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

class AssignedAvatar extends StatefulWidget {
  const AssignedAvatar({
    super.key,
    required this.swimlanes,
    required this.assignedTo,
    required this.assignmentTime,
  });

  final SwimlanesController swimlanes;
  final String? assignedTo;
  final String? assignmentTime;

  @override
  State<AssignedAvatar> createState() => _AssignedAvatarState();
}

class _AssignedAvatarState extends State<AssignedAvatar> {
  @override
  Widget build(BuildContext context) {
    if (widget.assignedTo == null) {
      return const IgnorePointer();
    }

    final Stream<QuerySnapshot> userLookup = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.assignedTo)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: userLookup,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.no_accounts_outlined);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          FFrameUser assignedUser = FFrameUser.fromFirestore(
              snapshot: snapshot.data!.docs.first
                  as DocumentSnapshot<Map<String, dynamic>>);

          Widget avatar = const Icon(
            Icons.account_circle_outlined,
            size: 36,
          );

          if (assignedUser.photoURL != null) {
            try {
              NetworkImage networkImage = NetworkImage(assignedUser.photoURL!);
              avatar = CircleAvatar(
                radius: 18.0,
                backgroundImage:
                    (assignedUser.photoURL == null) ? null : networkImage,
                backgroundColor: (assignedUser.photoURL == null)
                    ? Colors.amber
                    : Colors.transparent,
                child: (assignedUser.photoURL == null)
                    ? Text(
                        "${assignedUser.displayName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              );
            } catch (e) {
              Console.log("profile image could not be fetched",
                  level: LogLevel.dev);
            }
          }
          String tooltipMessage =
              "Assigned to: \t\t\t${assignedUser.displayName ?? ""}\nOn: \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t${widget.assignmentTime}";
          return Tooltip(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.swimlanes.swimlaneBackgroundColor,
            ),
            richMessage: WidgetSpan(
              child: Text(tooltipMessage),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [avatar],
              ),
            ),
          );
        });
  }
}

class SwimlanesTaskCardContent extends StatelessWidget {
  const SwimlanesTaskCardContent({
    super.key,
    required this.swimlanes,
    required this.currentTask,
  });

  final SwimlanesController swimlanes;
  final SwimlanesTask currentTask;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (swimlanes.config.swimlaneWidth - 133),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SwimlanesTaskDescription(
            currentTask: currentTask, swimlanes: swimlanes),
      ),
    );
  }
}

class SwimlanesTaskDescription extends StatelessWidget {
  const SwimlanesTaskDescription({
    super.key,
    required this.currentTask,
    required this.swimlanes,
  });

  final SwimlanesTask currentTask;
  final SwimlanesController swimlanes;

  @override
  Widget build(BuildContext context) {
    int stringLength = 150;
    List<Padding> descriptionParagraphs = [];
    List<Widget> tooltipParagraphs = [];
    String descriptionRaw = currentTask.description ?? "";

    bool overflowNeeded = false;
    int charactersRemaining = stringLength;

    List<String> descriptionSplit = descriptionRaw.split("\\n");

    for (String currentParagraph in descriptionSplit) {
      String widgetParagraph = currentParagraph;
      if (descriptionParagraphs.length < 3 && charactersRemaining > 0) {
        if (currentParagraph.length > charactersRemaining) {
          // current paragraph is longer than the allowed.
          // shorten it and create the widget
          widgetParagraph = currentParagraph.substring(0, charactersRemaining);
        }
        descriptionParagraphs.add(
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
            child: Text(
              widgetParagraph,
              // textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 12,
                color: swimlanes.taskCardTextColor,
              ),
            ),
          ),
        );
        charactersRemaining = (charactersRemaining - widgetParagraph.length);
      } else {
        charactersRemaining = 0;
      }
      tooltipParagraphs.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(currentParagraph,
              style: TextStyle(
                color: swimlanes.taskCardTextColor,
              )),
        ),
      );
    }
    overflowNeeded = (charactersRemaining < 1);

    if (overflowNeeded) {
      descriptionParagraphs.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "...",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 20,
                color: swimlanes.swimlaneSeparatorColor,
              ),
            ),
          ),
        ),
      );
    }

    return overflowNeeded
        ? Tooltip(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: swimlanes.swimlaneBackgroundColor,
              // gradient:
              //     const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
            ),
            preferBelow: true,
            richMessage: WidgetSpan(
              child: SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tooltipParagraphs,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 2, right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: descriptionParagraphs,
                // children: [
                // ],
              ),
            ),
          )
        : Container(
            // color: Colors.grey.shade700,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 2, right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: descriptionParagraphs,
                // children: [
                // ],
              ),
            ),
          );
  }
}
