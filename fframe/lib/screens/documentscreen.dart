part of fframe;

class DocumentScreen<T> extends StatefulWidget {
  /// Creates a 1, 2 3 pane layout for easy access and layout for  Firestore data .
  ///
  /// The [length] argument is typically greater than one. The [length] must
  /// match [TabBar.tabs]'s and [TabBarView.children]'s length.
  ///
  /// The [initialIndex] argument must not be null.
  const DocumentScreen({
    Key? key,
    required this.collection,
    required this.createNew,
    required this.fromFirestore,
    required this.toFirestore,
    this.documentList,
    this.documentBuilder,
    this.titleBuilder,
    required this.document,
    this.extraActionButtons,
  }) : super(key: key);
  // final Query<T> query;

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
  final List<ActionButton>? extraActionButtons;

  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final T Function() createNew;

  @override
  State<DocumentScreen<T>> createState() => _DocumentScreenState<T>();
}

class _DocumentScreenState<T> extends State<DocumentScreen<T>> {
  @override
  Widget build(BuildContext context) {
    _DocumentBody<T> documentBody = _DocumentBody(
      collection: widget.collection,
      fromFirestore: widget.fromFirestore,
      toFirestore: widget.toFirestore,
      createNew: widget.createNew,
      extraActionButtons: widget.extraActionButtons,
      titleBuilder: widget.titleBuilder,
      document: widget.document,
    );

    //Check if a documentList is to be loaded
    if (widget.documentList != null) {
      return Row(
        children: [
          SizedBox(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: _DocumentList<T>(
                collection: widget.collection,
                fromFirestore: widget.fromFirestore,
                toFirestore: widget.toFirestore,
                documentList: widget.documentList!,
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: documentBody,
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: documentBody,
      );
    }
  }
}

class _DocumentBody<T> extends ConsumerWidget {
  const _DocumentBody({
    Key? key,
    required this.collection,
    required this.fromFirestore,
    required this.toFirestore,
    this.titleBuilder,
    this.extraActionButtons,
    required this.document,
    this.contextCardBuilders,
    required this.createNew,
    this.createDocumentId,
  }) : super(key: key);
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final T Function() createNew;
  final String? Function(T)? createDocumentId;
  final TitleBuilder<T>? titleBuilder;
  final List<ActionButton>? extraActionButtons;
  final Document document;
  final List<ContextCardBuilder>? contextCardBuilders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      NavigationStateNotifier navigationState = ref.watch(navigationStateProvider);
      UserState userState = ref.watch(userStateNotifierProvider);

      _callClose() {
        navigationState.selectionState = SelectionState(
          data: null,
          queryParams: null,
          queryDocumentSnapshot: null,
        );
      }

      _callCreateNew() {
        navigationState.selectionState = SelectionState(
          data: createNew(),
          queryParams: null,
          queryDocumentSnapshot: null,
        );
      }

      Future<bool> _callSave(String? documentId, T data) async {
        try {
          if (createDocumentId != null) {
            debugPrint("Request a new documentId");
            documentId = createDocumentId!(data);
          }
          documentId = documentId ?? const Uuid().v4();

          if (await DatabaseService<T>().updateData(
            collection: collection,
            documentId: documentId,
            data: data,
            fromFirestore: fromFirestore,
            toFirestore: toFirestore,
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

      Map<String, String>? queryParams = navigationState.selectionState.queryParams;
      T? data = navigationState.selectionState.data;
      if (data != null) {
        //Return injected type

        return Scaffold(
          primary: false,
          body: DocumentCanvas<T>(
            key: ObjectKey(data),
            titleBuilder: titleBuilder,
            data: data,
            userState: userState,
            collection: collection,
            // documentSnapshot: null,
            document: document,
            extraActionButtons: extraActionButtons,
            toFirestore: toFirestore,
            fromFirestore: fromFirestore,
            callCreateNew: _callCreateNew,
            callClose: _callClose,
            callSave: _callSave,
          ),
        );
      } else if ((queryParams != null && queryParams.containsKey("id"))) {
        return StreamBuilder<DocumentSnapshot<T>>(
          stream: DatabaseService<T>().documentStream(
            collection: collection,
            documentId: queryParams['id']!,
            fromFirestore: fromFirestore,
            toFirestore: toFirestore,
          ),
          builder: (context, AsyncSnapshot<DocumentSnapshot<T>> asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.none:
                return const EmptyScreen();
              case ConnectionState.waiting:
                return const WaitScreen();
              case ConnectionState.active:
              case ConnectionState.done:
                if (asyncSnapshot.hasError) return ErrorScreen(error: Exception(asyncSnapshot.error));
                if (!asyncSnapshot.hasData) return const WaitScreen();
                debugPrint("Load DocumentCanvas");

                try {
                  // T? snapshotData = asyncSnapshot.data!.data();
                  DocumentSnapshot<T>? snapshotData = asyncSnapshot.data;

                  if (snapshotData != null) {
                    return Scaffold(
                      primary: false,
                      body: DocumentCanvas<T>(
                        key: ObjectKey(data),
                        titleBuilder: titleBuilder,
                        data: snapshotData.data()!,
                        userState: userState,
                        collection: collection,
                        documentId: queryParams['id']!,
                        document: document,
                        extraActionButtons: extraActionButtons,
                        toFirestore: toFirestore,
                        fromFirestore: fromFirestore,
                        callCreateNew: _callCreateNew,
                        callClose: _callClose,
                        callSave: _callSave,
                      ),
                    );
                  } else {
                    return ErrorScreen(
                      error: Exception("Unable to convert documentdata to modeldata."),
                    );
                  }
                } catch (e) {
                  return ErrorScreen(
                    error: Exception("${e.toString()} in ${asyncSnapshot.data?.reference.path ?? 'unknowmn path'} ${{asyncSnapshot.data?.reference}}"),
                    // externalLocation: "https://console.firebase.google.com/project/${asyncSnapshot.data?.reference.firestore.app.name}/firestore/data/~2Fusers~2F1U1O47tW48W5K5PpEXWc1QRRWxt1",
                  );
                }
            }
          },
        );
      }
      return const EmptyScreen();
    } catch (e) {
      return ErrorScreen(
        error: Exception(e.toString()),
      );
    }
  }
}

class DocumentCanvas<T> extends StatelessWidget {
  DocumentCanvas({
    Key? key,
    this.titleBuilder,
    required this.data,
    required this.userState,
    this.documentId,
    required this.document,
    required this.collection,
    required this.fromFirestore,
    required this.toFirestore,
    this.extraActionButtons,
    required this.callCreateNew,
    required this.callClose,
    required this.callSave,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final String? documentId;
  final T data;
  final String collection;
  final UserState userState;
  final TitleBuilder<T>? titleBuilder;
  final List<ActionButton>? extraActionButtons;
  final Document document;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final Function() callCreateNew;
  final Function() callClose;
  final Future<bool> Function(String?, T) callSave;

  @override
  Widget build(BuildContext context) {
    if (userState.runtimeType == UserStateSignedIn) {
      UserStateSignedIn _userState = userState as UserStateSignedIn;
      // _userState.appUser
    }
    // DocumentSnapshot<T>? _documentSnapshot = documentSnapshot;

    return DefaultTabController(
      length: document.tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          PreloadPageController preloadPageController = PreloadPageController(initialPage: 0);

          List<ActionButton> actionButtons = [
            ...?extraActionButtons,
            ActionButton(
              onPressed: callClose,
              icon: const Icon(
                Icons.close,
              ),
            ),
            ActionButton(
              onPressed: () async {
                List<bool> validationResults = document.tabs.map((documentTab) {
                  bool isValid = documentTab.formKey.currentState!.validate();
                  return isValid;
                }).toList();

                if (validationResults.contains(false)) {
                  //Validation has failed
                  int failedTab = validationResults.indexWhere((validationResult) => validationResult == false);
                  preloadPageController.animateToPage(failedTab, duration: const Duration(microseconds: 100), curve: Curves.easeOutCirc);
                } else {
                  //Save this document
                  if ((await callSave(documentId, data)) == true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Saved succesfully'),
                    ));
                    callClose();
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
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
            ActionButton(
              onPressed: callCreateNew,
              icon: const Icon(
                Icons.add,
              ),
            ),
          ];

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              debugPrint("Navigate to tab ${tabController.index}");
              preloadPageController.animateToPage(tabController.index, duration: const Duration(microseconds: 100), curve: Curves.easeOutCirc);
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
                        key: _key,
                        endDrawer: (document.contextCards != null && document.contextCards!.isNotEmpty)
                            ? ContextCanvas(
                                contextWidgets: document.contextCards!
                                    .map(
                                      (contextCardBuilder) => contextCardBuilder(data),
                                    )
                                    .toList(),
                              )
                            : null,
                        primary: false,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        body: NestedScrollView(
                          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                actions: const [IgnorePointer()], //To surpess the hamburger
                                primary: false,
                                title: titleBuilder != null ? titleBuilder!(context, data) : null,
                                floating: true,
                                pinned: false,
                                snap: true,
                                centerTitle: true,
                                automaticallyImplyLeading: false,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                bottom: document.tabs.length != 1
                                    ? TabBar(
                                        controller: tabController,
                                        tabs: document.tabs
                                            .map(
                                              (documentTab) => documentTab.tabBuilder(),
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
                              return Form(
                                key: document.tabs[position].formKey,
                                child: Container(
                                  key: ObjectKey(data),
                                  child: document.tabs[position].childBuilder(data),
                                ),
                              );
                            },
                            controller: preloadPageController,
                            onPageChanged: (int position) {
                              debugPrint('page changed. current: $position');
                            },
                          ),
                        ),
                        floatingActionButton: ExpandableFab(
                          distance: 112.0,
                          children: actionButtons,
                        ),
                      ),
                    ),
                  ),
                  if (document.contextCards != null && document.contextCards!.isNotEmpty)
                    collapsed
                        ? SizedBox(
                            width: 250,
                            child: ContextCanvas(
                              contextWidgets: document.contextCards!
                                  .map(
                                    (contextCardBuilder) => contextCardBuilder(data),
                                  )
                                  .toList(),
                            ),
                          )
                        : DrawerButton(scaffoldKey: _key),
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
    if (widget.scaffoldKey.currentState != null && widget.scaffoldKey.currentState!.hasEndDrawer) {
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
  const ContextCanvas({Key? key, required this.contextWidgets}) : super(key: key);
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
  const DocumentTitle({Key? key, required, required this.title}) : super(key: key);
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
    required this.toFirestore,
    required this.documentList,
  }) : super(key: key);
  final DocumentList<T> documentList;
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;

  @override
  Widget build(BuildContext context) {
    debugPrint("Build DocumentList $runtimeType ${key.toString()}");

    Query<T> q = DatabaseService<T>().query(
      collection: collection,
      fromFirestore: fromFirestore,
      toFirestore: toFirestore, //List does not support updates
    );

    return FirestoreListView<T>(
      query: q,
      itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
        // return documentListBuilder(context, queryDocumentSnapshot);
        return _CardList(
          document: queryDocumentSnapshot,
          // notifier: notifier,
          documentListItemBuilder: documentList.builder,
        );
      },
      loadingBuilder: (context) => const WaitScreen(),
      errorBuilder: (context, error, stackTrace) => ErrorScreen(error: Exception(error)),
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
            NavigationStateNotifier navigationState = ref.read(navigationStateProvider.notifier);
            SelectionState<T> selectionState = SelectionState<T>(queryDocumentSnapshot: document, queryParams: {"id": document.id}, cardId: document.id);
            navigationState.selectionState = selectionState;
            documentPath = documentPath.split("?")[0];
            // GoRouter.of(context).go('$documentPath?id=${document.id}', extra: selectionState); //Disables until we figure out how to prevent a full rebuild when changing the query-string
          },
          child: Consumer(builder: (context, ref, child) {
            String activeCard = ref.watch(navigationStateProvider).selectionState.cardId;
            // debugPrint("Draw card ${document.id} active card: $activeCard");
            try {
              return documentListItemBuilder(context, activeCard == document.id, document.data());
            } catch (e) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.amberAccent),
                  subtitle: Text("Data Issue: ${e.toString()} in ${document.reference.path}"),
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

typedef DocumentTabChildBuilder<T> = Widget Function(T data); //, AppUser appUser);

typedef DocumentStream<T> = Stream<DocumentSnapshot> Function(
  String? documentId,
);

class DocumentTab<T> {
  /// this is a fFrame Document Tab
  ///
  ///
  final DocumentTabBuilder<T> tabBuilder;
  final DocumentTabChildBuilder childBuilder;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
