part of fframe;

class DocumentScreen<T> extends StatefulWidget {
  const DocumentScreen({
    Key? key,
    // required this.query,

    this.documentList,
    this.documentBuilder,
    this.titleBuilder,
    required this.document,
    this.actionButtons,
    this.contextCardBuilders,
  }) : super(key: key);
  // final Query<T> query;

  final DocumentList<T>? documentList;
  final DocumentBuilder<T>? documentBuilder;
  final TitleBuilder<T>? titleBuilder;
  final Document document;
  final List<ActionButton>? actionButtons;
  final List<ContextCardBuilder>? contextCardBuilders;

  @override
  State<DocumentScreen<T>> createState() => _DocumentScreenState<T>();
}

class _DocumentScreenState<T> extends State<DocumentScreen<T>> {
  @override
  Widget build(BuildContext context) {
    List<ActionButton> actionButtons = [
      ActionButton(
        onPressed: () => {},
        icon: const Icon(
          Icons.close,
        ),
      ),
      ActionButton(
        onPressed: () => {},
        icon: const Icon(
          Icons.save,
        ),
      ),
      ActionButton(
        onPressed: () => {},
        icon: const Icon(
          Icons.add,
        ),
      ),
    ];

    if (widget.actionButtons != null) {
      actionButtons.addAll(widget.actionButtons!);
    }

    _DocumentBody<T> documentBody = _DocumentBody(
      documentStream: widget.document.documentStream,
      actionButtons: actionButtons,
      titleBuilder: widget.titleBuilder,
      document: widget.document,
      contextCardBuilders: widget.contextCardBuilders,
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
                query: widget.documentList!.query,
                documentListItemBuilder: widget.documentList!.builder,
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
    this.titleBuilder,
    required this.documentStream,
    required this.actionButtons,
    required this.document,
    this.contextCardBuilders,
  }) : super(key: key);
  final TitleBuilder<T>? titleBuilder;
  final DocumentStream? documentStream;
  final List<ActionButton> actionButtons;
  final Document document;
  final List<ContextCardBuilder>? contextCardBuilders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      NavigationStateNotifier navigationState = ref.watch(navigationStateProvider);

      DocumentSnapshot<T>? documentSnapshot = navigationState.selectionState.queryDocumentSnapshot as DocumentSnapshot<T>?;
      Map<String, String>? queryParams = navigationState.selectionState.queryParams;
      if ((documentSnapshot != null && queryParams != null && documentStream != null) || (queryParams != null && queryParams.containsKey("id"))) {
        String docId = documentSnapshot?.id ?? queryParams['id']!;

        Stream<DocumentSnapshot<T>> _documentStream = documentStream!(docId) as Stream<DocumentSnapshot<T>>;

        return StreamBuilder<DocumentSnapshot<T>>(
          initialData: documentSnapshot,
          stream: _documentStream,
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
                  T? snapshotData = asyncSnapshot.data!.data();

                  if (snapshotData != null) {
                    return Scaffold(
                      primary: false,
                      // body: documentBuilder(context, asyncSnapshot.data!.reference, asyncSnapshot.data!.data()!),
                      body: DocumentCanvas<T>(
                        titleBuilder: titleBuilder,
                        data: snapshotData,
                        document: document,
                        actionButtons: actionButtons,
                        contextCardBuilders: contextCardBuilders,
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
                    externalLocation: "https://console.firebase.google.com/project/${asyncSnapshot.data?.reference.firestore.app.name}/firestore/data/~2Fusers~2F1U1O47tW48W5K5PpEXWc1QRRWxt1",
                  );
                }
            }
          },
        );
      } else {
        if (documentSnapshot == null && queryParams != null) {
          return const WaitScreen();
        }
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
    required this.actionButtons,
    required this.document,
    this.contextCardBuilders,
  }) : super(key: key);

  // final Suggestion suggestion;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final T data;
  final TitleBuilder<T>? titleBuilder;
  final List<ActionButton> actionButtons;
  final Document document;
  final List<ContextCardBuilder>? contextCardBuilders;

  @override
  Widget build(BuildContext context) {
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
                  endDrawer: (contextCardBuilders != null && contextCardBuilders!.isNotEmpty)
                      ? ContextCanvas(
                          contextWidgets: contextCardBuilders!
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
                    body: TabBarView(
                      // children: [],
                      children: document.tabs.map(
                        (documentTab) {
                          return Form(
                            key: documentTab.formKey,
                            child: documentTab.childBuilder(data),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  floatingActionButton: ExpandableFab(
                    distance: 112.0,
                    children: actionButtons,
                  ),
                ),
              ),
            ),
            if (contextCardBuilders != null && contextCardBuilders!.isNotEmpty)
              collapsed
                  ? SizedBox(
                      width: 250,
                      child: ContextCanvas(
                        contextWidgets: contextCardBuilders!
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
    required this.query,
    required this.documentListItemBuilder,
    // required this.notifier,
  }) : super(key: key);
  final Query<T> query;
  final DocumentListItemBuilder<T> documentListItemBuilder;
  // final ValueNotifier<QueryDocumentSnapshot<T>?> notifier;

  @override
  Widget build(BuildContext context) {
    debugPrint("Build DocumentList $runtimeType ${key.toString()}");
    return FirestoreListView<T>(
      query: query,
      itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
        // return documentListBuilder(context, queryDocumentSnapshot);
        return _CardList(
          document: queryDocumentSnapshot,
          // notifier: notifier,
          documentListItemBuilder: documentListItemBuilder,
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
            GoRouter.of(context).go('$documentPath?id=${document.id}', extra: selectionState);
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

typedef DocumentTabBuilder = Widget Function();

typedef DocumentTabChildBuilder<T> = Widget Function(
  dynamic data,
);

typedef DocumentStream = Stream<DocumentSnapshot> Function(
  String? documentId,
);

class DocumentTab<T> {
  final DocumentTabBuilder tabBuilder;
  final DocumentTabChildBuilder<T> childBuilder;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DocumentTab({
    required this.tabBuilder,
    required this.childBuilder,
  });
}

class Document {
  Document({
    this.key,
    required this.tabs,
    required this.documentStream,
    this.contextCards,
    this.autoSave = false,
  });
  final Key? key;
  final DocumentStream documentStream;
  final List<DocumentTab> tabs;
  final List<ContextCardBuilder>? contextCards;
  bool autoSave;
}
