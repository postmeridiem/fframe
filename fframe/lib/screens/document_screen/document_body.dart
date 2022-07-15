part of fframe;

class DocumentBodyLoader<T> extends StatefulWidget {
  const DocumentBodyLoader({
    Key? key,
    required this.queryState,
  }) : super(key: key);
  final QueryState queryState;

  @override
  State<DocumentBodyLoader> createState() => _DocumentBodyLoader<T>();
}

class _DocumentBodyLoader<T> extends State<DocumentBodyLoader> {
  @override
  Widget build(BuildContext context) {
    debugPrint("build documentBodyLoader ${widget.key.toString()}");
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig = DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;



    return DocumentBody<T>(
      key: ValueKey("documentBody_${widget.key.toString()}"),
      queryState: widget.queryState,
      documentScreenConfig: documentScreenConfig,
      documentConfig: documentConfig,
    );
  }
}

class DocumentBody<T> extends StatelessWidget {
  const DocumentBody({
    Key? key,
    required this.queryState,
    required this.documentScreenConfig,
    required this.documentConfig,
  }) : super(key: key);

  final QueryState queryState;
  final DocumentScreenConfig documentScreenConfig;
  final DocumentConfig<T> documentConfig;

  @override
  Widget build(BuildContext context) {
    debugPrint("build documentBody ${key.toString()}");
    // PreloadPageController preloadPageController;
    String tabIndexKey = documentScreenConfig.documentConfig.embeddedDocument ? "childTabIndex" : "tabIndex";
    int tabIndex = int.parse(FRouter.of(context).queryStringParam(tabIndexKey) ?? "0");
    List<DocumentTab<T>> tabs = documentConfig.document.tabs as List<DocumentTab<T>>;

    if (tabs.isNotEmpty) {
      return DefaultTabController(
        animationDuration: Duration.zero,
        length: tabs.length,
        // The Builder widget is used to have a different BuildContext to access
        // closest DefaultTabController.
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context)!;
            tabController.index = tabIndex;
            documentConfig.preloadPageController = PreloadPageController(initialPage: tabController.index);
            documentConfig.tabController = tabController;

            tabController.addListener(
              () {
                if (!tabController.indexIsChanging) {
                  debugPrint("Navigate to tab ${tabController.index}");
                  if (!documentScreenConfig.selectionState.readOnly && !documentScreenConfig.selectionState.isNew) {
                    int errorTab = documentScreenConfig.validate(context: context);
                    if (errorTab == -1 || documentScreenConfig.selectionState.isNew) {
                      tabIndex = tabController.index;
                      FRouter.of(context).updateQueryString(queryParameters: {tabIndexKey: "${tabController.index}"});
                      documentConfig.preloadPageController.animateToPage(tabController.index, duration: const Duration(microseconds: 250), curve: Curves.easeOutCirc);
                    } else {
                      //Undo the user tab change
                      tabController.index = tabIndex;
                    }
                  } else {
                    tabIndex = tabController.index;
                    FRouter.of(context).updateQueryString(queryParameters: {tabIndexKey: "${tabController.index}"});
                    documentConfig.preloadPageController.animateToPage(tabController.index, duration: const Duration(microseconds: 250), curve: Curves.easeOutCirc);
                  }
                }
              },
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final double docCanvasWidth = constraints.maxWidth;
                final bool contextDrawerOpen = docCanvasWidth > 1000;

                return Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: DefaultTabController(
                        length: tabs.length,
                        child: Scaffold(
                          endDrawer: (documentConfig.document.contextCards != null && documentConfig.document.contextCards!.isNotEmpty)
                              ? ContextCanvas(
                                  contextWidgets: documentConfig.document.contextCards!
                                      .map(
                                        (contextCardBuilder) => contextCardBuilder(documentScreenConfig.selectionState.data),
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
                                  title: documentConfig.titleBuilder != null ? documentConfig.titleBuilder!(context, documentScreenConfig.selectionState.data) : Text(documentScreenConfig.selectionState.docId ?? ""),
                                  floating: true,
                                  pinned: false,
                                  snap: true,
                                  centerTitle: true,
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  bottom: tabs.length != 1
                                      ? TabBar(
                                          controller: tabController,
                                          tabs: tabs
                                              .map(
                                                (documentTab) => documentTab.tabBuilder(Fframe.of(context)!.user),
                                              )
                                              .toList(),
                                        )
                                      : null,
                                ),
                              ];
                            },
                            body: PreloadPageView.builder(
                              itemCount: tabs.length,
                              preloadPagesCount: tabs.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int position) {
                                // debugPrint("Build tab $position");
                                tabs[position].formKey = GlobalKey<FormState>();

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    key: ValueKey("PreloadPageView_${documentScreenConfig.selectionState.docId}_${tabController.index}"),
                                    child: Scaffold(
                                      primary: false,
                                      body: Form(
                                        key: tabs[position].formKey,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        child: tabs[position].childBuilder(documentScreenConfig.selectionState.data, documentScreenConfig.selectionState.readOnly),
                                      ),
                                      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
                                      bottomNavigationBar: BottomAppBar(
                                        elevation: 0,
                                        color: Theme.of(context).colorScheme.background,
                                        shape: const CircularNotchedRectangle(),
                                        child: IconTheme(
                                          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                                          child: Row(
                                            children: [
                                              ...documentScreenConfig.iconButtons<T>(context)!,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              controller: documentConfig.preloadPageController,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ContextDrawer<T>(
                      queryState: queryState,
                      contextDrawerOpen: contextDrawerOpen,
                    ),
                  ],
                  // ),
                );
              },
            );
          },
        ),
      );
    } else {
      return Fframe.of(context)!.showError(context: context, errorText: "Incorrect form configuration");
    }
  }
}
