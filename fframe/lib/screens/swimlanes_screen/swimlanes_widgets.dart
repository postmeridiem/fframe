part of 'package:fframe/fframe.dart';

class SwimlaneHeaders<T> extends StatefulWidget {
  const SwimlaneHeaders({
    super.key,
    required this.swimlanesController,
    required this.documentConfig,
    required this.swimlanesConfig,
  });

  final DocumentConfig<T> documentConfig;
  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;

  @override
  State<SwimlaneHeaders<T>> createState() => _SwimlaneHeadersState<T>();
}

class _SwimlaneHeadersState<T> extends State<SwimlaneHeaders<T>> {
  bool filterMenuOpen = false;
  bool filterMenuHover = false;

  @override
  Widget build(BuildContext context) {
    SwimlanesController swimlanesController = widget.swimlanesController;
    // SwimlanesConfig<T> swimlanesConfig = widget.swimlanesController.swimlanesConfig as SwimlanesConfig<T>;
    List<SwimlaneSetting<T>> swimlaneSettings = widget.swimlanesController.swimlaneSettings as List<SwimlaneSetting<T>>;

    double filterOpacity = 0.2;
    if ((swimlanesController.notifier.filter != SwimlanesFilterType.unfiltered) || filterMenuOpen) {
      filterOpacity = 1;
    }

    return SizedBox(
      height: swimlanesController.headerHeight,
      child: Stack(
        children: [
          MouseRegion(
            onEnter: (PointerEvent details) {
              setState(() {
                filterMenuOpen = true;
              });
            },
            onExit: (PointerEvent details) {
              setState(() {
                filterMenuOpen = false;
              });
            },
            child: Container(
              color: swimlanesController.swimlaneHeaderColor,
              child: Row(
                children: swimlaneSettings
                    .map((SwimlaneSetting<T> swimlaneSetting) => SwimlaneHeader<T>(
                          swimlanesController: swimlanesController,
                          swimlanesConfig: widget.swimlanesConfig,
                          swimlaneSetting: swimlaneSetting,
                        ))
                    .toList(),
              ),
            ),
          ),
          widget.swimlanesConfig.myId == null
              ? const IgnorePointer()
              : Positioned(
                  child: Opacity(
                    opacity: filterOpacity,
                    // opacity: 1,
                    child: MouseRegion(
                      cursor: WidgetStateMouseCursor.clickable,
                      onEnter: (PointerEvent details) {
                        setState(() {
                          filterMenuOpen = true;
                          filterMenuHover = true;
                        });
                      },
                      onExit: (PointerEvent details) {
                        setState(() {
                          if (filterMenuOpen) {
                            filterMenuOpen = false;
                          }
                          filterMenuHover = false;
                        });
                      },
                      child: Card(
                        color: widget.swimlanesConfig.taskCardColor,
                        child: Row(
                          children: [
                            SwimlaneHeaderFilterButton(
                              swimlanesController: swimlanesController,
                            ),
                            filterMenuOpen
                                ? SwimlanesFilterBar(
                                    swimlanesController: swimlanesController,
                                    swimlanesConfig: widget.swimlanesConfig,
                                  )
                                : const IgnorePointer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          if (widget.swimlanesConfig.myId == null && widget.swimlanesConfig.customFilter?.customFilterWidget != null) widget.swimlanesConfig.customFilter!.customFilterWidget!(swimlanesController),
        ],
      ),
    );
  }
}

class SwimlaneHeaderFilterButton extends StatelessWidget {
  const SwimlaneHeaderFilterButton({
    super.key,
    required this.swimlanesController,
  });

  final SwimlanesController swimlanesController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          color: swimlanesController.notifier.filter == SwimlanesFilterType.unfiltered ? swimlanesController.taskCardTextColor : Theme.of(context).indicatorColor,
          onPressed: () {},
        ),
      ),
    );
  }
}

class SwimlanesFilterBar<T> extends StatelessWidget {
  const SwimlanesFilterBar({
    super.key,
    required this.swimlanesController,
    required this.swimlanesConfig,
  });

  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;

  @override
  Widget build(BuildContext context) {
    final Color inactive = swimlanesController.taskCardTextColor;
    final Color active = Theme.of(context).indicatorColor;

    return ListenableBuilder(
      listenable: swimlanesController.notifier,
      builder: (BuildContext context, Widget? child) {
        SwimlanesFilterType currentFilter = swimlanesController.notifier.filter;
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                swimlanesConfig.assignee != null
                    ? Padding(
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
                                  color: (currentFilter == SwimlanesFilterType.assignedToMe) ? active : Theme.of(context).disabledColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: (currentFilter == SwimlanesFilterType.assignedToMe) ? active : inactive,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "assigned to me",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: swimlanesController.taskCardTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const IgnorePointer(),
                swimlanesConfig.following != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                toggleFilter(SwimlanesFilterType.followedTasks);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                side: BorderSide(
                                  width: 2,
                                  color: (currentFilter == SwimlanesFilterType.followedTasks) ? active : Theme.of(context).disabledColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Icon(
                                  Icons.visibility_outlined,
                                  size: 16,
                                  color: (currentFilter == SwimlanesFilterType.followedTasks) ? active : inactive,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "following",
                                style: TextStyle(
                                  color: swimlanesController.taskCardTextColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const IgnorePointer(),
                swimlanesConfig.getPriority != null
                    ? Padding(
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
                                  color: (currentFilter == SwimlanesFilterType.prioHigh) ? active : Theme.of(context).disabledColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Icon(
                                  Icons.priority_high_outlined,
                                  size: 16,
                                  color: (currentFilter == SwimlanesFilterType.prioHigh) ? active : inactive,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "high (1-3)",
                                style: TextStyle(
                                  color: swimlanesController.taskCardTextColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const IgnorePointer(),
                swimlanesConfig.getPriority != null
                    ? Padding(
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
                                  color: (currentFilter == SwimlanesFilterType.prioNormal) ? active : Theme.of(context).disabledColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Icon(
                                  Icons.task_outlined,
                                  size: 16,
                                  color: (currentFilter == SwimlanesFilterType.prioNormal) ? active : inactive,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "normal (4-6)",
                                style: TextStyle(
                                  color: swimlanesController.taskCardTextColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const IgnorePointer(),
                swimlanesConfig.getPriority != null
                    ? Padding(
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
                                  color: (currentFilter == SwimlanesFilterType.prioLow) ? active : Theme.of(context).disabledColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Icon(
                                  Icons.low_priority_outlined,
                                  size: 16,
                                  color: (currentFilter == SwimlanesFilterType.prioLow) ? active : inactive,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "low (7-9)",
                                style: TextStyle(
                                  color: swimlanesController.taskCardTextColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const IgnorePointer(),
                swimlanesConfig.customFilter != null && swimlanesConfig.customFilter!.customFilterWidget == null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                toggleFilter(SwimlanesFilterType.customFilter);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                side: BorderSide(
                                  width: 2,
                                  color: (currentFilter == SwimlanesFilterType.customFilter) ? active : Theme.of(context).disabledColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Icon(
                                  Icons.filter_list,
                                  size: 16,
                                  color: (currentFilter == SwimlanesFilterType.customFilter) ? active : inactive,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                swimlanesConfig.customFilter!.filterName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: swimlanesController.taskCardTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const IgnorePointer(),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleFilter(SwimlanesFilterType filter) {
    if (swimlanesController.filter != filter) {
      swimlanesController.notifier.setFilter(filter);
    } else {
      swimlanesController.notifier.setFilter(SwimlanesFilterType.unfiltered);
    }
  }
}

class SwimlaneHeader<T> extends StatelessWidget {
  const SwimlaneHeader({
    super.key,
    required this.swimlanesController,
    required this.swimlanesConfig,
    required this.swimlaneSetting,
  });

  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;
  final SwimlaneSetting<T> swimlaneSetting;

  @override
  Widget build(BuildContext context) {
    // int swimlaneTaskCount =
    //     swimlanesController.database.getSwimlaneCount(swimlaneStatus: swimlaneSetting.status);
    // int swimlaneTaskCountFiltered =
    //     swimlanesController.getSwimlaneCountFiltered(swimlaneStatus: swimlaneSetting.status);
    // SwimlaneTaskDatabase<T> swimlaneTaskDatabase = swimlanesController.database as SwimlaneTaskDatabase<T>;

    // int swimlaneTaskCount = swimlaneTaskDatabase
    //     .getSwimlaneTasks(
    //       swimlaneSetting: swimlaneSetting,
    //       swimlanesConfig: swimlanesConfig,
    //       swimlanesController: swimlanesController,
    //     )
    //     .length;

    // String lanecountMessage = "$swimlaneTaskCount tasks";
    // if (swimlaneTaskCount != swimlaneTaskCountFiltered) {
    //   lanecountMessage = "$swimlaneTaskCount tasks";
    // }
    return Container(
      decoration: BoxDecoration(
        // color: Colors.yellowAccent,
        border: Border(
          right: BorderSide(
            width: 2,
            color: swimlanesController.swimlaneHeaderSeparatorColor,
          ),
          // bottom: BorderSide(
          //   width: 1,
          //   color: swimlanesController.taskCardColor,
          // ),
        ),
      ),
      child: SizedBox(
        width: swimlanesController.swimlanesConfig.swimlaneWidth,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                swimlaneSetting.header,
                style: TextStyle(
                  fontSize: 20,
                  color: swimlanesController.swimlaneHeaderTextColor,
                ),
              ),
              // Text(
              //   "countMessage",
              //   style: TextStyle(
              //     fontSize: 10,
              //     color: swimlanesController.swimlaneHeaderTextColor,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwimlanesBuilderCell<T> extends StatefulWidget {
  const SwimlanesBuilderCell({
    super.key,
    required this.swimlanesController,
    required this.swimlaneSetting,
    required this.selectedDocument,
    required this.documentConfig,
    required this.cellWidget,
  });

  final SwimlanesController swimlanesController;
  final SwimlaneSetting swimlaneSetting;
  final SelectedDocument<T> selectedDocument;
  final DocumentConfig<T> documentConfig;
  final Widget cellWidget;

  @override
  State<SwimlanesBuilderCell<T>> createState() => _SwimlanesBuilderCellState<T>();
}

class _SwimlanesBuilderCellState<T> extends State<SwimlanesBuilderCell<T>> {
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
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: widget.documentConfig.swimlanes?.openDocumentOnClick == true
          ? MouseRegion(
              cursor: WidgetStateMouseCursor.clickable,
              child: GestureDetector(
                onTap: () {
                  widget.selectedDocument.open();
                },
                child: widget.cellWidget,
              ),
            )
          : widget.cellWidget,
    );
  }
}

class Swimlanes<T> extends StatelessWidget {
  Swimlanes({
    super.key,
    required this.swimlanesController,
    required this.documentConfig,
    required this.swimlanesConfig,
  });

  final DocumentConfig<T> documentConfig;
  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;
  final List<Widget> swimlanesList = [];

  @override
  Widget build(BuildContext context) {
    final List<SwimlaneSetting<T>> swimlaneSettings = swimlanesController.swimlaneSettings as List<SwimlaneSetting<T>>;
    final FFrameUser fFrameUser = Fframe.of(context)!.user!;
    return Expanded(
      child: Container(
        color: swimlanesController.swimlaneBackgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: swimlaneSettings
              .map((swimlaneSetting) => Swimlane<T>(
                    swimlanesController: swimlanesController,
                    swimlanesConfig: swimlanesConfig,
                    swimlaneSetting: swimlaneSetting,
                    documentConfig: documentConfig,
                    fFrameUser: fFrameUser,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class Swimlane<T> extends StatefulWidget {
  const Swimlane({
    super.key,
    required this.swimlanesController,
    required this.swimlaneSetting,
    required this.documentConfig,
    required this.swimlanesConfig,
    required this.fFrameUser,
  });

  final SwimlanesController swimlanesController;
  final DocumentConfig<T> documentConfig;
  final SwimlanesConfig<T> swimlanesConfig;
  final SwimlaneSetting<T> swimlaneSetting;
  final FFrameUser fFrameUser;

  @override
  State<Swimlane<T>> createState() => _SwimlaneState<T>();
}

class _SwimlaneState<T> extends State<Swimlane<T>> {
  double dropTargetHeight = 200.0;

  double _getTaskCardHeight(GlobalKey dragKey) {
    if (dragKey.currentContext != null) {
      final RenderBox renderBox = dragKey.currentContext!.findRenderObject() as RenderBox;
      dropTargetHeight = renderBox.size.height;
    }

    return 10.0;
  }

  final int _documentsPerPage = 20;

  @override
  Widget build(BuildContext context) {
    final SwimlanesConfig<T> swimlanesConfig = widget.swimlanesController.swimlanesConfig as SwimlanesConfig<T>;

    // Fetch the initial query
    Query<T> baseQuery = DatabaseService<T>().query(
      collection: widget.documentConfig.collection,
      fromFirestore: widget.documentConfig.fromFirestore,
      queryBuilder: widget.documentConfig.query,
    );

    // Append the lane query
    if (widget.swimlaneSetting.query != null) {
      baseQuery = widget.swimlaneSetting.query!(baseQuery)!;
    }

    baseQuery = baseQuery.orderBy("priority");

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        width: swimlanesConfig.swimlaneWidth,
        child: FirestoreQueryBuilder<T>(
          query: baseQuery,
          pageSize: _documentsPerPage,
          builder: (BuildContext context, FirestoreQueryBuilderSnapshot<T> snapshot, _) {
            if (snapshot.isFetching) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              // Something has gone wrong
              return Fframe.of(context)!.showErrorPage(context: context, errorText: snapshot.error.toString());
            }

            if (snapshot.hasData) {
              List<SelectedDocument<T>> unfilteredDocuments = snapshot.docs
                  .map(
                    (QueryDocumentSnapshot<T> queryDocument) => FirestoreDocument<T>(
                      data: queryDocument.data(),
                      documentReference: queryDocument.reference,
                      fromFirestore: widget.documentConfig.fromFirestore,
                      toFirestore: widget.documentConfig.toFirestore,
                    ),
                  )
                  .map((FirestoreDocument<T> firestoreDocument) => SelectedDocument(
                        documentConfig: widget.documentConfig,
                        id: firestoreDocument.documentReference.id,
                        data: firestoreDocument.data,
                      ))
                  .toList();

              return ListenableBuilder(
                listenable: widget.swimlanesController.notifier,
                builder: (BuildContext context, Widget? child) {
                  SwimlanesFilterType filterType = widget.swimlanesController.notifier.filter;

                  List<SelectedDocument<T>> selectedDocuments = [...unfilteredDocuments];
                  Console.log("Swimlane rebuild ${filterType.toString()} for ${selectedDocuments.length} ");

                  switch (filterType) {
                    case SwimlanesFilterType.unfiltered:
                      break;
                    case SwimlanesFilterType.assignedToMe:
                      selectedDocuments.removeWhere((selectedDocument) => !swimlanesConfig.assignee!.isAssignee(selectedDocument.data, widget.fFrameUser));
                      break;
                    case SwimlanesFilterType.followedTasks:
                      selectedDocuments.removeWhere((selectedDocument) => !swimlanesConfig.following!.isFollowing(selectedDocument.data, widget.fFrameUser));
                      break;
                    case SwimlanesFilterType.prioHigh:
                      selectedDocuments.removeWhere((selectedDocument) => swimlanesConfig.getPriority!(selectedDocument.data) < 4);
                      break;
                    case SwimlanesFilterType.prioNormal:
                      selectedDocuments.removeWhere((selectedDocument) => swimlanesConfig.getPriority!(selectedDocument.data) >= 4 && swimlanesConfig.getPriority!(selectedDocument.data) < 7);
                      break;
                    case SwimlanesFilterType.prioLow:
                      selectedDocuments.removeWhere((selectedDocument) => swimlanesConfig.getPriority!(selectedDocument.data) >= 7);
                      break;
                    case SwimlanesFilterType.customFilter:
                      selectedDocuments.removeWhere((selectedDocument) => !swimlanesConfig.customFilter!.matchesCustomFilter(selectedDocument.data));
                    default:
                      break;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 2,
                          color: widget.swimlanesController.swimlaneSeparatorColor,
                        ),
                      ),
                    ),
                    child: (selectedDocuments.isEmpty && !swimlanesConfig.isReadOnly)
                        ? SwimlaneDropZone(
                            swimlanesController: widget.swimlanesController,
                            swimlanesConfig: swimlanesConfig,
                            fFrameUser: widget.fFrameUser,
                            width: swimlanesConfig.swimlaneWidth,
                            swimlaneSetting: widget.swimlaneSetting,
                            priority: 1.0,
                            lanePosition: lanePositionIncrement,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: swimlanesConfig.isReadOnly ? selectedDocuments.length : selectedDocuments.length * 2, // Double the count for drop zones and add 1 for the final drop zone
                            itemBuilder: (context, index) {
                              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                                // Tell FirestoreQueryBuilder to try to obtain more items.
                                // It is safe to call this function from within the build method.
                                snapshot.fetchMore();
                              }

                              // Return only task cards if the swimlanes are read-only
                              if (swimlanesConfig.isReadOnly) {
                                return Column(
                                  children: [
                                    Builder(builder: (context) {
                                      return SwimlanesTaskCard<T>(
                                        selectedDocument: selectedDocuments[index],
                                        swimlanesController: widget.swimlanesController,
                                        swimlanesConfig: swimlanesConfig,
                                        color: widget.swimlanesController.taskCardColor,
                                        fFrameUser: widget.fFrameUser,
                                        width: swimlanesConfig.swimlaneWidth,
                                      );
                                    }),
                                    if (index + 1 == snapshot.docs.length && snapshot.isFetchingMore)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                  ],
                                );
                              }

                              // Calculate index in the original documents list
                              int docIndex = index ~/ 2;
                              final selectedDocument = selectedDocuments[docIndex];

                              // int? nextPriority = isNextPriority(selectedDocuments, docIndex);

                              GlobalKey dragKey = GlobalKey();
                              if (index.isEven) {
                                final DragContext<T> dragContext = DragContext<T>(
                                  sourceColumn: widget.swimlaneSetting,
                                  selectedDocument: selectedDocument,
                                  dragKey: dragKey,
                                  buildContext: context,
                                );

                                double? topDropZoneLanePosition;
                                if (index == 0) {
                                  if (swimlanesConfig.getLanePosition != null) {
                                    // Calculate lane position for the 1st drop zone
                                    double firstDocPos = swimlanesConfig.getLanePosition!(selectedDocument.data);
                                    topDropZoneLanePosition = firstDocPos / 2.0;
                                  } else {
                                    // Fallback to a default starting value if getLanePosition is null
                                    topDropZoneLanePosition = lanePositionIncrement / 2.0;
                                  }
                                }

                                return Column(
                                  children: [
                                    if (index == 0)
                                      // Insert drop zone for the top of the lane
                                      SwimlaneDropZone(
                                        swimlanesController: widget.swimlanesController,
                                        swimlanesConfig: swimlanesConfig,
                                        fFrameUser: widget.fFrameUser,
                                        height: dropTargetHeight,
                                        width: swimlanesConfig.swimlaneWidth,
                                        swimlaneSetting: widget.swimlaneSetting,
                                        priority: 1.0,
                                        lanePosition: topDropZoneLanePosition,
                                      ),
                                    // if (nextPriority != null)
                                    //   Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Stack(
                                    //       alignment: AlignmentDirectional.centerStart,
                                    //       children: [
                                    //         const Divider(),
                                    //         CircleAvatar(child: Text(nextPriority.toString())),
                                    //       ],
                                    //     ),
                                    //   ),
                                    GestureDetector(
                                      onTapDown: (_) => _getTaskCardHeight(dragContext.dragKey),
                                      child: Draggable<DragContext<T>>(
                                        data: dragContext,
                                        feedback: SwimlanesTaskCard<T>(
                                          selectedDocument: selectedDocument,
                                          swimlanesController: widget.swimlanesController,
                                          swimlanesConfig: swimlanesConfig,
                                          fFrameUser: widget.fFrameUser,
                                          color: widget.swimlanesController.taskCardColor,
                                          width: swimlanesConfig.swimlaneWidth,
                                          feedback: true,
                                        ),
                                        childWhenDragging: SwimlanesTaskCard<T>(
                                          selectedDocument: selectedDocument,
                                          swimlanesController: widget.swimlanesController,
                                          swimlanesConfig: swimlanesConfig,
                                          fFrameUser: widget.fFrameUser,
                                          color: widget.swimlanesController.taskCardColor,
                                          width: swimlanesConfig.swimlaneWidth,
                                          childWhenDragging: true,
                                        ),
                                        child: Builder(builder: (context) {
                                          return SwimlanesTaskCard<T>(
                                            key: dragContext.dragKey,
                                            selectedDocument: selectedDocument,
                                            swimlanesController: widget.swimlanesController,
                                            swimlanesConfig: swimlanesConfig,
                                            color: widget.swimlanesController.taskCardColor,
                                            fFrameUser: widget.fFrameUser,
                                            width: swimlanesConfig.swimlaneWidth,
                                          );
                                        }),
                                      ),
                                    ),
                                    if (index + 1 == snapshot.docs.length && snapshot.isFetchingMore)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                  ],
                                );
                              } else {
                                T docAbove = selectedDocuments[docIndex].data; // Doc before the drop zone

                                // Calculate lane position for drop zone (the primary ordering within lanes)
                                double? dropZoneLanePosition;
                                if (swimlanesConfig.getLanePosition != null) {
                                  if (docIndex < selectedDocuments.length - 1) {
                                    // Drop zone is between 2 docs
                                    T docBelow = selectedDocuments[docIndex + 1].data;
                                    double posAbove = swimlanesConfig.getLanePosition!(docAbove);
                                    double posBelow = swimlanesConfig.getLanePosition!(docBelow);
                                    dropZoneLanePosition = (posAbove + posBelow) / 2.0;
                                  } else {
                                    // Drop zone is after the last doc in the list
                                    double posLast = swimlanesConfig.getLanePosition!(docAbove);
                                    dropZoneLanePosition = posLast + lanePositionIncrement; // Lane position for the last item
                                  }
                                }
                                // Calculate priority for drop zone
                                double? dropZonePriority;
                                if (swimlanesConfig.getPriority != null) {
                                  if (docIndex < selectedDocuments.length - 1) {
                                    // Drop zone is between 2 docs
                                    dropZonePriority = calculateDropTargetPriority(selectedDocuments, docIndex);
                                  } else {
                                    // Drop zone is after the last doc in the list
                                    double lastPriority = swimlanesConfig.getPriority!(docAbove);
                                    dropZonePriority = lastPriority + (1 - (lastPriority % 1)) / 2; // For the last item
                                  }
                                }
                                // Add a drop zone between items
                                return Column(
                                  children: [
                                    // if (nextPriority != null)
                                    //   Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Stack(
                                    //       alignment: AlignmentDirectional.centerStart,
                                    //       children: [
                                    //         const Divider(),
                                    //         CircleAvatar(child: Text(nextPriority.toString())),
                                    //       ],
                                    //     ),
                                    //   ),
                                    SwimlaneDropZone(
                                      swimlanesController: widget.swimlanesController,
                                      swimlanesConfig: swimlanesConfig,
                                      fFrameUser: widget.fFrameUser,
                                      height: dropTargetHeight,
                                      width: swimlanesConfig.swimlaneWidth,
                                      swimlaneSetting: widget.swimlaneSetting,
                                      priority: dropZonePriority,
                                      lanePosition: dropZoneLanePosition,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    });
  }

  double? calculateDropTargetPriority(List<SelectedDocument<T>> items, int index) {
    if (widget.swimlanesConfig.getPriority == null) return null;

    // Handle case when it's the last item in the list
    if (index == items.length - 1) {
      return widget.swimlanesConfig.getPriority!(items[index].data) + (1 - (widget.swimlanesConfig.getPriority!(items[index].data) % 1)) / 2;
    }

    double currentPriority = widget.swimlanesConfig.getPriority!(items[index].data);
    double nextPriority = widget.swimlanesConfig.getPriority!(items[index + 1].data);
    int decimals = max(currentPriority.toString().split('.').first.length, nextPriority.toString().split('.').first.length) + 1;

    // Check if it's the last item of the integer part
    if (currentPriority.floor() != nextPriority.floor()) {
      return (currentPriority.floor() + 1 + currentPriority) / 2;
    }

    // Regular case: calculate mid-value between current and next item
    return double.parse(((currentPriority + nextPriority) / 2).toStringAsFixed(decimals));
  }

  int? isNextPriority(List<SelectedDocument<T>> items, int index) {
    if (widget.swimlanesConfig.getPriority == null) return null;

    int currentPriority = widget.swimlanesConfig.getPriority!(items[index].data).toInt();
    if (index == 0) {
      return currentPriority;
    }

    // Handle case when it's the last item in the list
    if (index == items.length - 1) {
      return currentPriority + 1;
    }

    int nextPriority = widget.swimlanesConfig.getPriority!(items[index + 1].data).toInt();

    // Check if it's the last item of the integer part
    if (currentPriority != nextPriority) {
      return nextPriority;
    }

    // Regular case: calculate mid-value between current and next item
    return null;
  }
}

class SwimlaneDropZone<T> extends StatefulWidget {
  const SwimlaneDropZone({
    super.key,
    required this.swimlanesController,
    required this.swimlanesConfig,
    required this.fFrameUser,
    required this.width,
    this.height = 48.0,
    required this.swimlaneSetting,
    this.priority,
    this.lanePosition,
  });
  final SwimlaneSetting<T> swimlaneSetting;
  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;
  final double? priority;
  final double? lanePosition;
  final FFrameUser fFrameUser;
  final double width;
  final double height;
  @override
  State<SwimlaneDropZone<T>> createState() => _SwimlaneDropZoneState<T>();
}

class _SwimlaneDropZoneState<T> extends State<SwimlaneDropZone<T>> {
  DragContext<T>? _dragContext;
  @override
  Widget build(BuildContext context) {
    return DragTarget<DragContext<T>>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        if (accepted.isNotEmpty) {
          _dragContext = accepted.first;
        }

        return Container(
          height: (accepted.isNotEmpty)
              ? widget.height
              : (rejected.isNotEmpty)
                  ? widget.height
                  : 8.0,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: (accepted.isNotEmpty || rejected.isNotEmpty)
              ? Center(
                  child: SwimlanesTaskCard<T>(
                    selectedDocument: _dragContext!.selectedDocument,
                    swimlanesController: widget.swimlanesController,
                    swimlanesConfig: widget.swimlanesConfig,
                    color: (accepted.isNotEmpty)
                        ? Colors.green.shade800
                        : (rejected.isNotEmpty)
                            ? Colors.red.shade800
                            : widget.swimlanesController.taskCardColor,
                    fFrameUser: widget.fFrameUser,
                    width: widget.width,
                    // feedback: true,
                  ),
                )
              : null,
        );
      },
      onAcceptWithDetails: ((dragContext) {
        setState(() {
          _dragContext = null;
        });
        T data = dragContext.data.selectedDocument.data;

        if (widget.swimlaneSetting.id == dragContext.data.sourceColumn.id && widget.swimlaneSetting.onLanePositionChange != null) {
          // Card dropped in the SAME lane (reorder) and lane position is the primary ordering strategy
          data = widget.swimlaneSetting.onLanePositionChange!(data, widget.lanePosition);
        } else if (widget.swimlaneSetting.id == dragContext.data.sourceColumn.id && widget.swimlaneSetting.onPriorityChange != null) {
          // Card dropped in the SAME lane (reorder) and priority is the primary ordering strategy
          data = widget.swimlaneSetting.onPriorityChange!(data, widget.priority);
        } else if (widget.swimlaneSetting.onLaneDrop != null) {
          // Card dropped in a DIFFERENT lane
          if (widget.swimlanesConfig.getLanePosition != null) {
            // Lane position is passed if that's the primary ordering strategy
            data = widget.swimlaneSetting.onLaneDrop!(data, widget.lanePosition);
          } else {
            // Priority is passed if that's the primary ordering strategy
            data = widget.swimlaneSetting.onLaneDrop!(data, widget.priority);
          }
        } else {
          Console.log("onLaneDrop is not implemented for this lane", level: LogLevel.dev);
        }
        dragContext.data.selectedDocument.update(data: data);
      }),
      onLeave: ((DragContext<T>? dragContext) {
        setState(() {
          _dragContext = null;
        });
      }),
      onWillAcceptWithDetails: ((DragTargetDetails<DragContext<T>>? dragContext) {
        //Track the state
        setState(() {
          _dragContext = dragContext!.data;
        });

        if (widget.swimlaneSetting.id == dragContext!.data.sourceColumn.id && widget.swimlanesConfig.getLanePosition != null && widget.swimlaneSetting.canChangePriority != null) {
          return widget.swimlaneSetting.canChangePriority!(
            dragContext.data.selectedDocument,
            widget.fFrameUser.roles,
            dragContext.data.sourceColumn.id,
            widget.swimlanesConfig.getLanePosition!(dragContext.data.selectedDocument.data).floor(),
            widget.lanePosition!.floor(),
          );
        } else if (widget.swimlaneSetting.id == dragContext.data.sourceColumn.id && widget.swimlanesConfig.getPriority != null && widget.swimlaneSetting.canChangePriority != null) {
          return widget.swimlaneSetting.canChangePriority!(
            dragContext.data.selectedDocument,
            widget.fFrameUser.roles,
            dragContext.data.sourceColumn.id,
            widget.swimlanesConfig.getPriority!(dragContext.data.selectedDocument.data).floor(),
            widget.priority!.floor(),
          );
        } else if (widget.swimlaneSetting.canChangeSwimLane != null) {
          return widget.swimlaneSetting.canChangeSwimLane!(
            dragContext.data.selectedDocument,
            widget.fFrameUser.roles,
            dragContext.data.sourceColumn.id,
            (widget.swimlanesConfig.getPriority != null) ? widget.swimlanesConfig.getPriority!(dragContext.data.selectedDocument.data).floor() : null,
            (widget.swimlanesConfig.getPriority != null) ? widget.priority?.floor() : null,
          );
        } else {
          return false;
        }
      }),
    ); // Insert a drop zone after each
  }
}

class SwimlanesTaskCard<T> extends StatefulWidget {
  const SwimlanesTaskCard({
    super.key,
    required this.swimlanesController,
    required this.swimlanesConfig,
    required this.selectedDocument,
    required this.fFrameUser,
    required this.width,
    required this.color,
    this.feedback = false,
    this.childWhenDragging = false,
  });

  final SwimlanesController swimlanesController;
  final SwimlanesConfig<T> swimlanesConfig;
  final SelectedDocument<T> selectedDocument;
  final FFrameUser fFrameUser;
  final bool feedback;
  final bool childWhenDragging;
  final double width;
  final Color color;

  @override
  State<SwimlanesTaskCard<T>> createState() => _SwimlanesTaskCardState<T>();
}

class _SwimlanesTaskCardState<T> extends State<SwimlanesTaskCard<T>> {
  @override
  Widget build(BuildContext context) {
    SelectedDocument<T> selectedDocument = widget.selectedDocument;
    SwimlanesConfig<T> swimlanesConfig = widget.swimlanesConfig;

    return Transform.scale(
      scale: widget.feedback ? 0.3 : 1.0,
      child: Opacity(
        opacity: widget.childWhenDragging
            ? 0.2
            : widget.feedback
                ? .6
                : 1,
        child: SizedBox(
          width: widget.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: GestureDetector(
              onTap: () {
                if (swimlanesConfig.openDocumentOnClick) {
                  selectedDocument.open();
                }
              },
              child: Card(
                color: widget.color,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: swimlanesConfig.taskWidgetHeader(
                              selectedDocument,
                              swimlanesConfig,
                              widget.fFrameUser,
                            ),
                          ),
                          if (swimlanesConfig.assignee != null)
                            IconButton(
                              icon: Tooltip(
                                message: "Assign",
                                child: Icon(
                                  Icons.person,
                                  color: (swimlanesConfig.assignee!.isAssignee(selectedDocument.data, widget.fFrameUser) == true) ? Colors.greenAccent : null,
                                ),
                              ),
                              onPressed: () {
                                if ((swimlanesConfig.assignee!.isAssignee(selectedDocument.data, widget.fFrameUser) == true)) {
                                  swimlanesConfig.assignee!.unsetAssignee(selectedDocument.data);
                                } else {
                                  swimlanesConfig.assignee!.setAssignee(selectedDocument.data, widget.fFrameUser);
                                }

                                selectedDocument.update();
                              },
                            ),
                          if (swimlanesConfig.following != null)
                            Tooltip(
                              message: "Watch",
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: (swimlanesConfig.following!.isFollowing(selectedDocument.data, widget.fFrameUser) == true) ? Colors.greenAccent : null,
                                ),
                                onPressed: () {
                                  if (swimlanesConfig.following!.isFollowing(selectedDocument.data, widget.fFrameUser) == true) {
                                    swimlanesConfig.following!.stopFollowing(selectedDocument.data, widget.fFrameUser);
                                  } else {
                                    swimlanesConfig.following!.startFollowing(selectedDocument.data, widget.fFrameUser);
                                  }
                                  selectedDocument.update();
                                },
                              ),
                            ),
                        ],
                      ),
                      swimlanesConfig.taskWidgetBody(
                        selectedDocument,
                        swimlanesConfig,
                        widget.fFrameUser,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Card(
    //   color: swimlanesController.taskCardColor,
    //   elevation: 4,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(0),
    //   ),
    //   child: SizedBox(
    //     width: swimlanesConfig.swimlaneWidth - 40,
    //     child: Stack(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
    //           child: Padding(
    //             padding: const EdgeInsets.only(
    //               top: 0,
    //               bottom: 8.0,
    //               left: 4.0,
    //               right: 70.0,
    //             ),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Card(
    //                   child: SizedBox(
    //                     width: swimlanesConfig.swimlaneWidth,
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Text(
    //                         "${currentTask.name ?? ""}-${currentTask.id ?? ""}",
    //                         style: TextStyle(
    //                           fontSize: 16,
    //                           color: swimlanesController.taskCardHeaderTextColor,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 widget.condensed
    //                     ? const IgnorePointer()
    //                     : Container(
    //                         color: swimlanesController.taskCardColor,
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             SwimlanesTaskCardContent<T>(
    //                               currentTask: currentTask,
    //                               swimlanesConfig: swimlanesConfig,
    //                               swimlanesController: swimlanesController,
    //                             ),
    //                             const SizedBox(
    //                               width: 1,
    //                               height: 0,
    //                               child: IgnorePointer(),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                 Divider(
    //                   color: swimlanesController.taskCardHeaderColor,
    //                 ),
    //                 widget.condensed
    //                     ? const IgnorePointer()
    //                     : Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Text(
    //                           "comments: ${currentTask.commentCount}",
    //                           style: const TextStyle(fontSize: 10),
    //                         ),
    //                       ),
    //                 Divider(
    //                   color: swimlanesController.taskCardHeaderColor,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.end,
    //                       children: [
    //                         currentTask.dueTime != null
    //                             ? Text(
    //                                 "due: ${L10n.stringFromTimestamp(
    //                                   timestamp: currentTask.dueTime as Timestamp,
    //                                 )}",
    //                                 style: const TextStyle(fontSize: 9),
    //                               )
    //                             : const IgnorePointer(),
    //                         Text(
    //                           "created: ${L10n.stringFromTimestamp(
    //                             timestamp: currentTask.creationDate as Timestamp,
    //                           )}",
    //                           style: const TextStyle(fontSize: 9),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           right: 0,
    //           top: 0,
    //           child: Opacity(
    //             opacity: 0.5,
    //             child: SizedBox(
    //               width: 72,
    //               height: 72,
    //               child: Center(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       "${currentTask.priority}",
    //                       style: TextStyle(
    //                         color: currentTask.color,
    //                         fontSize: 48,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           right: 0,
    //           bottom: 48,
    //           child: Opacity(
    //             opacity: 0.7,
    //             child: SizedBox(
    //               width: 60,
    //               height: 54,
    //               child: AssignedAvatar(
    //                 assignedTo: currentTask.assignedTo,
    //                 assignmentTime: L10n.stringFromTimestamp(timestamp: currentTask.assignmentTime ?? Timestamp.now()),
    //                 swimlanesController: swimlanesController,
    //               ),
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           right: 0,
    //           bottom: 0,
    //           child: Opacity(
    //             opacity: 0.5,
    //             child: SizedBox(
    //               width: 72,
    //               height: 54,
    //               child: Center(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Icon(
    //                       currentTask.icon,
    //                       color: currentTask.color,
    //                       size: 48,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
  }
}

// class AssignedAvatar extends StatelessWidget {
//   const AssignedAvatar({
//     super.key,
//     required this.swimlanesController,
//     required this.assignedTo,
//     required this.assignmentTime,
//   });

//   final SwimlanesController swimlanesController;
//   final String? assignedTo;
//   final String? assignmentTime;

//   @override
//   Widget build(BuildContext context) {
//     if (assignedTo == null) {
//       return const IgnorePointer();
//     }

//     final Future<QuerySnapshot> userLookup = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: assignedTo).snapshots().first;

//     return FutureBuilder<QuerySnapshot>(
//         future: userLookup,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Icon(Icons.no_accounts_outlined);
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 20.0),
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                   ),
//                 ),
//               ),
//             );
//           }
//           // return const Center(
//           //   child: Padding(
//           //     padding: EdgeInsets.only(bottom: 8.0),
//           //     child: SizedBox(
//           //       width: 24,
//           //       height: 24,
//           //       child: CircularProgressIndicator(
//           //         strokeWidth: 2,
//           //       ),
//           //     ),
//           //   ),
//           // );

//           FFrameUser assignedUser = FFrameUser.fromFirestore(snapshot: snapshot.data!.docs.first as DocumentSnapshot<Map<String, dynamic>>);

//           Widget avatar = const Icon(
//             Icons.account_circle_outlined,
//             size: 36,
//           );

//           if (assignedUser.photoURL != null) {
//             try {
//               NetworkImage networkImage = NetworkImage(assignedUser.photoURL!);
//               avatar = CircleAvatar(
//                 radius: 18.0,
//                 backgroundImage: (assignedUser.photoURL == null) ? null : networkImage,
//                 backgroundColor: (assignedUser.photoURL == null) ? Colors.amber : Colors.transparent,
//                 child: (assignedUser.photoURL == null)
//                     ? Text(
//                         "${assignedUser.displayName}",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       )
//                     : null,
//               );
//             } catch (e) {
//               Console.log("profile image could not be fetched", level: LogLevel.dev);
//             }
//           }
//           String tooltipMessage = "Assigned to: \t\t\t${assignedUser.displayName ?? ""}\nOn: \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$assignmentTime UTC";
//           return Tooltip(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: swimlanesController.swimlaneBackgroundColor,
//             ),
//             richMessage: WidgetSpan(
//               child: Text(tooltipMessage),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [avatar],
//               ),
//             ),
//           );
//         });
//   }
// }

// class SwimlanesTaskCardContent<T> extends StatelessWidget {
//   const SwimlanesTaskCardContent({
//     super.key,
//     required this.swimlanesController,
//     required this.currentTask,
//     required this.swimlanesConfig,
//   });
//   final SwimlanesConfig<T> swimlanesConfig;
//   final SwimlanesController swimlanesController;
//   final T currentTask;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: (swimlanesConfig.swimlaneWidth - 133),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SwimlanesTaskDescription<T>(
//           currentTask: currentTask,
//           swimlanesController: swimlanesController,
//           swimlanesConfig: swimlanesConfig,
//         ),
//       ),
//     );
//   }
// }

// class SwimlanesTaskDescription<T> extends StatelessWidget {
//   const SwimlanesTaskDescription({
//     super.key,
//     required this.currentTask,
//     required this.swimlanesController,
//     required this.swimlanesConfig,
//   });

//   final T currentTask;
//   final SwimlanesController swimlanesController;
//   final SwimlanesConfig<T> swimlanesConfig;

//   @override
//   Widget build(BuildContext context) {
//     int stringLength = 150;
//     List<Padding> descriptionParagraphs = [];
//     List<Widget> tooltipParagraphs = [];
//     String descriptionRaw = swimlanesConfig.getDescription(currentTask);

//     bool overflowNeeded = false;
//     int charactersRemaining = stringLength;

//     List<String> descriptionSplit = descriptionRaw.split("\\n");

//     for (String currentParagraph in descriptionSplit) {
//       String widgetParagraph = currentParagraph;
//       if (descriptionParagraphs.length < 3 && charactersRemaining > 0) {
//         if (currentParagraph.length > charactersRemaining) {
//           // current paragraph is longer than the allowed.
//           // shorten it and create the widget
//           widgetParagraph = currentParagraph.substring(0, charactersRemaining);
//         }
//         descriptionParagraphs.add(
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
//             child: Text(
//               widgetParagraph,
//               // textAlign: TextAlign.justify,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: swimlanesController.taskCardTextColor,
//               ),
//             ),
//           ),
//         );
//         charactersRemaining = (charactersRemaining - widgetParagraph.length);
//       } else {
//         charactersRemaining = 0;
//       }
//       tooltipParagraphs.add(
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Text(currentParagraph,
//               style: TextStyle(
//                 color: swimlanesController.taskCardTextColor,
//               )),
//         ),
//       );
//     }
//     overflowNeeded = (charactersRemaining < 1);

//     if (overflowNeeded) {
//       descriptionParagraphs.add(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 20.0),
//             child: Text(
//               "...",
//               textAlign: TextAlign.end,
//               style: TextStyle(
//                 fontSize: 20,
//                 color: swimlanesController.swimlaneSeparatorColor,
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     return overflowNeeded
//         ? Tooltip(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: swimlanesController.swimlaneBackgroundColor,
//               // gradient:
//               //     const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
//             ),
//             preferBelow: true,
//             richMessage: WidgetSpan(
//               child: SizedBox(
//                 width: 400,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: tooltipParagraphs,
//                   ),
//                 ),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 2, right: 2),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: descriptionParagraphs,
//                 // children: [
//                 // ],
//               ),
//             ),
//           )
//         : Padding(
//             padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 2, right: 2),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: descriptionParagraphs,
//               // children: [
//               // ],
//             ),
//           );
//   }
// }
