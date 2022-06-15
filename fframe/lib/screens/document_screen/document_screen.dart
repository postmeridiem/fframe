part of fframe;

class DocumentScreen<T> extends StatelessWidget {
  const DocumentScreen({
    Key? key,
    required this.collection,
    required this.createNew,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.documentList,
    this.documentBuilder,
    this.titleBuilder,
    required this.document,
    this.extraActionButtons,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
  }) : super(key: key);

  final DocumentList<T>? documentList;
  final DocumentBuilder<T>? documentBuilder;
  final TitleBuilder<T>? titleBuilder;
  final Document<T> document;
  final List<IconButton>? extraActionButtons;
  final String queryStringIdParam;
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final T Function() createNew;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;

  @override
  Widget build(BuildContext context) {
    InheritedDocument? parentInheritedDocument = InheritedDocument.of(context);
    String? _queryStringIdParam;
    bool? _embeddedDocument;
    if (parentInheritedDocument != null) {
      debugPrint("This is an embedded instance of the DocumentScreen initalize FormCeption");
      if (queryStringIdParam == parentInheritedDocument.documentConfig.queryStringIdParam) {
        debugPrint("Correct the colliding queryStringIdParam properties");
        _queryStringIdParam = "child${toBeginningOfSentenceCase(parentInheritedDocument.documentConfig.queryStringIdParam)}";
      }
      _embeddedDocument = true;
      debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
      debugPrint("*-* INIT EMBEDDED DOCUMENTSCREEN  *-*");
      debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
    } else {
      debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*");
      debugPrint("*-* INIT DOCUMENTSCREEN *-*");
      debugPrint("*-*-*-*-*-*-*-*-*-*-*-*-*-*");
    }
    return InheritedDocument(
      child: DocumentLoader<T>(),
      documentConfig: DocumentConfig<T>(
        collection: collection,
        documentList: documentList,
        queryStringIdParam: _queryStringIdParam ?? queryStringIdParam,
        createNew: createNew,
        createDocumentId: createDocumentId,
        document: document,
        toFirestore: toFirestore,
        fromFirestore: fromFirestore,
        extraActionButtons: extraActionButtons,
        titleBuilder: titleBuilder as TitleBuilder<T>,
        contextCardBuilders: contextCardBuilders,
        embeddedDocument: _embeddedDocument ?? false,
      ),
    );
  }
}

class InheritedDocument extends InheritedWidget {
  InheritedDocument({Key? key, required this.documentConfig, required child}) : super(key: key, child: child);

  final DocumentConfig documentConfig;
  final SelectionState selectionState = SelectionState();
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

  load<T>({required String docId}) async {
    DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;

    DocumentSnapshot<T>? documentSnapshot = await DatabaseService<T>().documentSnapshot(
      collection: _documentConfig.collection,
      documentId: docId,
      fromFirestore: _documentConfig.fromFirestore,
      toFirestore: _documentConfig.toFirestore,
    );

    if (documentSnapshot?.exists ?? false) {
      selectionState.state = SelectionState(data: documentSnapshot!.data(), docId: docId);
    }
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

class DocumentLoader<T> extends ConsumerWidget {
  const DocumentLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;

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

class ScreenBody<T> extends ConsumerStatefulWidget {
  const ScreenBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScreenBodyState<T>();
}

class _ScreenBodyState<T> extends ConsumerState<ScreenBody> {
  @override
  Widget build(BuildContext context) {
    QueryState queryState = ref.watch(queryStateProvider);
    Widget returnWidget = queryState.queryString.isEmpty ? FRouter.of(context).emptyPage : DocumentBody<T>(key: ValueKey(queryState.queryString), queryState: queryState);

    InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    if (queryState.queryParameters == null) {
      //Cannot contain a form
      return FRouter.of(context).emptyPage;
    } else if (!queryState.queryParameters!.containsKey(inheritedDocument.documentConfig.queryStringIdParam)) {
      return FRouter.of(context).emptyPage;
    } else if (((inheritedDocument.selectionState.docId != queryState.queryParameters?[inheritedDocument.documentConfig.queryStringIdParam]) || (inheritedDocument.selectionState.data == null && queryState.queryParameters != null))) {
      inheritedDocument.selectionState.addListener(() {
        debugPrint("Our document has arrived");
        inheritedDocument.selectionState.removeListener(() {});
        setState(() {});
      });
      inheritedDocument.load<T>(docId: queryState.queryParameters![inheritedDocument.documentConfig.queryStringIdParam]!);
      return FRouter.of(context).waitPage;
    }

    // return returnWidget;
    return AnimatedSwitcher(
      key: ValueKey("query_${widget.key.toString()}"),
      duration: const Duration(milliseconds: 250),
      child: returnWidget,
    );
  }
}
