part of fframe;

class DocumentTab {
  final Tab tab;
  final Widget child;

  DocumentTab({required this.tab, required this.child});
}

class DocumentScreen<T> extends StatefulWidget {
  const DocumentScreen({
    Key? key,
    required this.query,
    required this.documentStream,
    required this.documentListBuilder,
    required this.documentBuilder,
    required this.titleBuilder,
    required this.documentTabs,
    this.actionButtons,
    this.contextWidgets,
    this.autoSave = true,
  }) : super(key: key);
  final Query<T> query;
  final DocumentStream documentStream;
  final DocumentListBuilder<T> documentListBuilder;
  final DocumentBuilder<T> documentBuilder;
  final TitleBuilder<T> titleBuilder;
  final bool autoSave;
  final List<DocumentTab> documentTabs;
  final List<ActionButton>? actionButtons;
  final List<Widget>? contextWidgets;

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

    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: _DocumentList<T>(
              query: widget.query,
              documentListBuilder: widget.documentListBuilder,
            ),
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: _DocumentBody(
                documentBuilder: widget.documentBuilder,
                documentStream: widget.documentStream,
                actionButtons: actionButtons,
                titleBuilder: widget.titleBuilder,
                documentTabs: widget.documentTabs,
                contextWidgets: widget.contextWidgets,
              )),
        ),
      ],
    );
  }
}

class _DocumentBody<T> extends ConsumerWidget {
  const _DocumentBody({
    Key? key,
    this.title,
    required this.documentBuilder,
    required this.titleBuilder,
    required this.documentStream,
    // required this.autoSave,
    required this.actionButtons,
    required this.documentTabs,
    this.contextWidgets,
  }) : super(key: key);
  final DocumentBuilder<T> documentBuilder;
  final TitleBuilder<T> titleBuilder;
  final DocumentStream? documentStream;
  // final bool autoSave;
  final String? title;
  final List<ActionButton> actionButtons;
  final List<DocumentTab> documentTabs;
  final List<Widget>? contextWidgets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              print("Load DocumentCanvas");
              return Scaffold(
                primary: false,
                // body: documentBuilder(context, asyncSnapshot.data!.reference, asyncSnapshot.data!.data()!),
                body: DocumentCanvas(
                  titleBuilder: titleBuilder,
                  data: asyncSnapshot.data!.data()!,
                  documentTabs: documentTabs,
                  actionButtons: actionButtons,
                  contextWidgets: contextWidgets,
                ),
              );
          }
        },
      );
    } else {
      if (documentSnapshot == null && queryParams != null) {
        return const WaitScreen();
      }
    }
    return const EmptyScreen();
  }
}

class DocumentCanvas<T> extends StatelessWidget {
  DocumentCanvas({
    Key? key,
    this.titleBuilder,
    required this.data,
    required this.actionButtons,
    required this.documentTabs,
    this.contextWidgets,
  }) : super(key: key);

  // final Suggestion suggestion;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final T data;
  final TitleBuilder<T>? titleBuilder;
  final List<ActionButton> actionButtons;
  final List<DocumentTab> documentTabs;
  final List<Widget>? contextWidgets;

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
                length: documentTabs.length,
                child: Scaffold(
                  key: _key,
                  endDrawer: (contextWidgets != null && contextWidgets!.isNotEmpty)
                      ? ContextCanvas(
                          contextWidgets: contextWidgets!,
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
                          title: titleBuilder != null ? titleBuilder!(data) : const Text("New"),
                          floating: true,
                          pinned: false,
                          snap: true,
                          automaticallyImplyLeading: false,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          bottom: documentTabs.length != 1
                              ? TabBar(
                                  tabs: documentTabs.map((documentTab) => documentTab.tab).toList(),
                                )
                              : null,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: documentTabs.map((documentTab) => documentTab.child).toList(),
                    ),
                  ),
                  floatingActionButton: ExpandableFab(
                    distance: 112.0,
                    children: actionButtons,
                  ),
                ),
              ),
            ),
            if (contextWidgets != null && contextWidgets!.isNotEmpty)
              collapsed
                  ? SizedBox(
                      width: 250,
                      child: ContextCanvas(
                        contextWidgets: contextWidgets!,
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
    return IgnorePointer();
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
    required this.documentListBuilder,
    // required this.notifier,
  }) : super(key: key);
  final Query<T> query;
  final DocumentListBuilder<T> documentListBuilder;
  // final ValueNotifier<QueryDocumentSnapshot<T>?> notifier;

  @override
  Widget build(BuildContext context) {
    print("Build DocumentList $runtimeType ${key.toString()}");
    return FirestoreListView<T>(
      query: query,
      itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
        // return documentListBuilder(context, queryDocumentSnapshot);
        return _CardList(
          document: queryDocumentSnapshot,
          // notifier: notifier,
          documentListBuilder: documentListBuilder,
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
    required this.documentListBuilder,
  });

  final QueryDocumentSnapshot<T> document;
  // final ValueNotifier<QueryDocumentSnapshot<T>?> notifier;
  final DocumentListBuilder<T> documentListBuilder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: GestureDetector(
        onTap: () {
          String documentPath = GoRouter.of(context).location;
          print("Update document to ${document.reference.path}");
          NavigationStateNotifier navigationState = ref.read(navigationStateProvider.notifier);
          SelectionState<T> selectionState = SelectionState<T>(queryDocumentSnapshot: document, queryParams: {"id": document.id}, cardId: document.id);
          navigationState.selectionState = selectionState;
          documentPath = documentPath.split("?")[0];
          GoRouter.of(context).go('$documentPath?id=${document.id}', extra: selectionState);
        },
        child: Consumer(builder: (context, ref, child) {
          String activeCard = ref.watch(navigationStateProvider).selectionState.cardId;
          // print("Draw card ${document.id} active card: $activeCard");
          return documentListBuilder(context, activeCard == document.id, document.data());
        }),
      ),
    );
  }
}

typedef DocumentListBuilder<T> = Widget Function(
  BuildContext context,
  bool selected,
  T data,
);
typedef DocumentBuilder<T> = Widget Function(
  BuildContext context,
  DocumentReference<T> documentReference,
  T data,
  // List<ActionButton> actionButtons,
  // List<DocumentTab> documentTabs,
  // List<Widget>? contextWidgets,
);
typedef TitleBuilder<T> = Widget Function(
  T data,
);

typedef DocumentStream = Stream<DocumentSnapshot> Function(String? documentId);
