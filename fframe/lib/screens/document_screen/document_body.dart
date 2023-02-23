part of fframe;

class DocumentBodyLoader<T> extends StatefulWidget {
  const DocumentBodyLoader({
    Key? key,
  }) : super(key: key);

  @override
  State<DocumentBodyLoader> createState() => _DocumentBodyLoader<T>();
}

class _DocumentBodyLoader<T> extends State<DocumentBodyLoader> {
  late DocumentScreenConfig documentScreenConfig;
  late DocumentConfig<T> documentConfig;
  late SelectionState<T> selectionState;
  @override
  void didChangeDependencies() {
    documentScreenConfig = DocumentScreenConfig.of(context)!;
    documentConfig =
        DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;
    selectionState = documentScreenConfig.selectionState as SelectionState<T>;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Console.log("build documentBodyLoader ${widget.key.toString()}",
        scope: "fframeLog.DocumentBodyLoader", level: LogLevel.fframe);
    documentScreenConfig = DocumentScreenConfig.of(context)!;
    documentConfig =
        DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;
    selectionState = documentScreenConfig.selectionState as SelectionState<T>;

    return DocumentBody<T>(
      key: ValueKey("documentBody_${widget.key.toString()}"),
      documentScreenConfig: documentScreenConfig,
      documentConfig: documentConfig,
      selectionState: selectionState,
    );
  }
}

class DocumentBody<T> extends StatelessWidget {
  const DocumentBody({
    Key? key,
    required this.documentScreenConfig,
    required this.documentConfig,
    required this.selectionState,
  }) : super(key: key);

  final DocumentScreenConfig documentScreenConfig;
  final DocumentConfig<T> documentConfig;
  final SelectionState<T> selectionState;

  @override
  Widget build(BuildContext context) {
    Console.log("build documentBody ${key.toString()}",
        scope: "fframeLog.DocumentBody", level: LogLevel.fframe);

    String tabIndexKey = documentScreenConfig.documentConfig.embeddedDocument
        ? "childTabIndex"
        : "tabIndex";
    int tabIndex =
        int.parse(FRouter.of(context).queryStringParam(tabIndexKey) ?? "0");

    documentConfig.document.activeTabs =
        documentConfig.document.documentTabsBuilder!(
            context,
            selectionState.data as T,
            selectionState.readOnly,
            selectionState.isNew,
            Fframe.of(context)!.user);

    if (documentConfig.document.activeTabs!.isNotEmpty) {
      return DefaultTabController(
        animationDuration: Duration.zero,
        length: documentConfig.document.activeTabs!.length,
        // The Builder widget is used to have a different BuildContext to access
        // closest DefaultTabController.
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context);
            tabController.index = tabIndex;
            documentConfig.preloadPageController =
                PreloadPageController(initialPage: tabController.index);
            documentConfig.tabController = tabController;

            tabController.addListener(
              () {
                if (!tabController.indexIsChanging) {
                  Console.log("Navigate to tab ${tabController.index}",
                      scope: "fframeLog.DocumentBody", level: LogLevel.prod);
                  if (!documentScreenConfig.selectionState.readOnly &&
                      !documentScreenConfig.selectionState.isNew) {
                    int errorTab =
                        documentScreenConfig.validate(context: context);
                    if (errorTab == -1 ||
                        documentScreenConfig.selectionState.isNew) {
                      tabIndex = tabController.index;
                      FRouter.of(context).updateQueryString(queryParameters: {
                        tabIndexKey: "${tabController.index}"
                      });
                      documentConfig.preloadPageController.animateToPage(
                          tabController.index,
                          duration: const Duration(microseconds: 250),
                          curve: Curves.easeOutCirc);
                    } else {
                      //Undo the user tab change
                      tabController.index = tabIndex;
                    }
                  } else {
                    tabIndex = tabController.index;
                    FRouter.of(context).updateQueryString(queryParameters: {
                      tabIndexKey: "${tabController.index}"
                    });
                    documentConfig.preloadPageController.animateToPage(
                        tabController.index,
                        duration: const Duration(microseconds: 250),
                        curve: Curves.easeOutCirc);
                  }
                }
              },
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final double docCanvasWidth = constraints.maxWidth;
                final bool contextDrawerOpen = docCanvasWidth > 1000;

                return Column(
                  children: [
                    if (documentConfig.document.documentHeaderBuilder != null)
                      SizedBox(
                        height: 40.0,
                        width: double.infinity,
                        child: documentConfig.document.documentHeaderBuilder!(
                            context, documentScreenConfig.selectionState.data),
                      ),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: DefaultTabController(
                              length:
                                  documentConfig.document.activeTabs!.length,
                              child: Scaffold(
                                endDrawer:
                                    (documentConfig.document.contextCards !=
                                                null &&
                                            documentConfig.document
                                                .contextCards!.isNotEmpty)
                                        ? ContextCanvas(
                                            contextWidgets: documentConfig
                                                .document.contextCards!
                                                .map(
                                                  (contextCardBuilder) =>
                                                      contextCardBuilder(
                                                          documentScreenConfig
                                                              .selectionState
                                                              .data),
                                                )
                                                .toList(),
                                          )
                                        : null,
                                primary: false,
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                body: NestedScrollView(
                                  physics: documentConfig
                                          .document.scrollableHeader
                                      ? const AlwaysScrollableScrollPhysics()
                                      : const NeverScrollableScrollPhysics(),
                                  headerSliverBuilder: (BuildContext context,
                                      bool innerBoxIsScrolled) {
                                    return <Widget>[
                                      SliverAppBar(
                                        actions: const [
                                          IgnorePointer()
                                        ], //To surpess the hamburger
                                        primary: false,
                                        title:
                                            documentConfig.titleBuilder != null
                                                ? documentConfig.titleBuilder!(
                                                    context,
                                                    documentScreenConfig
                                                        .selectionState.data)
                                                : Text(documentScreenConfig
                                                        .selectionState.docId ??
                                                    ""),
                                        floating: true,
                                        pinned: false,
                                        snap: true,
                                        centerTitle: true,
                                        automaticallyImplyLeading: false,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        bottom: documentConfig.document
                                                    .activeTabs!.length !=
                                                1
                                            ? TabBar(
                                                controller: tabController,
                                                tabs: documentConfig
                                                    .document.activeTabs!
                                                    .map(
                                                      (documentTab) =>
                                                          documentTab.tabBuilder(
                                                              Fframe.of(
                                                                      context)!
                                                                  .user),
                                                    )
                                                    .toList(),
                                              )
                                            : null,
                                      ),
                                    ];
                                  },
                                  body: PreloadPageView.builder(
                                    itemCount: documentConfig
                                        .document.activeTabs!.length,
                                    preloadPagesCount: documentConfig
                                        .document.activeTabs!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int position) {
                                      documentConfig
                                          .document
                                          .activeTabs![position]
                                          .formKey = GlobalKey<FormState>();

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          key: ValueKey(
                                              "PreloadPageView_${documentScreenConfig.selectionState.docId}_${tabController.index}"),
                                          child: Scaffold(
                                            primary: false,
                                            body: Form(
                                              key: documentConfig
                                                  .document
                                                  .activeTabs![position]
                                                  .formKey,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              child: documentConfig.document
                                                  .activeTabs![position]
                                                  .childBuilder(
                                                      documentScreenConfig
                                                          .selectionState.data,
                                                      documentScreenConfig
                                                          .selectionState
                                                          .readOnly),
                                            ),
                                            floatingActionButtonLocation:
                                                FloatingActionButtonLocation
                                                    .miniCenterDocked,
                                            bottomNavigationBar: BottomAppBar(
                                              elevation: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              shape:
                                                  const CircularNotchedRectangle(),
                                              child: IconTheme(
                                                data: IconThemeData(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                                child: Row(
                                                  children: [
                                                    ...documentScreenConfig
                                                        .iconButtons<T>(
                                                            context)!,
                                                    //Add any extra configured buttons to the list
                                                    if (documentConfig.document
                                                            .extraActionButtons !=
                                                        null)
                                                      ...documentConfig.document
                                                              .extraActionButtons!(
                                                          context,
                                                          selectionState.data
                                                              as T,
                                                          selectionState
                                                              .readOnly,
                                                          selectionState.isNew,
                                                          Fframe.of(context)!
                                                              .user),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    controller:
                                        documentConfig.preloadPageController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ContextDrawer<T>(
                            contextDrawerOpen: contextDrawerOpen,
                          ),
                        ],
                        // ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    } else {
      return Fframe.of(context)!.showErrorPage(
          context: context, errorText: "Incorrect form configuration");
    }
  }
}
