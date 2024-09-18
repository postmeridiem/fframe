part of 'package:fframe/fframe.dart';

class DocumentBodyWatcher extends StatefulWidget {
  const DocumentBodyWatcher({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DocumentBodyWatcherState();
}

class _DocumentBodyWatcherState extends State<DocumentBodyWatcher> {
  // bool building = true;
  EdgeInsets padding = SelectionState.instance.padding;
  @override
  void initState() {
    super.initState();
    SelectionState.instance.addListener(updatePadding);
    // TargetState.instance.addListener(targetStateListener);
  }

  updatePadding() {
    if (SelectionState.instance.padding != padding) {
      setState(() {
        padding = SelectionState.instance.padding;
      });
    }
  }

  @override
  dispose() {
    super.dispose();
    SelectionState.instance.removeListener(updatePadding);
    // TargetState.instance.removeListener(targetStateListener);
  }

  // void targetStateListener() {
  //   // debugger();
  //   // if (SelectionState.instance.activeDocument == null) {
  //   //   debugger();
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    Console.log("Build _DocumentBodyWatcherState", scope: "fframeLog.DocumentBodyWatcher", level: LogLevel.fframe);
    return AnimatedPadding(
      padding: padding,
      duration: const Duration(seconds: 1),
      child: ListenableBuilder(
        listenable: SelectionState.instance,
        builder: ((context, child) {
          if (SelectionState.instance.activeTracker == null) {
            return const IgnorePointer();
          }
          return SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  top: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  right: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              // color: Theme.of(context).colorScheme.surface,
              child: SelectionState.instance.activeTracker!.documentBody,
            ),
          );
        }),
      ),
    );
    // });
  }
}

class DocumentBody<T> extends StatefulWidget {
  const DocumentBody({
    super.key,
    required this.documentConfig,
    required this.selectedDocument,
  });

  final DocumentConfig<T> documentConfig;
  final SelectedDocument<T> selectedDocument;

  @override
  State<DocumentBody<T>> createState() => _DocumentBodyState<T>();
}

class _DocumentBodyState<T> extends State<DocumentBody<T>> {
  final widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //Initialize the shadowed and casted variables

    final FFrameUser user = Fframe.of(context)!.user!;
    final DocumentConfig<T> documentConfig = widget.documentConfig;
    final Document<T> document = documentConfig.document;
    final SelectedDocument<T> selectedDocument = widget.selectedDocument;
    // final T data = selectedDocument.data;

    final DocumentHeaderBuilder<T>? documentHeaderBuilder = document.documentHeaderBuilder; // as DocumentHeaderBuilder<T>?;
    final TitleBuilder<T> documentTitle = documentConfig.documentTitle;
    final HeaderBuilder<T>? headerBuilder = documentConfig.headerBuilder;
    final List<Widget Function(T)>? contextCards = documentConfig.contextCardBuilders;
    final ExtraActionButtonsBuilder<T>? extraActionButtons = documentConfig.document.extraActionButtons; // as ExtraActionButtonsBuilder<T>?;
    final DocumentTabsBuilder<T> documentTabsBuilder = document.documentTabsBuilder;

    //Track this in the selectedDocument itself, as it is needed for the validator.
    selectedDocument.documentTabs = documentTabsBuilder(context, selectedDocument.data, selectedDocument.readOnly, selectedDocument.isNew, user);

    //Prepare the tabs
    String tabIndexKey = documentConfig.embeddedDocument ? "childTabIndex" : "tabIndex";
    int tabIndex = int.parse(SelectionState.instance.queryStringParam(tabIndexKey) ?? "0");

    return Hero(
      tag: selectedDocument.trackerId,
      child: DefaultTabController(
        animationDuration: Duration.zero,
        length: selectedDocument.documentTabs.length,
        // The Builder widget is used to have a different BuildContext to access
        // closest DefaultTabController.
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context);
            tabController.index = tabIndex;
            documentConfig.preloadPageController = PreloadPageController(initialPage: tabController.index);
            documentConfig.pageController = PageController(initialPage: tabController.index);
            documentConfig.tabController = tabController;

            tabController.addListener(
              () {
                if (!tabController.indexIsChanging) {
                  Console.log("Navigate to tab ${tabController.index}", scope: "fframeLog.DocumentBody", level: LogLevel.prod);
                  if (!selectedDocument.readOnly && !selectedDocument.isNew) {
                    int errorTab = selectedDocument.validate(context: context);
                    if (errorTab == -1 || selectedDocument.isNew) {
                      tabIndex = tabController.index;
                      FRouter.of(context).updateQueryString(queryParameters: {tabIndexKey: "${tabController.index}"});
                      documentConfig.preloadPageController.animateToPage(
                        tabController.index,
                        duration: const Duration(microseconds: 250),
                        curve: Curves.easeOutCirc,
                      );
                    } else {
                      //Undo the user tab change
                      tabController.index = tabIndex;
                    }
                  } else {
                    tabIndex = tabController.index;
                    FRouter.of(context).updateQueryString(queryParameters: {tabIndexKey: "${tabController.index}"});
                    documentConfig.preloadPageController.animateToPage(
                      tabController.index,
                      duration: const Duration(microseconds: 250),
                      curve: Curves.easeOutCirc,
                    );
                  }
                }
              },
            );
            Widget documentTitleHeader = const IgnorePointer();
            if (headerBuilder != null) {
              documentTitleHeader = headerBuilder(context, documentTitle(context, selectedDocument.data), selectedDocument.data);
            }

            return Column(
              children: [
                if (documentHeaderBuilder != null)
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: documentHeaderBuilder(context, selectedDocument.data),
                  ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: DefaultTabController(
                            length: selectedDocument.documentTabs.length,
                            child: Scaffold(
                              appBar: AppBar(
                                toolbarHeight: 40,
                                flexibleSpace: Row(
                                  children: [
                                    ...selectedDocument.iconButtons(context)!,
                                    // Add any extra configured buttons to the list
                                    if (extraActionButtons != null)
                                      ...extraActionButtons(
                                        context,
                                        selectedDocument,
                                        selectedDocument.readOnly,
                                        selectedDocument.isNew,
                                        Fframe.of(context)!.user,
                                      ),
                                  ],
                                ),
                                actions: [
                                  if (documentConfig.mdi)
                                    IconButton(
                                      tooltip: L10n.string(
                                        "iconbutton_document_close",
                                        placeholder: "Minimize this document",
                                        namespace: 'fframe',
                                      ),
                                      icon: Icon(
                                        Icons.minimize,
                                        color: Theme.of(context).indicatorColor,
                                      ),
                                      onPressed: () {
                                        SelectionState.instance.minimizeDocument(selectedDocument);
                                      },
                                    ),
                                  if (document.showCloseButton)
                                    IconButton(
                                      tooltip: L10n.string(
                                        "iconbutton_document_close",
                                        placeholder: "Close this document",
                                        namespace: 'fframe',
                                      ),
                                      icon: Icon(
                                        Icons.close,
                                        color: Theme.of(context).indicatorColor,
                                      ),
                                      onPressed: () {
                                        selectedDocument.close(context: context);
                                      },
                                    ),
                                ],
                              ),
                              endDrawer: (contextCards != null && contextCards.isNotEmpty)
                                  ? ContextCanvas(
                                      selectedDocument: selectedDocument,
                                      contextWidgets: contextCards
                                          .map(
                                            (contextCardBuilder) => contextCardBuilder(selectedDocument.data),
                                          )
                                          .toList(),
                                    )
                                  : null,
                              primary: false,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              body: Column(children: [
                                Expanded(
                                  child: NestedScrollView(
                                    physics: document.scrollableHeader ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                                      return <Widget>[
                                        SliverAppBar(
                                          actions: const [IgnorePointer()], //To surpess the hamburger
                                          primary: false,
                                          toolbarHeight: documentConfig.hideTitle ? 0 : kToolbarHeight,
                                          title: documentTitleHeader,
                                          pinned: false,
                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                          bottom: calculateTabBar(
                                            context: context,
                                            activeTabs: selectedDocument.documentTabs,
                                            controller: tabController,
                                          ),
                                        ),
                                      ];
                                    },
                                    body: PreloadPageView.builder(
                                      itemCount: selectedDocument.documentTabs.length,
                                      preloadPagesCount: selectedDocument.documentTabs.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      controller: documentConfig.preloadPageController,
                                      itemBuilder: (
                                        BuildContext context,
                                        int position,
                                      ) {
                                        Console.log(
                                          "Preloading PreloadPageView_${selectedDocument.documentId}_${tabController.index}",
                                          scope: "fframe.DocumentBody.PageView",
                                          level: LogLevel.fframe,
                                        );
                                        DocumentTab<T> currentTab = selectedDocument.documentTabs[position];

                                        currentTab.formKey = GlobalKey<FormState>();
                                        bool preloadCurrentTab = true;
                                        if (!document.prefetchTabs) {
                                          preloadCurrentTab = tabController.index == position;
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            key: ValueKey("PreloadPageView_${selectedDocument.documentId}_${tabController.index}"),
                                            child: Scaffold(
                                              primary: false,
                                              body: Form(
                                                key: currentTab.formKey,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                child: preloadCurrentTab
                                                    ? currentTab.lockViewportScroll
                                                        ? SizedBox(
                                                            height: double.infinity,
                                                            width: double.infinity,
                                                            child: SizedBox.expand(
                                                              child: ClipRect(
                                                                child: OverflowBox(
                                                                  alignment: Alignment.topLeft,
                                                                  child: currentTab.childBuilder(
                                                                    selectedDocument,
                                                                    selectedDocument.readOnly,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : MaterialApp(
                                                            theme: Fframe.of(context)!.lightMode,
                                                            darkTheme: Fframe.of(context)!.darkMode,
                                                            themeMode: Fframe.of(context)!.themeMode,
                                                            debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
                                                            builder: (context, child) {
                                                              return Scaffold(
                                                                body: SizedBox.expand(
                                                                  child: ClipRect(
                                                                    child: OverflowBox(
                                                                      alignment: Alignment.topLeft,
                                                                      child: SingleChildScrollView(
                                                                        child: currentTab.childBuilder(
                                                                          selectedDocument,
                                                                          selectedDocument.readOnly,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                    : Placeholder(
                                                        child: Center(child: Text("auto: $position")),
                                                      ),
                                              ),
                                              floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            )

                            // ContextDrawer<T>(
                            //   contextDrawerOpen: contextDrawerOpen,
                            //   selectedDocument: selectedDocument,
                            // ),

                            // ),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

calculateTabBar({
  required BuildContext context,
  required List<DocumentTab> activeTabs,
  required TabController controller,
}) {
  if (activeTabs.length != 1) {
    return TabBar(
      controller: controller,
      tabs: activeTabs.map((documentTab) {
        return documentTab.tabBuilder(Fframe.of(context)!.user);
      }).toList(),
    );
  } else {
    return null;
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({super.key});

  @override
  State<ChildWidget> createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
