part of fframe;

class InheritedDocument extends InheritedWidget {
  const InheritedDocument({Key? key, required this.documentConfig, required child}) : super(key: key, child: child);

  final DocumentConfig documentConfig;

  static InheritedDocument? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDocument>();
  }

  @override
  bool updateShouldNotify(InheritedDocument oldWidget) {
    return true;
  }

  toggleEditMode() {}

  delete() {}

  close() {
    // FRouter.of(context).
    // ref.read(selectionStateProvider).state = SelectionState(
    //   docId: null,
    //   data: null,
    //   queryParams: null,
    // );
  }

  // ignore: unused_element
  copy() {}

  create() {
    // ref.read(selectionStateProvider).state = SelectionState(
    //   docId: null,
    //   data: documentConfig.createNew(),
    //   queryParams: null,
    // );
  }

  Future<bool> save() async {
    try {
      // String? documentId = selectionState.docId;
      // debugPrint("Save item $documentId in collection ${documentConfig.collection}");
      // if (documentConfig.createDocumentId != null && selectionState.docId == null) {
      //   debugPrint("Request a new documentId");
      //   documentId = documentConfig.createDocumentId!(selectionState.data);
      // }
      // documentId = documentId ?? const Uuid().v4();

      // if (await DatabaseService<T>().updateData(
      //   collection: documentConfig.collection,
      //   documentId: documentId,
      //   data: selectionState.data,
      //   fromFirestore: documentConfig.fromFirestore,
      //   toFirestore: documentConfig.toFirestore,
      // )) {
      //   //Success
      //   debugPrint("Save was successfull ");
      //   return true;
      // } else {
      //   debugPrint("Save failed");
      //   return false;
      // } // Failed

    } catch (error) {
      debugPrint(error.toString());
    }
    return false;
  }

  validate() async {
    // debugPrint("callValidate");
    // DocumentBody<T>? DocumentBody = selectionState.globalKey.currentWidget as DocumentBody<T>?;
    // if (DocumentBody != null) {
    //   if (DocumentBody.validateDocument() == true) {
    //     //Save this document
    //     if ((await _callSave()) == true) {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         behavior: SnackBarBehavior.floating,
    //         content: Text(
    //           L10n.string(
    //             'validator_savesuccess',
    //             placeholder: "Saved succesfully",
    //           ),
    //         ),
    //       ));
    //       // callClose();
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         behavior: SnackBarBehavior.floating,
    //         content: ListTile(
    //           leading: const Icon(
    //             Icons.warning,
    //             color: Colors.amberAccent,
    //           ),
    //           title: Text(
    //             L10n.string(
    //               'validator_savefail',
    //               placeholder: "Save failed succesfully.",
    //             ),
    //           ),
    //           tileColor: Colors.redAccent,
    //         ),
    //       ));
    //     }
    //   }
    // } else {
    //   debugPrint(selectionState.globalKey.currentWidget.toString());
    // }
  }

  List<IconButton>? iconButtons(BuildContext context) {
    List<IconButton>? iconButtons = [
      IconButton(
        icon: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () {
          close();
        },
      ),
      // IconButton(
      //   icon: Icon(
      //     Icons.edit,
      //     color: Colors.grey.shade400,
      //   ),
      //   onPressed: _callEditToggle,
      // ),
      // IconButton(
      //   icon: Icon(
      //     Icons.delete,
      //     color: Colors.grey.shade400,
      //   ),
      //   onPressed: _callDelete,
      // ),
      // IconButton(
      //   icon: Icon(
      //     Icons.copy_outlined,
      //     color: Colors.grey.shade400,
      //   ),
      //   onPressed: _callCopy,
      // ),
      IconButton(
        icon: Icon(
          Icons.save,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () {
          validate();
        },
      ),
    ];

    //Add any extra configured buttons to the list
    if (documentConfig.extraActionButtons != null) {
      iconButtons.addAll(documentConfig.extraActionButtons!);
    }
    return iconButtons;
  }

  FloatingActionButton fab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: const Icon(Icons.add),
      elevation: 0.2,
      onPressed: () {
        create();
      },
    );
  }
}

class DocumentScreen<T> extends ConsumerWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("(re)build DocumentScreen");
    // InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;
    SelectionState selectionState = ref.read(selectionStateProvider).state;

    //Handle a case where a deeplink to a document comes in
    if (selectionState.data == null && selectionState.queryParams?[documentConfig.queryStringIdParam] != null && selectionState.docId != selectionState.queryParams![documentConfig.queryStringIdParam]) {
      debugPrint("Lazy load the deeplinked document");
      // lazyLoad(selectionState);
    }

    return Row(
      children: [
        if (documentConfig.documentList != null)
          SizedBox(
            width: 250,
            child: Column(
              children: [
                //TODO: Fix this search stuff
                // const Padding(
                //   padding: EdgeInsets.only(bottom: 4.0),
                //   child: DocSearch(),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: DocumentListBuilder<T>(
                      key: ValueKey(documentConfig.collection),
                      // collection: documentConfig.collection,
                      // fromFirestore: documentConfig.fromFirestore,
                      // documentList: documentConfig.documentList!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (documentConfig.documentList != null) const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: ScreenBody<T>(),
        ),
      ],
    );
  }
}

class ScreenBody<T> extends ConsumerWidget {
  const ScreenBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TargetState targetState = ref.watch(targetStateProvider);
    QueryState queryState = ref.watch(queryStateProvider);
    debugPrint("ReSpawn DocumentBody for ${targetState.navigationTarget.title} ${queryState.queryString} preloaded: ${queryState.context != null}");
    Widget returnWidget = queryState.queryString.isEmpty ? FRouter.of(context).emptyPage : DocumentBody(key: ValueKey(queryState.queryString), queryState: queryState);
    // return returnWidget;
    return AnimatedSwitcher(
      key: ValueKey("query_${key.toString()}"),
      duration: const Duration(milliseconds: 250),
      child: returnWidget,
    );
  }
}
