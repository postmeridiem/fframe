part of fframe;

class DocumentScreen<T> extends StatelessWidget {
  DocumentScreen({
    Key? key,
    required this.collection,
    required this.createNew,
    this.preSave,
    this.postOpen,
    this.postRefresh,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.documentList,
    this.autoSelectFirst = false,
    this.query,
    this.searchConfig,
    this.titleBuilder,
    required this.document,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
    this.documentScreenHeaderBuilder,
    this.documentScreenFooterBuilder,
  }) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DocumentList<T>? documentList;
  final Query<T> Function(Query<T> query)? query;
  final SearchConfig<T>? searchConfig;
  final TitleBuilder<T>? titleBuilder;
  final Document<T> document;
  final String queryStringIdParam;
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final T Function() createNew;
  final T Function(T)? preSave;
  final T Function(T)? postOpen;
  final T Function(T)? postRefresh;
  final bool autoSelectFirst;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;
  final DocumentScreenHeaderBuilder? documentScreenHeaderBuilder;
  final DocumentScreenFooterBuilder? documentScreenFooterBuilder;

  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig? parentDocumentScreenConfig = DocumentScreenConfig.of(context);
    String? _queryStringIdParam;
    bool? _embeddedDocument;
    if (parentDocumentScreenConfig != null) {
      debugPrint("This is an embedded instance of the DocumentScreen initalize FormCeption");
      if (queryStringIdParam == parentDocumentScreenConfig.documentConfig.queryStringIdParam) {
        _queryStringIdParam = "child${toBeginningOfSentenceCase(parentDocumentScreenConfig.documentConfig.queryStringIdParam)}";
      }
      _embeddedDocument = true;
    }
    return Column(
      children: [
        if (documentScreenHeaderBuilder != null) documentScreenHeaderBuilder!(),
        Expanded(
          child: Form(
            key: formKey,
            child: DocumentScreenConfig(
              child: DocumentLoader<T>(
                key: ValueKey("DocumentLoader_$collection"),
              ),
              fireStoreQueryState: FireStoreQueryState<T>(
                collection: collection,
                fromFirestore: fromFirestore,
                initialQuery: query,
                listQuery: documentList?.queryBuilder,
              ),
              selectionState: SelectionState<T>(),
              documentConfig: DocumentConfig<T>(
                formKey: formKey,
                collection: collection,
                documentList: documentList,
                autoSelectFirst: autoSelectFirst,
                queryStringIdParam: _queryStringIdParam ?? queryStringIdParam,
                createNew: createNew,
                createDocumentId: createDocumentId,
                preSave: preSave,
                document: document,
                toFirestore: toFirestore,
                fromFirestore: fromFirestore,
                query: query,
                searchConfig: searchConfig,
                titleBuilder: titleBuilder as TitleBuilder<T>,
                contextCardBuilders: contextCardBuilders,
                embeddedDocument: _embeddedDocument ?? false,
              ),
            ),
          ),
        ),
        if (documentScreenFooterBuilder != null) documentScreenFooterBuilder!(),
      ],
    );
  }
}

//  =
class DocumentScreenConfig extends InheritedModel<DocumentScreenConfig> {
  const DocumentScreenConfig({
    Key? key,
    required this.documentConfig,
    required this.fireStoreQueryState,
    required this.selectionState,
    required child,
  }) : super(key: key, child: child);

  final DocumentConfig documentConfig;
  final SelectionState selectionState;
  final FireStoreQueryState fireStoreQueryState;
  static DocumentScreenConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DocumentScreenConfig>();
  }

  @override
  bool updateShouldNotify(DocumentScreenConfig oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(DocumentScreenConfig oldWidget, Set<DocumentScreenConfig> dependencies) {
    return true;
  }

  snackbar({required BuildContext context, required String text, Icon? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: kBottomNavigationBarHeight,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
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

  bool get isNew => selectionState.isNew;

  selectDocument<T>(BuildContext context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
    bool embeddedDocument = documentConfig.embeddedDocument;
    String tabIndexKey = embeddedDocument ? "childTabIndex" : "tabIndex";
    selectionState.setState(SelectionState<T>(docId: queryDocumentSnapshot.id, data: queryDocumentSnapshot.data()));
    if (documentConfig.document.activeTabs == null || documentConfig.document.activeTabs!.length == 1) {
      FRouter.of(context).updateQueryString<T>(queryParameters: {documentConfig.queryStringIdParam: queryDocumentSnapshot.id}, resetQueryString: !embeddedDocument);
    } else {
      FRouter.of(context).updateQueryString<T>(queryParameters: {documentConfig.queryStringIdParam: queryDocumentSnapshot.id, tabIndexKey: "0"}, resetQueryString: !embeddedDocument);
    }
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
                      color: Theme.of(context).errorColor,
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
        fromFirestore: _documentConfig.fromFirestore,
        toFirestore: _documentConfig.toFirestore,
      );
      if (saveResult.result == true) {
        //Close the document
        FRouter.of(context).updateQueryString(queryParameters: {}, resetQueryString: true);
      } else {
        //show the error
        snackbar(
          context: context,
          text: saveResult.errorMessage!,
          icon: Icon(
            Icons.error,
            color: Theme.of(context).errorColor,
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
    if (documentConfig.document.activeTabs!.length == 1) {
      FRouter.of(context).updateQueryString<T>(queryParameters: {"new": "true"}, resetQueryString: true);
    } else {
      FRouter.of(context).updateQueryString<T>(queryParameters: {"new": "true", "tabIndex": "0"}, resetQueryString: true);
    }
  }

  load<T>({required BuildContext context, required String docId}) async {
    try {
      DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;

      DocumentSnapshot<T>? documentSnapshot = await DatabaseService<T>().documentSnapshot(
        collection: _documentConfig.collection,
        documentId: docId,
        fromFirestore: _documentConfig.fromFirestore,
        toFirestore: _documentConfig.toFirestore,
      );

      if (documentSnapshot?.exists ?? false) {
        debugPrint("Loaded document $docId to selectionState and notify");
        selectionState.setState(
          SelectionState<T>(
            data: documentSnapshot!.data(),
            docId: docId,
          ),
          notify: true,
        );
      } else {
        debugPrint("Document does not exist");
        FRouter.of(context).updateQueryString(
          queryParameters: {},
          resetQueryString: true,
        );
        snackbar(
          context: context,
          text: "Referenced document could not be loaded: $docId",
          icon: Icon(
            Icons.error,
            color: Theme.of(context).errorColor,
          ),
        );
      }
    } catch (e) {
      snackbar(
        context: context,
        text: "Referenced document could not be loaded: $docId \n ${e.toString()}",
        icon: Icon(
          Icons.error,
          color: Theme.of(context).errorColor,
        ),
      );
    }
  }

  save<T>({required BuildContext context, bool closeAfterSave = true}) async {
    if (validate<T>(context: context, moveToTab: true) == -1) {
      DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;
      String? docId = selectionState.docId;
      if (docId == null || selectionState.isNew == true) {
        if (_documentConfig.createDocumentId != null) {
          docId = _documentConfig.createDocumentId!(selectionState.data!);
        } else {
          docId = const Uuid().v4();
        }
      }

      //optional presave script
      if (_documentConfig.preSave != null) {
        selectionState.data = _documentConfig.preSave!(selectionState.data!);
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
        // if (FRouter.of(context).isQueryStringEmpty && documentConfig.autoSelectFirst == true) {
        //   //Do not unload the current document, the autoload should pick it up
        //   return;
        // }
        if (closeAfterSave) {
          close<T>(context: context, skipWarning: true);
        }
      } else {
        debugPrint("Save failed");

        snackbar(
          context: context,
          text: saveResult.errorMessage!,
          icon: Icon(
            Icons.error,
            color: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }

  int validate<T>({required BuildContext context, bool showPopup = false, bool moveToTab = false}) {
    DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;

    int invalidTab = _documentConfig.document.activeTabs!
        .map((DocumentTab tab) {
          bool result = tab.formKey.currentState!.validate();
          debugPrint("tab validation: $result");
          return tab.formKey.currentState!.validate();
        })
        .toList()
        .indexWhere((bool validationResult) => validationResult == false);
    // .toDouble();
    if (invalidTab == -1) {
      if (showPopup) {
        snackbar(
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
    } else {
      if (_documentConfig.tabController.index != invalidTab || moveToTab) {
        _documentConfig.tabController.animateTo(invalidTab);
        // _documentConfig.preloadPageController.animateTo(invalidTab, duration: const Duration(microseconds: 250), curve: Curves.easeOutCirc);
      }
    }
    return invalidTab.toInt();
  }

  List<IconButton>? iconButtons<T>(BuildContext context) {
    DocumentConfig<T> _documentConfig = documentConfig as DocumentConfig<T>;
    Document<T> document = _documentConfig.document;
    SelectionState<T> selectionState = DocumentScreenConfig.of(context)!.selectionState as SelectionState<T>;
    List<IconButton>? iconButtons = [];

    if (document.showCloseButton) {
      iconButtons.add(
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
      );
    }

    if (!selectionState.isNew) {
      if (document.showDeleteButton) {
        iconButtons.add(
          IconButton(
            tooltip: L10n.string(
              "iconbutton_document_delete",
              placeholder: "Delete this document",
            ),
            icon: Icon(
              Icons.delete_forever,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              copy<T>(context: context);
            },
          ),
        );
      }
      if (document.showCopyButton) {
        iconButtons.add(
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
        );
      }
      if (selectionState.readOnly == true && document.showEditToggleButton) {
        iconButtons.add(
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
        );
      }
    }

    if (selectionState.readOnly == false) {
      if (document.showValidateButton) {
        iconButtons.add(
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
        );
      }
      if (document.showSaveButton) {
        iconButtons.add(
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
        );
      }
    }
    return iconButtons;
  }
}

class DocumentLoader<T> extends ConsumerWidget {
  const DocumentLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("build DocumentLoader: ${key.toString()}");
    DocumentConfig<T> documentConfig = DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;

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
  QueryDocumentSnapshot<dynamic>? firstDoc;
  bool building = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build _ScreenBodyState");
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    if (firstDoc != null) {
      debugPrint("First doc");
    }

    if (documentScreenConfig.documentConfig.autoSelectFirst) {
      debugPrint("autoSelectFirst");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        postLoad(documentScreenConfig: documentScreenConfig);
      });
    }

    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 599)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    debugPrint("build screenBodyState ${widget.key.toString()}");
    // List<QueryDocumentSnapshot<dynamic>>? queryDocumentSnapshots = ref.watch(queryBuilderStateProvider).queryBuilderSnapshot?.docs;
    QueryState queryState = ref.watch(queryStateProvider);

    Widget returnWidget = queryState.queryString.isEmpty
        ? (screenSize == ScreenSize.phone)
            ? const IgnorePointer()
            : FRouter.of(context).emptyPage()
        : DocumentBodyLoader<T>(
            key: ValueKey(queryState.queryString),
          );

    //Handle document loads...

    // debugPrint("Read ${queryDocumentSnapshots?.length} docs from provider");
    if (queryState.queryParameters == null && documentScreenConfig.documentConfig.autoSelectFirst) {
      returnWidget = AutoFirstDocumentLoader<T>(
        documentConfig: DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>,
      );
    } else if (queryState.queryParameters == null) {
      returnWidget = (screenSize == ScreenSize.phone) ? const IgnorePointer() : FRouter.of(context).emptyPage();
    } else if (documentScreenConfig.selectionState.data == null && documentScreenConfig.selectionState.isNew == false && queryState.queryParameters!.containsKey("new") && queryState.queryParameters!["new"] == "true") {
      debugPrint("Spawn a new document");
      documentScreenConfig.selectionState.setState(SelectionState<T>(data: documentScreenConfig.documentConfig.createNew(), docId: "new", isNew: true, readOnly: false));
    } else if (documentScreenConfig.selectionState.data is T && queryState.queryParameters!.containsKey("new") && queryState.queryParameters!["new"] == "true") {
      debugPrint("Spawn new document from cache");
      // return returnWidget;
    } else if (!queryState.queryParameters!.containsKey(documentScreenConfig.documentConfig.queryStringIdParam)) {
      returnWidget = (screenSize == ScreenSize.phone) ? const IgnorePointer() : FRouter.of(context).emptyPage();
    } else if (((documentScreenConfig.selectionState.docId != queryState.queryParameters?[documentScreenConfig.documentConfig.queryStringIdParam]) || (documentScreenConfig.selectionState.data == null && queryState.queryParameters != null))) {
      documentScreenConfig.selectionState.addListener(() {
        documentScreenConfig.selectionState.removeListener(() {});
        setState(() {});
      });
      documentScreenConfig.load<T>(context: context, docId: queryState.queryParameters![documentScreenConfig.documentConfig.queryStringIdParam]!);
      returnWidget = FRouter.of(context).waitPage(context: context, text: "Loading document");
    }

    debugPrint("Load the AnimatedSwitcher ");
    // postLoad(ref: ref, documentScreenConfig: documentScreenConfig);
    return AnimatedSwitcher(
      key: ValueKey("query_${widget.key.toString()}"),
      duration: const Duration(milliseconds: 5),
      child: returnWidget,
    );
  }

  postLoad({required DocumentScreenConfig documentScreenConfig}) async {
    debugPrint("PostLoad");
  }
}

class AutoFirstDocumentLoader<T> extends StatefulWidget {
  const AutoFirstDocumentLoader({
    Key? key,
    required this.documentConfig,
  }) : super(key: key);

  final DocumentConfig<T> documentConfig; // = DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;

  @override
  State<AutoFirstDocumentLoader> createState() => _AutoFirstDocumentLoaderState<T>();
}

class _AutoFirstDocumentLoaderState<T> extends State<AutoFirstDocumentLoader<T>> {
  @override
  Widget build(BuildContext context) {
    Query<T> query = DocumentScreenConfig.of(context)!.fireStoreQueryState.currentQuery() as Query<T>;
    return StreamBuilder<QuerySnapshot<T>>(
      stream: query.snapshots(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<T>> querySnapshot) {
        switch (querySnapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            return FRouter.of(context).waitPage(context: context, text: "Loading first document");
          case ConnectionState.active:
            if (querySnapshot.hasData && querySnapshot.data != null && querySnapshot.data!.docs.isNotEmpty) {
              QueryDocumentSnapshot<T> queryDocumentSnapshot = querySnapshot.data!.docs.first;
              SelectionState<T> selectionState = DocumentScreenConfig.of(context)!.selectionState as SelectionState<T>;
              selectionState.setState(SelectionState<T>(
                data: queryDocumentSnapshot.data(),
                docId: queryDocumentSnapshot.id,
                isNew: false,
              ));
              return DocumentBodyLoader<T>(
                key: ValueKey(queryDocumentSnapshot.id),
              );
            }

            return FRouter.of(context).emptyPage();
        }
      },
    );
  }
}
