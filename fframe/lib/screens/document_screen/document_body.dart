part of fframe;

class DocumentBody<T> extends StatelessWidget {
  const DocumentBody({
    Key? key,
    required this.queryState,
  }) : super(key: key);

  final QueryState queryState;

  @override
  Widget build(BuildContext context) {
    PreloadPageController preloadPageController;
    InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;

    return DefaultTabController(
      animationDuration: Duration.zero,
      length: documentConfig.document.tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          preloadPageController = PreloadPageController(initialPage: 0);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              debugPrint("Navigate to tab ${tabController.index}");
              FRouter.of(context).updateQueryString(queryParameters: {"tabIndex": "${tabController.index}"});
              preloadPageController.animateToPage(tabController.index, duration: const Duration(microseconds: 250), curve: Curves.easeOutCirc);
            }
          });

          return LayoutBuilder(
            builder: (context, constraints) {
              final double docCanvasWidth = constraints.maxWidth;
              final bool contextDrawerOpen = docCanvasWidth > 1000;

              final double formCanvasWidth = contextDrawerOpen ? (constraints.maxWidth - 250) : constraints.maxWidth;

              return CurvedBottomBar(
                formCanvasWidth: formCanvasWidth,
                floatingActionButton: inheritedDocument.fab(context),
                iconButtons: inheritedDocument.iconButtons(context),
                child: Row(
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
                                //                       AnimatedSwitcher(
                                // duration: const Duration(milliseconds: 500),
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: documentConfig.document.tabs[position].formState,
                                    child: Container(
                                      key: ObjectKey(inheritedDocument.selectionState.data),
                                      child: documentConfig.document.tabs[position].childBuilder(inheritedDocument.selectionState.data),
                                    ),
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
                    ContextDrawer<T>(
                      queryState: queryState,
                      contextDrawerOpen: contextDrawerOpen,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
