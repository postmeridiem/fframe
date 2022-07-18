part of fframe;

class DocumentListItem<T> extends ConsumerWidget {
  const DocumentListItem({
    Key? key,
    required this.queryDocumentSnapshot,
    required this.hoverSelect,
  }) : super(key: key);

  final QueryDocumentSnapshot<T> queryDocumentSnapshot;
  final bool hoverSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig =
        documentScreenConfig.documentConfig as DocumentConfig<T>;
    DocumentListItemBuilder<T> documentListItemBuilder =
        documentConfig.documentList!.builder;

    selectDocument() {
      bool embeddedDocument =
          documentScreenConfig.documentConfig.embeddedDocument;
      String tabIndexKey = embeddedDocument ? "childTabIndex" : "tabIndex";
      documentScreenConfig.selectionState.setState(SelectionState<T>(
          docId: queryDocumentSnapshot.id, data: queryDocumentSnapshot.data()));
      if (documentConfig.document.tabs.length == 1) {
        FRouter.of(context).updateQueryString<T>(queryParameters: {
          documentConfig.queryStringIdParam: queryDocumentSnapshot.id
        }, resetQueryString: !embeddedDocument);
      } else {
        FRouter.of(context).updateQueryString<T>(queryParameters: {
          documentConfig.queryStringIdParam: queryDocumentSnapshot.id,
          tabIndexKey: "0"
        }, resetQueryString: !embeddedDocument);
      }
    }

    try {
      return GestureDetector(
        onTap: selectDocument,
        child: MouseRegion(
          onHover: (_) {
            if (hoverSelect) {
              selectDocument();
            }
          },
          child: Consumer(builder: (context, ref, child) {
            String docId = documentScreenConfig.selectionState.docId ?? '';
            try {
              return documentListItemBuilder(
                  context,
                  docId == queryDocumentSnapshot.id,
                  queryDocumentSnapshot.data(),
                  Fframe.of(context)!.user);
            } catch (e) {
              String _error = e.toString();
              String _path = queryDocumentSnapshot.reference.path;
              return ListTile(
                leading:
                    Icon(Icons.warning, color: Theme.of(context).errorColor),
                subtitle: Text(
                  L10n.interpolated(
                    'errors_dataissue',
                    placeholder: "Data Issue: $_error in $_path",
                    replacers: [
                      L10nReplacer(
                        from: "{error}",
                        replace: _error,
                      ),
                      L10nReplacer(
                        from: "{path}",
                        replace: _path,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      );
    } catch (e) {
      return ListTile(
          leading: Icon(
        Icons.warning,
        color: Theme.of(context).errorColor,
      ));
    }
  }
}

class DocumentListLoader<T> extends StatefulWidget {
  const DocumentListLoader({
    Key? key,
    required this.ref,
  }) : super(key: key);
  final WidgetRef ref;
  @override
  State<DocumentListLoader<T>> createState() => _DocumentListLoaderState<T>();
}

class _DocumentListLoaderState<T> extends State<DocumentListLoader<T>> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    debugPrint("Build DocumentList with key ${widget.key.toString()}");
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig =
        DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;

    Query<T> query = DatabaseService<T>().query(
      collection: documentConfig.collection,
      fromFirestore: documentConfig.fromFirestore,
    );
    // FireStoreQueryState<T> fireStoreQueryState = FireStoreQueryState<T>(initialQuery: documentConfig.query);
    FireStoreQueryState<T> fireStoreQueryState =
        DocumentScreenConfig.of(context)?.fireStoreQueryState
            as FireStoreQueryState<T>;
    fireStoreQueryState.initialQuery = documentConfig.query;

    return DocumentListBody<T>(
      key: ValueKey("documentListBody_${widget.key.toString()}"),
      scrollController: scrollController,
      documentScreenConfig: documentScreenConfig,
      documentConfig: documentConfig,
      query: fireStoreQueryState.currentQuery(query),
      ref: widget.ref,
    );
  }
}

class DocumentListBody<T> extends StatefulWidget {
  const DocumentListBody({
    Key? key,
    required this.scrollController,
    required this.documentScreenConfig,
    required this.documentConfig,
    required this.query,
    required this.ref,
  }) : super(key: key);
  final ScrollController scrollController;
  final DocumentScreenConfig documentScreenConfig;
  final DocumentConfig<T> documentConfig;
  final Query<T> query;
  final WidgetRef ref;

  @override
  State<DocumentListBody<T>> createState() => _DocumentListBodyState<T>();
}

class _DocumentListBodyState<T> extends State<DocumentListBody<T>> {
  // @override
  // void initState() {
  //   widget.documentScreenConfig.fireStoreQueryState.addListener(() => queryUpdateListener());

  //   super.initState();
  // }

  // @override
  // dispose() {
  //   widget.documentScreenConfig.fireStoreQueryState.removeListener(() => queryUpdateListener());
  //   super.dispose();
  // }

  // queryUpdateListener() {
  //   debugPrint("the query has changed...");
  // }

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 599)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    debugPrint(
        "Build documentListLoader with key: listScaffold_${widget.key.toString()}");

    double listWidth = 250;
    if (ScreenSize.phone == screenSize) {
      listWidth = MediaQuery.of(context).size.width;
      Map<String, String>? queryParameters =
          widget.ref.watch(queryStateProvider).queryParameters;
      if (queryParameters != null) {
        if (queryParameters.isNotEmpty) {
          //Some document is loaded, and we are on a phone. Don't show the selector
          listWidth = 0;
        }
      }
    }

    return SizedBox(
      width: listWidth,
      child: Container(
        key: ValueKey("listScaffold_${widget.key.toString()}"),
        child: Scaffold(
          floatingActionButton:
              (widget.documentConfig.documentList?.showCreateButton ?? true)
                  ? FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: const Icon(Icons.add),
                      elevation: 0.2,
                      onPressed: () {
                        widget.documentScreenConfig.create(context: context);
                      },
                    )
                  : null,
          primary: false,
          body: Column(
            children: [
              DocumentSearch<T>(),
              Expanded(
                child: AnimatedBuilder(
                    animation: widget.documentScreenConfig.fireStoreQueryState,
                    builder: (context, child) {
                      Query<T> query = widget
                          .documentScreenConfig.fireStoreQueryState
                          .currentQuery(widget.query) as Query<T>;
                      return FirestoreSeparatedListView<T>(
                        showSeperator:
                            widget.documentConfig.documentList?.showSeparator ??
                                true,
                        seperatorHeight: widget
                                .documentConfig.documentList?.seperatorHeight ??
                            1,
                        controller: widget.scrollController,
                        query: query,
                        itemBuilder: (context,
                            QueryDocumentSnapshot<T> queryDocumentSnapshot) {
                          return DocumentListItem<T>(
                            queryDocumentSnapshot: queryDocumentSnapshot,
                            hoverSelect: widget
                                    .documentConfig.documentList?.hoverSelect ??
                                false,
                          );
                        },
                        loadingBuilder: (context) => FRouter.of(context)
                            .waitPage(
                                context: context, text: "Loading documents"),
                        errorBuilder: (context, error, stackTrace) =>
                            Fframe.of(context)!.showError(
                                context: context, errorText: error.toString()),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirestoreSeparatedListView<Document>
    extends FirestoreQueryBuilder<Document> {
  /// {@macro flutterfire_ui.firestorelistview}
  FirestoreSeparatedListView({
    Key? key,
    required Query<Document> query,
    required FirestoreItemBuilder<Document> itemBuilder,
    bool showSeperator = true,
    double seperatorHeight = 1,
    int pageSize = 10,
    FirestoreLoadingBuilder? loadingBuilder,
    FirestoreErrorBuilder? errorBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : super(
          key: key,
          query: query,
          pageSize: pageSize,
          builder: (context, snapshot, _) {
            if (snapshot.isFetching) {
              return loadingBuilder?.call(context) ??
                  const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError && errorBuilder != null) {
              return errorBuilder(
                context,
                snapshot.error!,
                snapshot.stackTrace!,
              );
            }

            return ListView.separated(
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                final isLastItem = index + 1 == snapshot.docs.length;
                if (isLastItem && snapshot.hasMore) snapshot.fetchMore();

                final doc = snapshot.docs[index];
                return itemBuilder(context, doc);
              },
              scrollDirection: scrollDirection,
              reverse: reverse,
              controller: controller,
              primary: primary,
              physics: physics,
              separatorBuilder: (BuildContext context, int index) =>
                  showSeperator
                      ? Divider(
                          height: seperatorHeight,
                          color: Theme.of(context).dividerColor)
                      : const IgnorePointer(),
              shrinkWrap: shrinkWrap,
              padding: padding,
              // itemExtent: itemExtent,
              // prototypeItem: prototypeItem,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              cacheExtent: cacheExtent,
              // semanticChildCount: semanticChildCount,
              dragStartBehavior: dragStartBehavior,
              keyboardDismissBehavior: keyboardDismissBehavior,
              restorationId: restorationId,
              clipBehavior: clipBehavior,
            );
          },
        );
}
