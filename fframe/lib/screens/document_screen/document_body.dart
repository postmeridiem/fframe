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
    InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;
    bool readOnly = inheritedDocument.selectionState.readOnly;

    inheritedDocument.selectionState.addListener(
      () => {
        if (readOnly != inheritedDocument.selectionState.readOnly)
          {
            setState(
              () {},
            )
          }
      },
    );

    return DocumentBody<T>(
      queryState: widget.queryState,
      inheritedDocument: inheritedDocument,
      documentConfig: documentConfig,
    );
  }
}

class DocumentBody<T> extends StatelessWidget {
  const DocumentBody({
    Key? key,
    required this.queryState,
    required this.inheritedDocument,
    required this.documentConfig,
  }) : super(key: key);

  final QueryState queryState;
  final InheritedDocument inheritedDocument;
  final DocumentConfig<T> documentConfig;

  @override
  Widget build(BuildContext context) {
    PreloadPageController preloadPageController;
    // InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    // DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;
    String tabIndexKey = inheritedDocument.documentConfig.embeddedDocument ? "childTabIndex" : "tabIndex";
    int tabIndex = int.parse(FRouter.of(context).queryStringParam(tabIndexKey) ?? "0");

    return DefaultTabController(
      animationDuration: Duration.zero,
      length: documentConfig.document.tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          tabController.index = tabIndex;
          preloadPageController = PreloadPageController(initialPage: tabController.index);

          tabController.addListener(
            () {
              debugPrint("Navigate to tab ${tabController.index}");
              if (!tabController.indexIsChanging) {
                if (inheritedDocument.selectionState.readOnly || inheritedDocument.validate(context: context)) {
                  tabIndex = tabController.index;
                  FRouter.of(context).updateQueryString(queryParameters: {tabIndexKey: "${tabController.index}"});
                  preloadPageController.animateToPage(tabController.index, duration: const Duration(microseconds: 250), curve: Curves.easeOutCirc);
                } else {
                  //Undo the user tab change
                  tabController.index = tabIndex;
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
                      length: documentConfig.document.tabs.length,
                      child: Scaffold(
                        endDrawer: (documentConfig.document.contextCards != null && documentConfig.document.contextCards!.isNotEmpty)
                            ? ContextCanvas(
                                contextWidgets: documentConfig.document.contextCards!
                                    .map(
                                      (contextCardBuilder) => contextCardBuilder(inheritedDocument.selectionState.data),
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
                                title: documentConfig.titleBuilder != null ? documentConfig.titleBuilder!(context, inheritedDocument.selectionState.data) : Text(inheritedDocument.selectionState.docId ?? ""),
                                floating: true,
                                pinned: false,
                                snap: true,
                                centerTitle: true,
                                automaticallyImplyLeading: false,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                bottom: documentConfig.document.tabs.length != 1
                                    ? TabBar(
                                        controller: tabController,
                                        tabs: documentConfig.document.tabs
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
                            itemCount: documentConfig.document.tabs.length,
                            preloadPagesCount: documentConfig.document.tabs.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int position) {
                              debugPrint("Build tab $position");
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  key: ValueKey("PreloadPageView_${inheritedDocument.selectionState.docId}_${tabController.index}"),
                                  child: Scaffold(
                                    primary: false,
                                    body: documentConfig.document.tabs[position].childBuilder(inheritedDocument.selectionState.data, inheritedDocument.selectionState.readOnly),
                                    floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
                                    bottomNavigationBar: BottomAppBar(
                                      // shape: const CircularNotchedRectangle(),
                                      child: IconTheme(
                                        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                                        child: Row(
                                          children: [
                                            ...inheritedDocument.iconButtons<T>(context)!,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            controller: preloadPageController,
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
  }
}
