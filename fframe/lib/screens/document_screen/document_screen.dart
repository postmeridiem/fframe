part of fframe;

class DocumentScreen<T> extends StatelessWidget {
  DocumentScreen({
    Key? key,
    // required this.formKey,
    required this.collection,
    required this.createNew,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.documentList,
    // this.documentBuilder,
    this.titleBuilder,
    required this.document,
    this.extraActionButtons,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
  }) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DocumentList<T>? documentList;
  // final DocumentBuilder<T>? documentBuilder;
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
        _queryStringIdParam = "child${toBeginningOfSentenceCase(parentInheritedDocument.documentConfig.queryStringIdParam)}";
      }
      _embeddedDocument = true;
    }
    return Form(
      key: formKey,
      child: InheritedDocument(
        // key:
        child: DocumentLoader<T>(
          key: ValueKey("DocumentLoader_$collection"),
        ),
        documentConfig: DocumentConfig<T>(
          formKey: formKey,
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

  _snackbar({required BuildContext context, required String text, Icon? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: kBottomNavigationBarHeight,
          left: MediaQuery.of(context).size.width / 4,
          right: MediaQuery.of(context).size.width / 4,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon ?? const IgnorePointer(),
            Text(text),
            if (icon != null) const IgnorePointer(),
          ],
        ),
      ),
    );
  }

  toggleReadOnly<T>({required BuildContext context}) {
    selectionState.setState(SelectionState<T>(data: selectionState.data!, docId: selectionState.docId, isNew: false, readOnly: !selectionState.readOnly), notify: true);
  }

  delete<T>({required BuildContext context}) async {
    if (await (confirmationDialog(
            context: context,
            cancelText: L10n.string(
              "iconbutton_document_delete_cancel",
              placeholder: "Cancel",
            ),
            continueText: L10n.string(
              "iconbutton_document_delete_continue",
              placeholder: "Continue",
            ),
            titleText: L10n.string(
              "iconbutton_document_delete_title",
              placeholder: "Delete this document",
            ),
            child: SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.warning,
                      color: Colors.red.shade900,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10n.string(
                          "iconbutton_document_delete1",
                          placeholder: "Delete this document?",
                        ),
                      ),
                      Text(
                        L10n.string(
                          "iconbutton_document_delete2",
                          placeholder: "This operation cannot be undone.",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))) ==
        true) {
      DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;
      SaveState saveResult = await DatabaseService<T>().deleteDocument(
        collection: documentConfig.collection,
        documentId: selectionState.docId!,
        data: selectionState.data!,
        fromFirestore: _documentConfig.fromFirestore,
        toFirestore: _documentConfig.toFirestore,
      );
      if (saveResult.result == true) {
        //Close the document
        FRouter.of(context).updateQueryString(queryParameters: {}, resetQueryString: true);
      } else {
        //show the error
        _snackbar(
          context: context,
          text: saveResult.errorMessage!,
          icon: Icon(
            Icons.error,
            color: Colors.red.shade900,
          ),
        );
      }
    }
  }

  close<T>({required BuildContext context, bool skipWarning = false}) async {
    if (selectionState.readOnly == true || skipWarning == true) {
      selectionState.setState(SelectionState<T>(data: null, docId: null, isNew: false, readOnly: false));
      FRouter.of(context).updateQueryString(queryParameters: {}, resetQueryString: true);
      return;
    }
    FRouter.of(context).updateQueryString(queryParameters: {}, resetQueryString: true);
    return;
    //TODO: reenable warning;
    if (await (confirmationDialog(
            context: context,
            cancelText: L10n.string(
              "iconbutton_document_close_cancel",
              placeholder: "Cancel",
            ),
            continueText: L10n.string(
              "iconbutton_document_close_continue",
              placeholder: "Continue",
            ),
            titleText: L10n.string(
              "iconbutton_document_close_title",
              placeholder: "Close this document",
            ),
            child: SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.question_mark,
                      color: Colors.yellowAccent.shade200,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10n.string(
                          "iconbutton_document_close1",
                          placeholder: "Close this document?",
                        ),
                      ),
                      Text(
                        L10n.string(
                          "iconbutton_document_close2",
                          placeholder: "Any changes made to the document will be lost.",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))) ==
        true) {
      selectionState.setState(SelectionState<T>(data: null, docId: null, isNew: false, readOnly: false));
      FRouter.of(context).updateQueryString(queryParameters: {}, resetQueryString: true);
    }
  }

  // ignore: unused_element
  copy<T>({required BuildContext context}) {
    selectionState.setState(SelectionState<T>(data: selectionState.data!, docId: "copy", isNew: true, readOnly: false));
    FRouter.of(context).updateQueryString(queryParameters: {documentConfig.queryStringIdParam: selectionState.docId!}, resetQueryString: selectionState.isNew);
  }

  create<T>({required BuildContext context}) {
    //Clear the cache
    selectionState.setState(SelectionState<T>(data: null, docId: null, isNew: false, readOnly: false));
    if (documentConfig.document.tabs.length == 1) {
      FRouter.of(context).updateQueryString<T>(queryParameters: {"new": "true"}, resetQueryString: true);
    } else {
      FRouter.of(context).updateQueryString<T>(queryParameters: {"new": "true", "tabIndex": "0"}, resetQueryString: true);
    }
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
      selectionState.setState(SelectionState(data: documentSnapshot!.data(), docId: docId));
    }
  }

  save<T>({required BuildContext context}) async {
    if (validate<T>(context: context)) {
      DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;
      String? docId = selectionState.docId;
      if (docId == null || selectionState.isNew == true) {
        if (_documentConfig.createDocumentId != null) {
          docId = _documentConfig.createDocumentId!(selectionState.data!);
        } else {
          docId = const Uuid().v4();
        }
      }
      debugPrint("Save item $docId in collection ${_documentConfig.collection}");

      SaveState saveResult = selectionState.isNew
          ? await DatabaseService<T>().createDocument(
              collection: documentConfig.collection,
              documentId: docId!,
              data: selectionState.data!,
              fromFirestore: _documentConfig.fromFirestore,
              toFirestore: _documentConfig.toFirestore,
            )
          : await DatabaseService<T>().updateDocument(
              collection: documentConfig.collection,
              documentId: docId!,
              data: selectionState.data!,
              fromFirestore: _documentConfig.fromFirestore,
              toFirestore: _documentConfig.toFirestore,
            );

      if (saveResult.result) {
        //Success
        debugPrint("Save was successfull");
        close(context: context, skipWarning: true);
      } else {
        debugPrint("Save failed");

        _snackbar(
          context: context,
          text: saveResult.errorMessage!,
          icon: Icon(
            Icons.error,
            color: Colors.red.shade900,
          ),
        );
      }
    }
  }

  bool validate<T>({required BuildContext context, bool showPopup = false}) {
    DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;
    if (_documentConfig.formKey.currentState!.validate()) {
      if (showPopup) {
        _snackbar(
          context: context,
          text: L10n.string(
            'validator_success',
            placeholder: "Form is valid",
          ),
          icon: Icon(
            Icons.check,
            color: Colors.green.shade900,
          ),
        );
      }
      return true;
    } else {
      if (showPopup) {
        _snackbar(
          context: context,
          text: L10n.string(
            'validator_failed',
            placeholder: "Form is invalid, please update highlighted fields.",
          ),
          icon: Icon(
            Icons.close,
            color: Colors.red.shade900,
          ),
        );
      }
      return false;
    }
  }

  List<IconButton>? iconButtons<T>(BuildContext context) {
    List<IconButton>? iconButtons = [
      IconButton(
        tooltip: L10n.string(
          "iconbutton_document_close",
          placeholder: "Close this document",
        ),
        icon: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () {
          close<T>(context: context);
        },
      ),
      if (!selectionState.isNew && selectionState.readOnly == true && documentConfig.document.showEditToggleButton == true)
        IconButton(
          tooltip: L10n.string(
            "iconbutton_document_edit",
            placeholder: "Edit this document",
          ),
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            toggleReadOnly<T>(context: context);
          },
        ),
      if (!selectionState.isNew)
        IconButton(
          tooltip: L10n.string(
            "iconbutton_document_delete",
            placeholder: "Delete this document",
          ),
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            delete<T>(context: context);
          },
        ),
      if (!selectionState.isNew)
        IconButton(
          tooltip: L10n.string(
            "iconbutton_document_copy",
            placeholder: "Copy this document",
          ),
          icon: Icon(
            Icons.copy_outlined,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            copy<T>(context: context);
          },
        ),
      if (!selectionState.readOnly)
        IconButton(
          tooltip: L10n.string(
            "iconbutton_document_validate",
            placeholder: "Validate this document",
          ),
          icon: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            validate<T>(context: context, showPopup: true);
            // validate();
          },
        ),
      if (!selectionState.readOnly)
        IconButton(
          tooltip: L10n.string(
            "iconbutton_document_save",
            placeholder: "Save this document",
          ),
          icon: Icon(
            Icons.save,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            save<T>(context: context);
            // validate();
          },
        ),
      // IconButton(
      //   tooltip: L10n.string(
      //     "iconbutton_document_new",
      //     placeholder: "Create new document",
      //   ),
      //   icon: Icon(
      //     Icons.add,
      //     color: Theme.of(context).colorScheme.onBackground,
      //   ),
      //   onPressed: () {
      //     create<T>(context: context);
      //     // validate();
      //   },
      // ),
    ];

    //Add any extra configured buttons to the list
    if (documentConfig.extraActionButtons != null) {
      iconButtons.addAll(documentConfig.extraActionButtons!);
    }
    return iconButtons;
  }
}

class DocumentLoader<T> extends ConsumerWidget {
  const DocumentLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("build DocumentLoader: ${key.toString()}");
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;

    //  (queryParameters != null || (queryParameters == null && queryParameters!.isNotEmpty)));

    return Row(
      children: [
        if (documentConfig.documentList != null)
          DocumentListLoader<T>(
            key: ValueKey("DocumentListBuilder_${documentConfig.collection}"),
            ref: ref,
          ),
        Expanded(
          child: ScreenBody<T>(
            key: ValueKey("ScreenBody_${documentConfig.collection}"),
          ),
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
    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 400)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    debugPrint("build screenBodyState ${widget.key.toString()}");
    QueryState queryState = ref.watch(queryStateProvider);
    Widget returnWidget = queryState.queryString.isEmpty
        ? (screenSize == ScreenSize.phone)
            ? const IgnorePointer()
            : FRouter.of(context).emptyPage()
        : DocumentBodyLoader<T>(key: ValueKey(queryState.queryString), queryState: queryState);

    InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    if (queryState.queryParameters == null) {
      //Cannot contain a form
      return (screenSize == ScreenSize.phone) ? const IgnorePointer() : FRouter.of(context).emptyPage();
    } else if (inheritedDocument.selectionState.data == null && inheritedDocument.selectionState.isNew == false && queryState.queryParameters!.containsKey("new") && queryState.queryParameters!["new"] == "true") {
      debugPrint("Spawn a new document");
      inheritedDocument.selectionState.setState(SelectionState<T>(data: inheritedDocument.documentConfig.createNew(), docId: "new", isNew: true, readOnly: false));
    } else if (inheritedDocument.selectionState.data is T && queryState.queryParameters!.containsKey("new") && queryState.queryParameters!["new"] == "true") {
      debugPrint("Spawn new document from cache");
      return returnWidget;
    } else if (!queryState.queryParameters!.containsKey(inheritedDocument.documentConfig.queryStringIdParam)) {
      return (screenSize == ScreenSize.phone) ? const IgnorePointer() : FRouter.of(context).emptyPage();
    } else if (((inheritedDocument.selectionState.docId != queryState.queryParameters?[inheritedDocument.documentConfig.queryStringIdParam]) || (inheritedDocument.selectionState.data == null && queryState.queryParameters != null))) {
      inheritedDocument.selectionState.addListener(() {
        debugPrint("Our document has arrived");
        inheritedDocument.selectionState.removeListener(() {});
        setState(() {});
      });
      inheritedDocument.load(docId: queryState.queryParameters![inheritedDocument.documentConfig.queryStringIdParam]!);
      return FRouter.of(context).waitPage(context: context, text: "Loading document");
    }

    // return returnWidget;
    return AnimatedSwitcher(
      key: ValueKey("query_${widget.key.toString()}"),
      duration: const Duration(milliseconds: 250),
      child: returnWidget,
    );
  }
}
