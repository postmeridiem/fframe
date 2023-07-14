part of fframe;

class SwimlaneHeaders extends StatelessWidget {
  SwimlaneHeaders({
    super.key,
    required this.swimlanes,
  });

  final SwimlanesController swimlanes;
  final List<SwimlaneHeader> swimlaneHeaders = [];

  @override
  Widget build(BuildContext context) {
    for (SwimlaneSetting swimlane in swimlanes.swimlaneSettings) {
      if (swimlane.hasAccess) {
        swimlaneHeaders.add(
          SwimlaneHeader(
            swimlanes: swimlanes,
            swimlane: swimlane,
          ),
        );
      }
    }
    return SizedBox(
      height: swimlanes.headerHeight,
      child: Container(
          color: swimlanes.swimlaneHeaderColor,
          child: Row(
            children: swimlaneHeaders,
          )
          // child: Row(
          //   children: swimlaneWidgets,
          // ),
          ),
    );
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
    int swimlaneTaskCount =
        swimlanes.database.getSwimlaneTasks(swimlane: swimlane).length;
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
                "$swimlaneTaskCount tasks",
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
              const SizedBox(
                width: 300,
                child: IgnorePointer(),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.swimlanes.swimlaneSeparatorColor,
                    // color: Colors.cyan,
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: widget.swimlanes.swimlaneSeparatorColor,
                      ),
                      top: BorderSide(
                        width: 1,
                        color: widget.swimlanes.swimlaneSeparatorColor,
                      ),
                      right: BorderSide(
                        width: 1,
                        color: widget.swimlanes.swimlaneSeparatorColor,
                      ),
                    ),
                  ),
                  child: ScreenBody<SwimlanesTask>(
                    key: ValueKey("ScreenBody_${documentConfig.collection}"),
                  ),
                ),
              ),
            ],
          )
        : const IgnorePointer();
  }
}

class Swimlanes<SwimlanesTask> extends StatelessWidget {
  Swimlanes({
    super.key,
    required this.swimlanes,
  });

  final SwimlanesController swimlanes;
  final List<Swimlane> swimlanesList = [];

  @override
  Widget build(BuildContext context) {
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
    List<SwimlanesTask> currentTasks =
        swimlanes.database.getSwimlaneTasks(swimlane: swimlane);
    List<Widget> taskCards = [];
    for (SwimlanesTask currentTask in currentTasks) {
      taskCards.add(
        Draggable(
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
                  debugPrint(
                      "dropped ${droppedTask.name} on ${swimlane.header}");
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
                                          Icons.playlist_add,
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
      child: Card(
        color: swimlanes.taskCardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: SizedBox(
          width: swimlanes.config.swimlaneWidth,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
    );
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
            child: Container(
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
