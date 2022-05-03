part of fframe;

class DocumentScreen<T> extends ConsumerStatefulWidget {
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
  }) : super(key: key);

  /// this is a fFrame Document Screen
  /// we have not documented this yet
  /// we failed to document succesfully, one might say.
  /// the [documentList] should have things and the
  /// [documentBuilder] is picky in other ways.
  ///
  /// don't forget the [document]!

  final DocumentList<T>? documentList;
  final DocumentBuilder<T>? documentBuilder;
  final TitleBuilder<T>? titleBuilder;
  final Document document;
  final List<IconButton>? extraActionButtons;

  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
      fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final T Function() createNew;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;
  @override
  ConsumerState<DocumentScreen<T>> createState() => _DocumentScreenState<T>();
}

class _DocumentScreenState<T> extends ConsumerState<DocumentScreen<T>> {
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    //
    // UserState userState = ref.read(userStateNotifierProvider);
  }

  Future<void> lazyLoad(SelectionState selectionState) async {
    SelectionState selectionState = ref.read(selectionStateProvider).state;
    DocumentSnapshot<T>? documentSnapshot = await DatabaseService<T>()
        .documentSnapshot(
            collection: widget.collection,
            documentId: selectionState.queryParams!["id"]!,
            fromFirestore: widget.fromFirestore,
            toFirestore: widget.toFirestore);

    if (documentSnapshot != null) {
      selectionState = SelectionState(
        docId: selectionState.queryParams!["id"],
        data: documentSnapshot.data(),
        queryParams: selectionState.queryParams,
      );
    } else {
      debugPrint(
          "Unable to lazy load document ${selectionState.docId} from ${widget.collection}");
    }

    // if (!(await documentStream?.isEmpty ?? true)) {
    //   Future<DocumentSnapshot<T>> docFirst = documentStream!.first;
    //   docFirst.
    // }
    //  DocumentSnapshot<T> document =  .first();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuild DocumentScreen");
    SelectionState selectionState = ref.read(selectionStateProvider).state;

    // ignore: unused_element
    _callEditToggle() {}

    // ignore: unused_element
    _callDelete() {}

    _callClose() {
      ref.read(selectionStateProvider).state = SelectionState(
        docId: null,
        data: null,
        queryParams: null,
      );
    }

    // ignore: unused_element
    _callCopy() {}

    _callCreateNew() {
      ref.read(selectionStateProvider).state = SelectionState(
        docId: null,
        data: widget.createNew(),
        queryParams: null,
      );
    }

    Future<bool> _callSave() async {
      try {
        String? documentId = selectionState.docId;
        debugPrint("Save item $documentId in collection ${widget.collection}");
        if (widget.createDocumentId != null && selectionState.docId == null) {
          debugPrint("Request a new documentId");
          documentId = widget.createDocumentId!(selectionState.data);
        }
        documentId = documentId ?? const Uuid().v4();

        if (await DatabaseService<T>().updateData(
          collection: widget.collection,
          documentId: documentId,
          data: selectionState.data,
          fromFirestore: widget.fromFirestore,
          toFirestore: widget.toFirestore,
        )) {
          //Success
          debugPrint("Save was successfull ");
          return true;
        } else {
          debugPrint("Save failed");
          return false;
        } // Failed

      } catch (error) {
        debugPrint(error.toString());
      }
      return false;
    }

    _callValidate() async {
      debugPrint("callValidate");
      _DocumentCanvas<T>? _documentCanvas =
          selectionState.globalKey.currentWidget as _DocumentCanvas<T>?;
      if (_documentCanvas != null) {
        if (_documentCanvas.validateDocument() == true) {
          //Save this document
          if ((await _callSave()) == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Saved succesfully'),
            ));
            // callClose();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: ListTile(
                leading: Icon(
                  Icons.warning,
                  color: Colors.amberAccent,
                ),
                title: Text(
                  "Save failed succesfully",
                ),
                tileColor: Colors.redAccent,
              ),
            ));
          }
        }
      } else {
        debugPrint(selectionState.globalKey.currentWidget.toString());
      }
    }

    List<IconButton>? iconButtons = [
      IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.grey.shade400,
        ),
        onPressed: _callClose,
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
          color: Colors.grey.shade400,
        ),
        onPressed: _callValidate,
      ),
    ];

    //Add any extra configured buttons to the list
    if (widget.extraActionButtons != null) {
      iconButtons.addAll(widget.extraActionButtons!);
    }

    //Handle a case where a deeplink to a document comes in
    if (selectionState.data == null &&
        selectionState.queryParams?["id"] != null &&
        selectionState.docId != selectionState.queryParams!["id"]) {
      debugPrint("Lazy load the deeplinked document");
      lazyLoad(selectionState);
    }

    return CurvedBottomBar(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          elevation: 0.1,
          onPressed: _callCreateNew),
      iconButtons: iconButtons,
      child: Row(
        children: [
          if (widget.documentList != null)
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: const TextField(
                        autofocus: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: _DocumentList<T>(
                        key: ValueKey(widget.collection),
                        collection: widget.collection,
                        fromFirestore: widget.fromFirestore,
                        documentList: widget.documentList!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.documentList != null)
            const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _DocumentBody<T>(
              titleBuilder: widget.titleBuilder,
              document: widget.document,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentBody<T> extends ConsumerWidget {
  const _DocumentBody({
    Key? key,
    required this.document,
    this.titleBuilder,
  }) : super(key: key);
  final Document document;
  final TitleBuilder<T>? titleBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SelectionState selectionState = ref.watch(selectionStateProvider).state;
    debugPrint("Rebuild documentBody");

    return Scaffold(
      primary: false,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _DocumentCanvas<T>(
          key: selectionState.globalKey,
          document: document,
          selectionState: selectionState,
          titleBuilder: titleBuilder,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _DocumentCanvas<T> extends StatelessWidget {
  _DocumentCanvas({
    Key? key,
    this.titleBuilder,
    required this.selectionState,
    required this.document,
    // required this.callValidate,
  }) : super(key: key);

  final SelectionState selectionState;
  final TitleBuilder<T>? titleBuilder;
  final Document document;

  late PreloadPageController preloadPageController;

  bool validateDocument() {
    List<bool> validationResults = document.tabs.map((documentTab) {
      bool isValid = documentTab._formState.currentState!.validate();
      return isValid;
    }).toList();

    if (validationResults.contains(false)) {
      //Validation has failed
      int failedTab = validationResults
          .indexWhere((validationResult) => validationResult == false);
      preloadPageController.animateToPage(failedTab,
          duration: const Duration(microseconds: 100),
          curve: Curves.easeOutCirc);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectionState.data == null) {
      if (selectionState.docId != selectionState.queryParams?["id"]) {
        return const WaitScreen();
      }
      return const EmptyScreen();
    }

    return DefaultTabController(
      animationDuration: Duration.zero,
      length: document.tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          preloadPageController = PreloadPageController(initialPage: 0);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              debugPrint("Navigate to tab ${tabController.index}");
              preloadPageController.animateToPage(tabController.index,
                  duration: const Duration(microseconds: 100),
                  curve: Curves.easeOutCirc);
              // changePage(index: tabController.index, tabController: tabController, page: true);
            }
          });
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool collapsed = constraints.maxWidth > 1000;

              return Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: DefaultTabController(
                      length: document.tabs.length,
                      child: Scaffold(
                        endDrawer: (document.contextCards != null &&
                                document.contextCards!.isNotEmpty)
                            ? ContextCanvas(
                                contextWidgets: document.contextCards!
                                    .map(
                                      (contextCardBuilder) =>
                                          contextCardBuilder(
                                              selectionState.data),
                                    )
                                    .toList(),
                              )
                            : null,
                        primary: false,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        body: NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                actions: const [
                                  IgnorePointer()
                                ], //To surpess the hamburger
                                primary: false,
                                title: titleBuilder != null
                                    ? titleBuilder!(
                                        context, selectionState.data)
                                    : null,
                                floating: true,
                                pinned: false,
                                snap: true,
                                centerTitle: true,
                                automaticallyImplyLeading: false,
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                bottom: document.tabs.length != 1
                                    ? TabBar(
                                        controller: tabController,
                                        tabs: document.tabs
                                            .map(
                                              (documentTab) =>
                                                  documentTab.tabBuilder(),
                                            )
                                            .toList(),
                                      )
                                    : null,
                              ),
                            ];
                          },
                          body: PreloadPageView.builder(
                            itemCount: document.tabs.length,
                            preloadPagesCount: document.tabs.length,
                            itemBuilder: (BuildContext context, int position) {
                              debugPrint("Build tab $position");
                              //                       AnimatedSwitcher(
                              // duration: const Duration(milliseconds: 500),
                              return Form(
                                key: document.tabs[position]._formState,
                                child: Container(
                                  key: ObjectKey(selectionState.data),
                                  child: document.tabs[position]
                                      .childBuilder(selectionState.data),
                                ),
                              );
                            },
                            controller: preloadPageController,
                            onPageChanged: (int position) {
                              debugPrint('page changed to: $position');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (document.contextCards != null &&
                      document.contextCards!.isNotEmpty)
                    collapsed
                        ? SizedBox(
                            width: 250,
                            child: ContextCanvas(
                              contextWidgets: document.contextCards!
                                  .map(
                                    (contextCardBuilder) =>
                                        contextCardBuilder(selectionState.data),
                                  )
                                  .toList(),
                            ),
                          )
                        : DrawerButton(scaffoldKey: GlobalKey<ScaffoldState>()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class DrawerButton extends StatefulWidget {
  const DrawerButton({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<DrawerButton> createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.scaffoldKey.currentState != null &&
        widget.scaffoldKey.currentState!.hasEndDrawer) {
      return LimitedBox(
        maxWidth: 12,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(
              seconds: 2,
            ),
            child: widget.scaffoldKey.currentState!.isEndDrawerOpen
                ? IconButton(
                    onPressed: () => setState(
                      () => widget.scaffoldKey.currentState!.openDrawer(),
                    ),
                    icon: const Icon(Icons.arrow_forward_ios),
                    iconSize: 10,
                    splashRadius: 12,
                  )
                : IconButton(
                    onPressed: () => setState(
                      () => widget.scaffoldKey.currentState!.openEndDrawer(),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    iconSize: 10,
                    splashRadius: 12,
                  ),

            // ? const Icon(Icons.arrow_forward_ios) : const Icon(Icons.arrow_back_ios_new),
          ),
        ),
      );
    }
    return const IgnorePointer();
  }
}

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({Key? key, required this.contextWidgets})
      : super(key: key);
  final List<Widget> contextWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: contextWidgets,
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentTitle extends StatelessWidget {
  const DocumentTitle({Key? key, required, required this.title})
      : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _DocumentList<T> extends StatelessWidget {
  const _DocumentList({
    Key? key,
    required this.collection,
    required this.fromFirestore,
    required this.documentList,
  }) : super(key: key);
  final DocumentList<T> documentList;
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
      fromFirestore;

  @override
  Widget build(BuildContext context) {
    debugPrint("Build DocumentList $runtimeType ${key.toString()}");

    Query<T> query = DatabaseService<T>().query(
      collection: collection,
      fromFirestore: fromFirestore,
    );

    if (documentList.queryBuilder != null) {
      debugPrint("Apply query builder");
      query = documentList.queryBuilder!(query);
    }

    return FirestoreListView<T>(
      query: query,
      itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
        // return documentListBuilder(context, queryDocumentSnapshot);
        return _CardList(
          document: queryDocumentSnapshot,
          // notifier: notifier,
          documentListItemBuilder: documentList.builder,
        );
      },
      loadingBuilder: (context) => const WaitScreen(),
      errorBuilder: (context, error, stackTrace) =>
          ErrorScreen(error: Exception(error)),
    );
    // return Container(child: Text("_DocumentList: ${location}"));
  }
}

class _CardList<T> extends ConsumerWidget {
  const _CardList({
    required this.document,
    // required this.notifier,
    required this.documentListItemBuilder,
  });

  final QueryDocumentSnapshot<T> document;
  // final ValueNotifier<QueryDocumentSnapshot<T>?> notifier;
  final DocumentListItemBuilder<T> documentListItemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      return Card(
        child: GestureDetector(
          onTap: () {
            String documentPath = GoRouter.of(context).location;
            debugPrint("Update document to ${document.reference.path}");
            // SelectionState selectionState = ref.read(selectionStateProvider.notifier).state;
            ref.read(selectionStateProvider.notifier).state = SelectionState<T>(
                data: document.data(),
                queryParams: {"id": document.id},
                docId: document.id);
            documentPath = documentPath.split("?")[0];
            // GoRouter.of(context).go('$documentPath?id=${document.id}', extra: ref.read(selectionStateProvider.notifier).state); //Disables until we figure out how to prevent a full rebuild when changing the query-string
          },
          child: Consumer(builder: (context, ref, child) {
            String docId = ref.watch(selectionStateProvider).state.docId ?? '';
            try {
              return documentListItemBuilder(
                  context, docId == document.id, document.data());
            } catch (e) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.amberAccent),
                  subtitle: Text(
                      "Data Issue: ${e.toString()} in ${document.reference.path}"),
                ),
              );
            }
          }),
        ),
      );
    } catch (e) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.warning, color: Colors.amberAccent),
        ),
      );
    }
  }
}

typedef DocumentBuilder<T> = Widget Function(
  BuildContext context,
  DocumentReference<T> documentReference,
  T data,
);

typedef TitleBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);

typedef DocumentListItemBuilder<T> = Widget Function(
  BuildContext context,
  bool selected,
  T data,
);

typedef ContextCardBuilder<T> = Widget Function(
  T data,
);

typedef DocumentTabBuilder<T> = Widget Function();

typedef DocumentTabChildBuilder<T> = Widget Function(
    T data); //, AppUser appUser);

typedef DocumentStream<T> = Stream<DocumentSnapshot> Function(
  String? documentId,
);

class DocumentTab<T> {
  /// this is a fFrame Document Tab
  ///
  ///
  final DocumentTabBuilder<T> tabBuilder;
  final DocumentTabChildBuilder childBuilder;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  DocumentTab({
    required this.tabBuilder,
    required this.childBuilder,
  });
}

class Document<T> {
  Document({
    this.key,
    required this.tabs,
    this.contextCards,
    this.autoSave = false,
  });
  final Key? key;
  final List<DocumentTab> tabs;
  final List<ContextCardBuilder>? contextCards;
  bool autoSave;
}
