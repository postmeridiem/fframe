part of 'package:fframe/fframe.dart';

// class SwimlanesDocument<T> extends StatefulWidget {
//   const SwimlanesDocument({
//     super.key,
//     required this.documentConfig,
//     required this.swimlanesController,
//     required this.swimlanesConfig,
//     required this.documentOpen,
//   });
//   final DocumentConfig<T> documentConfig;
//   final SwimlanesController swimlanesController;
//   final SwimlanesConfig<T> swimlanesConfig;
//   final bool documentOpen;

//   @override
//   State<SwimlanesDocument<T>> createState() => _SwimlanesDocumentState<T>();
// }

// class _SwimlanesDocumentState<T> extends State<SwimlanesDocument<T>> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.documentOpen) {
//       DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
//       DocumentConfig<T> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<T>;
//       FFrameUser fFrameUser = Fframe.of(context)!.user!;
//       QueryState queryState = ref.watch(queryStateProvider);
//       String taskId = queryState.queryParameters![documentScreenConfig.documentConfig.queryStringIdParam]!;
//       String taskCollection = documentScreenConfig.documentConfig.collection;
//       Future<DocumentSnapshot> fsTask = FirebaseFirestore.instance.collection(taskCollection).doc(taskId).get();

//       return FutureBuilder(
//           future: fsTask,
//           builder: (BuildContext context, AsyncSnapshot asyncSnap) {
//             if (asyncSnap.hasData) {
//               T currentTask = documentConfig.fromFirestore(asyncSnap.data, null);
//               return Row(
//                 children: [
//                   SwimlanesDocumentContentPane(
//                     swimlanesController: widget.swimlanesController,
//                     swimlanesConfig: widget.swimlanesConfig,
//                     currentTask: currentTask,
//                   ),
//                   SwimlanesDocumentTaskCard(
//                     swimlanesController: widget.swimlanesController,
//                     currentTask: currentTask,
//                     taskCollection: taskCollection,
//                     fFrameUser: fFrameUser,
//                   ),
//                 ],
//               );
//             } else if (asyncSnap.hasError) {
//               return Text("error: ${asyncSnap.error}");
//             } else {
//               return const Text("loading...");
//             }
//           });
//     } else {
//       return const IgnorePointer();
//     }
//   }
// }

// class SwimlanesDocumentContentPane<T> extends StatelessWidget {
//   const SwimlanesDocumentContentPane({
//     super.key,
//     required this.swimlanesController,
//     required this.swimlanesConfig,
//     required this.currentTask,
//   });
//   final SwimlanesController swimlanesController;
//   final SwimlanesConfig<T> swimlanesConfig;
//   final T currentTask;

//   @override
//   Widget build(BuildContext context) {
//     if (swimlanesConfig.getLinkedId(currentTask) != null) {
//       return Expanded(
//         child: Container(
//           color: swimlanesController.swimlaneBackgroundColor,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Card(
//                     color: swimlanesController.taskCardColor,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("lazy loading linked content"),
//                           Text("from collection: ${swimlanesConfig.getLinkedPath(currentTask)}"),
//                           Text("with id: ${swimlanesConfig.getLinkedId(currentTask)}"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Expanded(
//         child: Container(
//           color: swimlanesController.swimlaneBackgroundColor,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Card(
//                         color: swimlanesController.taskCardColor,
//                         child: const Padding(
//                           padding: EdgeInsets.all(24.0),
//                           child: Text("No linked content specified."),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }

// class SwimlanesDocumentTaskCard<T> extends StatelessWidget {
//   const SwimlanesDocumentTaskCard({
//     super.key,
//     required this.swimlanesController,
//     required this.currentTask,
//     required this.taskCollection,
//     required this.fFrameUser,
//   });

//   final SwimlanesController swimlanesController;
//   final T currentTask;
//   final String taskCollection;
//   final FFrameUser fFrameUser;

//   @override
//   Widget build(BuildContext context) {
//     // register shared validator class for common patterns
//     // Validator validator = Validator();
//     // bool readOnly = true;
//     // debugPrint(asyncSnap.data.toString());
//     // DocumentSnapshot<Map<String, dynamic>> snapshot =
//     //     asyncSnap as DocumentSnapshot<Map<String, dynamic>>;

//     // String createdBy = currentTask.createdBy ?? "unknown";
//     // String creationDate = L10n.stringFromTimestamp(timestamp: currentTask.creationDate ?? Timestamp.fromMicrosecondsSinceEpoch(0));

//     // String lastUpdatedBy = currentTask.createdBy ?? "unknown";
//     // String lastUpdatedOn = L10n.stringFromTimestamp(timestamp: currentTask.creationDate ?? Timestamp.fromMicrosecondsSinceEpoch(0));
//     // if (currentTask.changeHistory.isNotEmpty && currentTask.changeHistory.last.isNotEmpty) {
//     //   lastUpdatedBy = currentTask.changeHistory.last.entries.first.key;
//     //   Timestamp lastUpdatedTS = currentTask.changeHistory.last.entries.first.value as Timestamp;
//     //   lastUpdatedOn = L10n.stringFromTimestamp(timestamp: lastUpdatedTS);
//     //   // lastUpdatedOn = "${currentTask.changeHistory.last.entries.first.value}";
//     // }

//     return const Text("SwimlanesDocumentTaskCard");

//     // return Container(
//     //   color: swimlanes.swimlaneBackgroundColor,
//     //   child: SizedBox(
//     //     width: swimlanes.config.swimlaneWidth,
//     //     child: Padding(
//     //       padding: const EdgeInsets.all(8.0),
//     //       child: GestureDetector(
//     //         onTap: () {},
//     //         child: Card(
//     //           color: swimlanes.taskCardColor,
//     //           elevation: 4,
//     //           shape: RoundedRectangleBorder(
//     //             borderRadius: BorderRadius.circular(0),
//     //           ),
//     //           child: Stack(
//     //             children: [
//     //               Padding(
//     //                 padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//     //                 child: Padding(
//     //                   padding: const EdgeInsets.only(
//     //                     top: 0,
//     //                     bottom: 8.0,
//     //                     left: 4.0,
//     //                     right: 70.0,
//     //                   ),
//     //                   child: Column(
//     //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                     crossAxisAlignment: CrossAxisAlignment.start,
//     //                     children: [
//     //                       Column(
//     //                         children: [
//     //                           Card(
//     //                             child: SizedBox(
//     //                               width: swimlanes.config.swimlaneWidth,
//     //                               child: Padding(
//     //                                 padding: const EdgeInsets.all(8.0),
//     //                                 child: Text(
//     //                                   currentTask.name ?? "",
//     //                                   style: TextStyle(
//     //                                     fontSize: 16,
//     //                                     color: swimlanes.taskCardHeaderTextColor,
//     //                                   ),
//     //                                 ),
//     //                               ),
//     //                             ),
//     //                           ),
//     //                           Divider(
//     //                             color: swimlanes.taskCardHeaderColor,
//     //                           ),
//     //                         ],
//     //                       ),
//     //                       Table(
//     //                         columnWidths: const {
//     //                           0: FixedColumnWidth(100),
//     //                           1: FlexColumnWidth(),
//     //                         },
//     //                         children: [
//     //                           TableRow(
//     //                             children: [
//     //                               const Text("path: "),
//     //                               Text(currentTask.linkedPath ?? "path-empty"),
//     //                             ],
//     //                           ),
//     //                           TableRow(
//     //                             children: [
//     //                               const Text("id: "),
//     //                               Text(currentTask.linkedDocumentId ?? "id-empty"),
//     //                             ],
//     //                           ),
//     //                           TableRow(
//     //                             children: [
//     //                               const Text("prio: "),
//     //                               Text("${currentTask.priority}"),
//     //                             ],
//     //                           ),
//     //                           if (currentTask.assignedTo != null)
//     //                             TableRow(
//     //                               children: [
//     //                                 const Text("assigned to: "),
//     //                                 Text(currentTask.assignedTo as String),
//     //                               ],
//     //                             ),
//     //                           if (currentTask.assignmentTime != null)
//     //                             TableRow(
//     //                               children: [
//     //                                 const Text("assigned on: "),
//     //                                 Text(L10n.stringFromTimestamp(timestamp: currentTask.assignmentTime as Timestamp)),
//     //                               ],
//     //                             ),
//     //                           if (currentTask.dueTime != null)
//     //                             TableRow(
//     //                               children: [
//     //                                 const Text("due: "),
//     //                                 Text(L10n.stringFromTimestamp(timestamp: currentTask.dueTime as Timestamp)),
//     //                               ],
//     //                             ),
//     //                           TableRow(
//     //                             children: [
//     //                               const Text("save count: "),
//     //                               Text("${currentTask.saveCount}"),
//     //                             ],
//     //                           ),
//     //                         ],
//     //                       ),
//     //                       const Divider(),
//     //                       Expanded(
//     //                         child: Column(
//     //                           mainAxisAlignment: MainAxisAlignment.start,
//     //                           crossAxisAlignment: CrossAxisAlignment.start,
//     //                           children: [
//     //                             Container(
//     //                               color: swimlanes.swimlaneBackgroundColor,
//     //                               child: Column(
//     //                                 children: [
//     //                                   SizedBox(
//     //                                     width: swimlanes.config.swimlaneWidth - 115,
//     //                                     // height: 600,
//     //                                     child: Column(
//     //                                       mainAxisAlignment: MainAxisAlignment.start,
//     //                                       crossAxisAlignment: CrossAxisAlignment.start,
//     //                                       children: [
//     //                                         const Padding(
//     //                                           padding: EdgeInsets.all(8.0),
//     //                                           child: Padding(
//     //                                             padding: EdgeInsets.only(left: 32.0),
//     //                                             child: Text("Description"),
//     //                                           ),
//     //                                         ),
//     //                                         Padding(
//     //                                           padding: const EdgeInsets.all(4.0),
//     //                                           child: TextField(
//     //                                             style: const TextStyle(fontSize: 14),
//     //                                             controller: TextEditingController(
//     //                                               text: currentTask.description,
//     //                                             ),
//     //                                             maxLines: 30,
//     //                                             minLines: 6,
//     //                                           ),
//     //                                         ),
//     //                                         // SizedBox(
//     //                                         //   height: 500,
//     //                                         //   child: MarkdownFormField(
//     //                                         //     enableToolBar: true,
//     //                                         //     emojiConvert: true,
//     //                                         //     autoCloseAfterSelectEmoji: true,
//     //                                         //     readOnly: false,
//     //                                         //     // style: const TextStyle(
//     //                                         //     //   fontSize: 14,
//     //                                         //     // ),
//     //                                         //     controller:
//     //                                         //         TextEditingController(
//     //                                         //       text: currentTask.description,
//     //                                         //     ),
//     //                                         //     focusNode: FocusNode(),
//     //                                         //   ),
//     //                                         // ),
//     //                                       ],
//     //                                     ),
//     //                                   ),
//     //                                 ],
//     //                               ),
//     //                             ),
//     //                           ],
//     //                         ),
//     //                       ),
//     //                       Column(
//     //                         children: [
//     //                           Divider(
//     //                             color: swimlanes.taskCardHeaderColor,
//     //                           ),
//     //                           Row(
//     //                             mainAxisAlignment: MainAxisAlignment.end,
//     //                             children: [
//     //                               Column(
//     //                                 crossAxisAlignment: CrossAxisAlignment.end,
//     //                                 children: [
//     //                                   const Text(
//     //                                     textAlign: TextAlign.end,
//     //                                     "last update",
//     //                                     style: TextStyle(
//     //                                       fontSize: 9,
//     //                                     ),
//     //                                   ),
//     //                                   Text(
//     //                                     textAlign: TextAlign.end,
//     //                                     lastUpdatedBy,
//     //                                     style: const TextStyle(
//     //                                       fontSize: 12,
//     //                                     ),
//     //                                   ),
//     //                                   Text(
//     //                                     textAlign: TextAlign.end,
//     //                                     lastUpdatedOn,
//     //                                     style: const TextStyle(
//     //                                       fontSize: 9,
//     //                                     ),
//     //                                   ),
//     //                                   const Divider(),
//     //                                   const Text(
//     //                                     textAlign: TextAlign.end,
//     //                                     "created",
//     //                                     style: TextStyle(
//     //                                       fontSize: 9,
//     //                                     ),
//     //                                   ),
//     //                                   Text(
//     //                                     textAlign: TextAlign.end,
//     //                                     createdBy,
//     //                                     style: const TextStyle(
//     //                                       fontSize: 12,
//     //                                     ),
//     //                                   ),
//     //                                   Text(
//     //                                     textAlign: TextAlign.end,
//     //                                     creationDate,
//     //                                     style: const TextStyle(
//     //                                       fontSize: 9,
//     //                                     ),
//     //                                   ),
//     //                                 ],
//     //                               ),
//     //                             ],
//     //                           ),
//     //                         ],
//     //                       ),
//     //                       Row(
//     //                         children: [
//     //                           if (fFrameUser.hasRole("firestoreaccess"))
//     //                             IconButton(
//     //                               tooltip: "Open Firestore Document",
//     //                               onPressed: () {
//     //                                 String domain = "https://console.cloud.google.com";
//     //                                 String application = "firestore/databases/-default-/data/panel";
//     //                                 String collection = taskCollection;
//     //                                 debugPrint(taskCollection);
//     //                                 String docId = currentTask.id ?? "";
//     //                                 String gcpProject = Fframe.of(context)!.firebaseOptions.projectId;
//     //                                 Uri url = Uri.parse("$domain/$application/$collection/$docId?&project=$gcpProject");
//     //                                 launchUrl(url);
//     //                               },
//     //                               icon: Icon(
//     //                                 Icons.table_chart_outlined,
//     //                                 color: Theme.of(context).indicatorColor,
//     //                               ),
//     //                             ),
//     //                         ],
//     //                       )
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ),
//     //               Positioned(
//     //                 right: 0,
//     //                 top: 0,
//     //                 child: Opacity(
//     //                   opacity: 0.5,
//     //                   child: SizedBox(
//     //                     width: 72,
//     //                     height: 72,
//     //                     child: Center(
//     //                       child: Column(
//     //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                         crossAxisAlignment: CrossAxisAlignment.center,
//     //                         children: [
//     //                           Text(
//     //                             "${currentTask.priority}",
//     //                             style: const TextStyle(
//     //                               color: Colors.cyan,
//     //                               fontSize: 48,
//     //                             ),
//     //                           ),
//     //                         ],
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //               Positioned(
//     //                 right: 0,
//     //                 bottom: 48,
//     //                 child: Opacity(
//     //                   opacity: 0.6,
//     //                   child: SizedBox(
//     //                     width: 60,
//     //                     height: 54,
//     //                     // child: IgnorePointer(),
//     //                     child: AssignedAvatar(
//     //                       assignedTo: currentTask.assignedTo,
//     //                       assignmentTime: L10n.stringFromTimestamp(timestamp: currentTask.assignmentTime ?? Timestamp.now()),
//     //                       swimlanes: swimlanes,
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //               Positioned(
//     //                 right: 0,
//     //                 bottom: 0,
//     //                 child: Opacity(
//     //                   opacity: 0.5,
//     //                   child: SizedBox(
//     //                     width: 72,
//     //                     height: 54,
//     //                     child: Center(
//     //                       child: Column(
//     //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                         crossAxisAlignment: CrossAxisAlignment.center,
//     //                         children: [
//     //                           Icon(
//     //                             currentTask.icon,
//     //                             color: currentTask.color,
//     //                             size: 48,
//     //                           ),
//     //                         ],
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );

//     // return Container(
//     //   color: swimlanes.swimlaneBackgroundColor,
//     //   child: SizedBox(
//     //       width: swimlanes.config.swimlaneWidth,
//     //       // child: const Placeholder(),
//     //       child: Padding(
//     //         padding: const EdgeInsets.all(8.0),
//     //         child: Card(
//     //           color: swimlanes.taskCardColor,
//     //           child: Column(
//     //             children: [
//     //               Card(
//     //                 child: SizedBox(
//     //                   width: swimlanes.config.swimlaneWidth,
//     //                   child: Padding(
//     //                     padding: const EdgeInsets.all(8.0),
//     //                     child: Text(
//     //                       "title",
//     //                       style: TextStyle(
//     //                         fontSize: 16,
//     //                         color: swimlanes.taskCardHeaderTextColor,
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     // QuillToolbar.basic(
//     //   controller: _controller,
//     //   toolbarIconAlignment: WrapAlignment.start,
//     //   multiRowsDisplay: true,
//     //   showDividers: true,
//     //   showFontFamily: false,
//     //   showFontSize: false,
//     //   showBoldButton: true,
//     //   showItalicButton: true,
//     //   showSmallButton: false,
//     //   showUnderLineButton: true,
//     //   showStrikeThrough: false,
//     //   showInlineCode: false,
//     //   showColorButton: false,
//     //   showBackgroundColorButton: false,
//     //   showClearFormat: true,
//     //   showAlignmentButtons: false,
//     //   showLeftAlignment: false,
//     //   showCenterAlignment: false,
//     //   showRightAlignment: false,
//     //   showJustifyAlignment: false,
//     //   showHeaderStyle: false,
//     //   showListNumbers: false,
//     //   showListBullets: true,
//     //   showListCheck: false,
//     //   showCodeBlock: true,
//     //   showQuote: false,
//     //   showIndent: false,
//     //   showLink: true,
//     //   showUndo: false,
//     //   showRedo: false,
//     //   showDirection: false,
//     //   showSearchButton: false,
//     //   showSubscript: false,
//     //   showSuperscript: false,
//     // ),
//     // Expanded(
//     //   child: QuillEditor.basic(
//     //     controller: _controller,
//     //     readOnly: false, // true for view only mode
//     //   ),
//     // )
//     //             ],
//     //           ),
//     //         ),
//     //       )
//     //       // child: Card(
//     //       //   child: Padding(
//     //       //     padding: const EdgeInsets.all(8.0),
//     //       //     child: Column(
//     //       //       crossAxisAlignment: CrossAxisAlignment.start,
//     //       //       children: [
//     //       //         Padding(
//     //       //           padding: const EdgeInsets.only(bottom: 16.0),
//     //       //           child: TextFormField(
//     //       //             readOnly: readOnly,
//     //       //             decoration: const InputDecoration(
//     //       //               // hoverColor: Color(0xFFFF00C8),
//     //       //               // hoverColor: Theme.of(context).indicatorColor,
//     //       //               border: OutlineInputBorder(),
//     //       //               labelText: "Name",
//     //       //             ),
//     //       //             initialValue: swimlanesTask.name ?? '',
//     //       //             validator: (curValue) {
//     //       //               if (validator.validString(curValue)) {
//     //       //                 swimlanesTask.name = curValue;
//     //       //                 return null;
//     //       //               } else {
//     //       //                 return 'Enter a valid name';
//     //       //               }
//     //       //             },
//     //       //           ),
//     //       //         ),
//     //       //         Padding(
//     //       //           padding: const EdgeInsets.only(bottom: 16.0),
//     //       //           child: TextFormField(
//     //       //             readOnly: true,
//     //       //             onSaved: (String? value) {
//     //       //               swimlanesTask.status = value ?? "";
//     //       //             },
//     //       //             decoration: const InputDecoration(
//     //       //               border: OutlineInputBorder(),
//     //       //               labelText: "Status",
//     //       //             ),
//     //       //             initialValue: swimlanesTask.status ?? '',
//     //       //             validator: (value) {
//     //       //               if (!validator.validString(value)) {
//     //       //                 return 'Enter a valid value';
//     //       //               }
//     //       //               return null;
//     //       //             },
//     //       //           ),
//     //       //         ),
//     //       //         Padding(
//     //       //           padding: const EdgeInsets.only(bottom: 16.0),
//     //       //           child: TextFormField(
//     //       //             minLines: 5,
//     //       //             maxLines: 10,
//     //       //             onSaved: (String? value) {
//     //       //               swimlanesTask.description = value ?? "";
//     //       //             },
//     //       //             readOnly: readOnly,
//     //       //             decoration: const InputDecoration(
//     //       //               border: OutlineInputBorder(),
//     //       //               labelText: "Description",
//     //       //             ),
//     //       //             initialValue: swimlanesTask.description ?? '',
//     //       //             validator: (value) {
//     //       //               if (!validator.validString(value)) {
//     //       //                 return 'Enter a valid value';
//     //       //               }
//     //       //               return null;
//     //       //             },
//     //       //           ),
//     //       //         ),
//     //       //         Padding(
//     //       //           padding: const EdgeInsets.only(bottom: 16.0),
//     //       //           child: TextFormField(
//     //       //             readOnly: true,
//     //       //             initialValue: swimlanesTask.createdBy ?? "unknown",
//     //       //             decoration: const InputDecoration(
//     //       //               border: OutlineInputBorder(),
//     //       //               labelText: "Author",
//     //       //             ),
//     //       //           ),
//     //       //         ),
//     //       //       ],
//     //       //     ),
//     //       //   ),
//     //       // ),
//     //       ),
//     // );
//   }
// }
