part of fframe;

class SwimlanesDocument extends ConsumerStatefulWidget {
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
  ConsumerState<SwimlanesDocument> createState() => _SwimlanesDocumentState();
}

class _SwimlanesDocumentState extends ConsumerState<SwimlanesDocument> {
  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    DocumentConfig<SwimlanesTask> documentConfig =
        documentScreenConfig.documentConfig as DocumentConfig<SwimlanesTask>;

    QueryState queryState = ref.watch(queryStateProvider);
    SwimlanesTask currentTask = documentScreenConfig.load<SwimlanesTask>(
        context: context,
        docId: queryState.queryParameters![
            documentScreenConfig.documentConfig.queryStringIdParam]!);

    return widget.documentOpen
        ? Row(
            children: [
              Expanded(
                child: ScreenBody<SwimlanesTask>(
                  key: ValueKey("ScreenBody_${documentConfig.collection}"),
                ),
              ),
              SwimlanesDocumentTaskCard(
                  swimlanes: widget.swimlanes, documentTask: currentTask),
            ],
          )
        : const IgnorePointer();
  }
}

class SwimlanesDocumentTaskCard extends StatelessWidget {
  SwimlanesDocumentTaskCard({
    super.key,
    required this.swimlanes,
    required this.documentTask,
  });

  final SwimlanesController swimlanes;
  final SwimlanesTask documentTask;
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    // register shared validator class for common patterns
    Validator validator = Validator();
    bool readOnly = true;

    return Container(
      color: swimlanes.swimlaneBackgroundColor,
      child: SizedBox(
        width: swimlanes.config.swimlaneWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Card(
              color: swimlanes.taskCardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
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
                          Column(
                            children: [
                              Card(
                                child: SizedBox(
                                  width: swimlanes.config.swimlaneWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      documentTask.name ?? "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            swimlanes.taskCardHeaderTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: swimlanes.taskCardHeaderColor,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("currentTask.linkedPath"),
                              Text("currentTask.linkedDocumentId"),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: swimlanes.swimlaneBackgroundColor,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: swimlanes.config.swimlaneWidth -
                                            115,
                                        height: 600,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 32.0),
                                                child: Text("Description"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: QuillEditor.basic(
                                                  controller: _controller,
                                                  readOnly:
                                                      false, // true for view only mode
                                                ),
                                              ),
                                            ),
                                            QuillToolbar.basic(
                                              controller: _controller,
                                              toolbarIconAlignment:
                                                  WrapAlignment.start,
                                              toolbarIconSize: 14,
                                              multiRowsDisplay: true,
                                              showDividers: true,
                                              showFontFamily: false,
                                              showFontSize: true,
                                              showBoldButton: true,
                                              showItalicButton: true,
                                              showSmallButton: false,
                                              showUnderLineButton: true,
                                              showStrikeThrough: false,
                                              showInlineCode: false,
                                              showColorButton: false,
                                              showBackgroundColorButton: false,
                                              showClearFormat: true,
                                              showAlignmentButtons: false,
                                              showLeftAlignment: false,
                                              showCenterAlignment: false,
                                              showRightAlignment: false,
                                              showJustifyAlignment: false,
                                              showHeaderStyle: false,
                                              showListNumbers: false,
                                              showListBullets: true,
                                              showListCheck: false,
                                              showCodeBlock: true,
                                              showQuote: false,
                                              showIndent: false,
                                              showLink: true,
                                              showUndo: false,
                                              showRedo: false,
                                              showDirection: false,
                                              showSearchButton: false,
                                              showSubscript: false,
                                              showSuperscript: false,
                                              fontSizeValues: const {
                                                "Small": "10",
                                                "Medium": "12",
                                                "Large": "16"
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Divider(
                                color: swimlanes.taskCardHeaderColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("created by bla"),
                                    ],
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
                                "0",
                                style: TextStyle(
                                  color: Colors.cyan,
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
                        child: IgnorePointer(),
                        // child: AssignedAvatar(
                        //   assignedTo: currentTask.assignedTo,
                        //   assignmentTime: L10n.stringFromTimestamp(
                        //       timestamp:
                        //           currentTask.assignmentTime ?? Timestamp.now()),
                        //   swimlanes: swimlanes,
                        // ),
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
                              // Icon(
                              //   currentTask.icon,
                              //   color: currentTask.color,
                              //   size: 48,
                              // ),
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
      ),
    );

    // return Container(
    //   color: swimlanes.swimlaneBackgroundColor,
    //   child: SizedBox(
    //       width: swimlanes.config.swimlaneWidth,
    //       // child: const Placeholder(),
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Card(
    //           color: swimlanes.taskCardColor,
    //           child: Column(
    //             children: [
    //               Card(
    //                 child: SizedBox(
    //                   width: swimlanes.config.swimlaneWidth,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       "title",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         color: swimlanes.taskCardHeaderTextColor,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    // QuillToolbar.basic(
    //   controller: _controller,
    //   toolbarIconAlignment: WrapAlignment.start,
    //   multiRowsDisplay: true,
    //   showDividers: true,
    //   showFontFamily: false,
    //   showFontSize: false,
    //   showBoldButton: true,
    //   showItalicButton: true,
    //   showSmallButton: false,
    //   showUnderLineButton: true,
    //   showStrikeThrough: false,
    //   showInlineCode: false,
    //   showColorButton: false,
    //   showBackgroundColorButton: false,
    //   showClearFormat: true,
    //   showAlignmentButtons: false,
    //   showLeftAlignment: false,
    //   showCenterAlignment: false,
    //   showRightAlignment: false,
    //   showJustifyAlignment: false,
    //   showHeaderStyle: false,
    //   showListNumbers: false,
    //   showListBullets: true,
    //   showListCheck: false,
    //   showCodeBlock: true,
    //   showQuote: false,
    //   showIndent: false,
    //   showLink: true,
    //   showUndo: false,
    //   showRedo: false,
    //   showDirection: false,
    //   showSearchButton: false,
    //   showSubscript: false,
    //   showSuperscript: false,
    // ),
    // Expanded(
    //   child: QuillEditor.basic(
    //     controller: _controller,
    //     readOnly: false, // true for view only mode
    //   ),
    // )
    //             ],
    //           ),
    //         ),
    //       )
    //       // child: Card(
    //       //   child: Padding(
    //       //     padding: const EdgeInsets.all(8.0),
    //       //     child: Column(
    //       //       crossAxisAlignment: CrossAxisAlignment.start,
    //       //       children: [
    //       //         Padding(
    //       //           padding: const EdgeInsets.only(bottom: 16.0),
    //       //           child: TextFormField(
    //       //             readOnly: readOnly,
    //       //             decoration: const InputDecoration(
    //       //               // hoverColor: Color(0xFFFF00C8),
    //       //               // hoverColor: Theme.of(context).indicatorColor,
    //       //               border: OutlineInputBorder(),
    //       //               labelText: "Name",
    //       //             ),
    //       //             initialValue: swimlanesTask.name ?? '',
    //       //             validator: (curValue) {
    //       //               if (validator.validString(curValue)) {
    //       //                 swimlanesTask.name = curValue;
    //       //                 return null;
    //       //               } else {
    //       //                 return 'Enter a valid name';
    //       //               }
    //       //             },
    //       //           ),
    //       //         ),
    //       //         Padding(
    //       //           padding: const EdgeInsets.only(bottom: 16.0),
    //       //           child: TextFormField(
    //       //             readOnly: true,
    //       //             onSaved: (String? value) {
    //       //               swimlanesTask.status = value ?? "";
    //       //             },
    //       //             decoration: const InputDecoration(
    //       //               border: OutlineInputBorder(),
    //       //               labelText: "Status",
    //       //             ),
    //       //             initialValue: swimlanesTask.status ?? '',
    //       //             validator: (value) {
    //       //               if (!validator.validString(value)) {
    //       //                 return 'Enter a valid value';
    //       //               }
    //       //               return null;
    //       //             },
    //       //           ),
    //       //         ),
    //       //         Padding(
    //       //           padding: const EdgeInsets.only(bottom: 16.0),
    //       //           child: TextFormField(
    //       //             minLines: 5,
    //       //             maxLines: 10,
    //       //             onSaved: (String? value) {
    //       //               swimlanesTask.description = value ?? "";
    //       //             },
    //       //             readOnly: readOnly,
    //       //             decoration: const InputDecoration(
    //       //               border: OutlineInputBorder(),
    //       //               labelText: "Description",
    //       //             ),
    //       //             initialValue: swimlanesTask.description ?? '',
    //       //             validator: (value) {
    //       //               if (!validator.validString(value)) {
    //       //                 return 'Enter a valid value';
    //       //               }
    //       //               return null;
    //       //             },
    //       //           ),
    //       //         ),
    //       //         Padding(
    //       //           padding: const EdgeInsets.only(bottom: 16.0),
    //       //           child: TextFormField(
    //       //             readOnly: true,
    //       //             initialValue: swimlanesTask.createdBy ?? "unknown",
    //       //             decoration: const InputDecoration(
    //       //               border: OutlineInputBorder(),
    //       //               labelText: "Author",
    //       //             ),
    //       //           ),
    //       //         ),
    //       //       ],
    //       //     ),
    //       //   ),
    //       // ),
    //       ),
    // );
  }
}
