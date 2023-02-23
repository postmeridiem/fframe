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

    try {
      return GestureDetector(
        onTap: () =>
            documentScreenConfig.selectDocument(context, queryDocumentSnapshot),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (_) {
            if (hoverSelect) {
              documentScreenConfig.selectDocument(
                  context, queryDocumentSnapshot);
            }
          },
          child: Builder(builder: (BuildContext context) {
            String docId = documentScreenConfig.selectionState.docId ?? '';
            try {
              return documentListItemBuilder(
                  context,
                  docId == queryDocumentSnapshot.id,
                  queryDocumentSnapshot.data(),
                  Fframe.of(context)!.user);
            } catch (e) {
              String error = e.toString();
              String path = queryDocumentSnapshot.reference.path;
              return ListTile(
                leading: Icon(Icons.warning,
                    color: Theme.of(context).colorScheme.error),
                subtitle: Text(
                  L10n.interpolated(
                    'errors_dataissue',
                    placeholder: "Data Issue: $error in $path",
                    replacers: [
                      L10nReplacer(
                        from: "{error}",
                        replace: error,
                      ),
                      L10nReplacer(
                        from: "{path}",
                        replace: path,
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
        color: Theme.of(context).colorScheme.error,
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
    Console.log("Build DocumentList with key ${widget.key.toString()}",
        scope: "fframeLog.DocumentListLoader", level: LogLevel.fframe);
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig =
        DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;

    return DocumentListBody<T>(
      key: ValueKey("documentListBody_${widget.key.toString()}"),
      scrollController: scrollController,
      documentScreenConfig: documentScreenConfig,
      documentConfig: documentConfig,
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
    required this.ref,
  }) : super(key: key);
  final ScrollController scrollController;
  final DocumentScreenConfig documentScreenConfig;
  final DocumentConfig<T> documentConfig;
  final WidgetRef ref;

  @override
  State<DocumentListBody<T>> createState() => _DocumentListBodyState<T>();
}

class _DocumentListBodyState<T> extends State<DocumentListBody<T>> {
  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 599)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    Console.log(
        "Build documentListLoader with key: listScaffold_${widget.key.toString()}",
        scope: "fframeLog.DocumentListBody",
        level: LogLevel.fframe);

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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0.2,
                      onPressed: () {
                        widget.documentScreenConfig.create<T>(context: context);
                      },
                      child: Icon(Icons.add,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  : null,
          primary: false,
          body: Stack(
            children: [
              Column(
                children: [
                  GetDocumentCount<T>(
                      documentConfig: widget.documentConfig,
                      headerType: HeaderType.header),
                  Expanded(
                    child: AnimatedBuilder(
                        animation:
                            widget.documentScreenConfig.fireStoreQueryState,
                        builder: (context, child) {
                          Query<T> query = widget
                              .documentScreenConfig.fireStoreQueryState
                              .currentQuery() as Query<T>;
                          return Column(
                            children: [
                              Expanded(
                                child: FirestoreSeparatedListView<T>(
                                  documentList:
                                      widget.documentConfig.documentList!,
                                  documentScreenConfig:
                                      widget.documentScreenConfig,
                                  selectionState: widget.documentScreenConfig
                                      .selectionState as SelectionState<T>,
                                  // queryBuilderSnapshotState: widget.documentScreenConfig.queryBuilderSnapshotState as QueryBuilderSnapshotState<T>,
                                  seperatorHeight: widget.documentConfig
                                          .documentList?.seperatorHeight ??
                                      1,
                                  controller: widget.scrollController,
                                  query: query,
                                  itemBuilder: (context,
                                      QueryDocumentSnapshot<T>
                                          queryDocumentSnapshot) {
                                    return DocumentListItem<T>(
                                      queryDocumentSnapshot:
                                          queryDocumentSnapshot,
                                      hoverSelect: widget.documentConfig
                                              .documentList?.hoverSelect ??
                                          false,
                                    );
                                  },
                                  loadingBuilder: (context) =>
                                      FRouter.of(context).waitPage(
                                          context: context,
                                          text: "Loading documents"),
                                  errorBuilder: (context, error, stackTrace) =>
                                      Fframe.of(context)!.showErrorPage(
                                          context: context,
                                          errorText: error.toString()),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  GetDocumentCount<T>(
                      documentConfig: widget.documentConfig,
                      headerType: HeaderType.footer),
                ],
              ),
              if (widget.documentConfig.dataGrid != null) DataGridToggle<T>(),
            ],
          ),
        ),
      ),
    );
  }
}

class GetDocumentCount<T> extends StatelessWidget {
  const GetDocumentCount({
    Key? key,
    required this.headerType,
    required this.documentConfig,
  }) : super(key: key);
  final HeaderType headerType;
  final DocumentConfig<T> documentConfig;

  @override
  Widget build(BuildContext context) {
    switch (headerType) {
      case HeaderType.header:
        if (documentConfig.documentList?.headerBuilder == null) {
          return const IgnorePointer();
        }
        break;
      case HeaderType.footer:
        if (documentConfig.documentList?.footerBuilder == null) {
          return const IgnorePointer();
        }
        break;
    }

    return FutureBuilder<int>(
      future: DatabaseService<T>().queryCount(
        collection: documentConfig.collection,
        fromFirestore: documentConfig.fromFirestore,
        queryBuilder: documentConfig.query,
      ),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasError) {
          Console.log("ERROR: ${snapshot.error.toString()}",
              scope: "fframeLog.GetDocumentCount", level: LogLevel.prod);
          return const IgnorePointer();
        }
        if (!snapshot.hasData) {
          return const IgnorePointer();
        }
        switch (headerType) {
          case HeaderType.header:
            return documentConfig.documentList!.headerBuilder!(
                context, snapshot.data!);
          case HeaderType.footer:
            return documentConfig.documentList!.footerBuilder!(
                context, snapshot.data!);
        }
      },
    );
  }
}

class FirestoreSeparatedListView<T> extends FirestoreQueryBuilder<T> {
  /// {@macro flutterfire_ui.firestorelistview}
  final DocumentScreenConfig documentScreenConfig;
  final DocumentList<T> documentList;
  final SelectionState<T> selectionState;

  FirestoreSeparatedListView({
    Key? key,
    required Query<T> query,
    required FirestoreItemBuilder<T> itemBuilder,
    required this.documentScreenConfig,
    required this.documentList,
    required this.selectionState,
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

            bool autoSelectFirst =
                documentScreenConfig.documentConfig.autoSelectFirst;

            return Consumer(builder: (context, ref, child) {
              return ListView.separated(
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  final isLastItem = index + 1 == snapshot.docs.length;
                  if (isLastItem && snapshot.hasMore) snapshot.fetchMore();

                  final queryDocumentSnapshot = snapshot.docs[index];

                  if (autoSelectFirst && index == 0 && !FRouter.of(context).hasQueryStringParam('id')) {
                    documentScreenConfig.load<T>(
                        context: context, docId: queryDocumentSnapshot.id);
                  }
                  return itemBuilder(context, queryDocumentSnapshot);
                },
                scrollDirection: scrollDirection,
                reverse: reverse,
                controller: controller,
                primary: primary,
                physics: physics,
                separatorBuilder: (BuildContext context, int index) =>
                    documentList.showSeparator
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
            });
          },
        );
}

class DataGridToggle<T> extends StatelessWidget {
  const DataGridToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentConfig<T> documentConfig =
        DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;
    List<ViewType> allowedViewTypes = documentConfig.allowedViewTypes;

    if (allowedViewTypes.isEmpty) {
      //Cannot toggle if there are no options to choose from
      return const IgnorePointer();
    }

    if (allowedViewTypes.length == 1 &&
        allowedViewTypes.first == documentConfig.currentViewType) {
      //Cannot toggle if the current option is the only viable option
      return const IgnorePointer();
    }

    return Positioned(
      right: -4,
      top: 0,
      // child: Icon(Icons.keyboard_double_arrow_right_rounded),
      child: IconButton(
        onPressed: () {
          documentConfig.currentViewType =
              (documentConfig.currentViewType == ViewType.list)
                  ? ViewType.grid
                  : ViewType.list;
        },
        padding:
            const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0, right: 0),
        icon: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              // topRight: Radius.circular(40.0),
              // bottomRight: Radius.circular(40.0),
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
            ),
          ),
          child: (documentConfig.currentViewType == ViewType.list)
              ? Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Theme.of(context).indicatorColor,
                )
              : Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  color: Theme.of(context).indicatorColor,
                ),
        ),
      ),
    );
  }
}
