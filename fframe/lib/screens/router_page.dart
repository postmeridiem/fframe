part of fframe;

class RouterPage extends Page {
  const RouterPage();

  @override
  Route createRoute(BuildContext context) {
    debugPrint("RouterPage.createRoute");
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Consumer(builder: (context, ref, child) {
        debugPrint("Build FRouter");
        return FRouter(
          ref: ref,
        );
      }),
    );
  }
}

///FRouter helps to navigate using navigationTargets and query string parameters
///UseFill methods: navigateTo(), updateQueryString()
class FRouter extends InheritedWidget {
  const FRouter({
    Key? key,
    required this.ref,
    // required this.signedIn,
    // this.roles,
  }) : super(key: key, child: const RouterScreen());
  final WidgetRef ref;
  // final bool signedIn;
  // final List<String>? roles;

  ///Path Only
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget);
  ///Path and update QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryParameters: {"id": "cow"});
  ///Path and replace QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryParameters: {"id": "cow"}, resetQueryString: true);
  navigateTo<T>({required NavigationTarget navigationTarget, Map<String, String>? queryParameters, bool? resetQueryString = true, T? context}) {
    debugPrint("FRouter: navigateTo: ${navigationTarget.path} ${queryParameters == null ? "without" : "with"} queryString ${queryParameters?.toString() ?? ""}. Reset queryString: $resetQueryString");
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    debugPrint(newQueryState.toString());

    TargetState targetState = TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(targetState: targetState, queryState: newQueryState);
  }

  ///Text based route Only
  ///FRouter.of(context).navigateToRoute(route: String);
  ///Text based route and id
  ///FRouter.of(context).navigateToRoute(route: String, id: String);
  navigateToRoute<T>(BuildContext context, {required String route, String id = ''}) {
    bool idMode = id == '' ? false : true;
    debugPrint("FRouter: navigateToRoute: $route ${idMode ? "into id: $id" : ""}");
    Map<String, String> queryParameters = idMode ? {"id": id} : {};

    NavigationTarget navigationTarget = Fframe.of(context)!.navigationConfig.navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == route);

    QueryState newQueryState = QueryState(queryParameters: queryParameters);

    TargetState targetState = TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(targetState: targetState, queryState: newQueryState);
  }

  ///Only QS (persist path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"});
  ///Only QS (replace path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"}, resetQueryString: true);
  updateQueryString<T>({required Map<String, String> queryParameters, bool? resetQueryString = false}) {
    debugPrint("FRouter: update QueryString to ${queryParameters.toString()}}");
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    debugPrint(newQueryState.toString());

    navigationNotifier.processRouteInformation(queryState: newQueryState);
    // navigationNotifier.uri = Uri.parse("${navigationNotifier.uri!.path}?${queryParameters.entries.map((queryStringEntry) => "${queryStringEntry.key}=${queryStringEntry.value}").join("&")}");
  }

  //Get a value from the QueryString
  bool get isQueryStringEmpty {
    QueryState queryState = ref.read(queryStateProvider);
    return queryState.queryParameters?.isEmpty ?? true;
  }

  //Get a value from the QueryString
  bool hasQueryStringParam(String key) {
    QueryState queryState = ref.read(queryStateProvider);
    return queryState.queryParameters?.containsKey(key) ?? false;
  }

  //Get a value from the QueryString
  String? queryStringParam(String key) {
    QueryState queryState = ref.read(queryStateProvider);
    if ((queryState.queryParameters?.containsKey(key) ?? false) == true) {
      return queryState.queryParameters![key];
    }
    return null;
  }

  ///Request a logout
  signOut() {
    navigationNotifier.signOut();
  }

  ///Notify a login, optionally parse a list of current user roles
  signIn({List<String>? roles}) {
    navigationNotifier.signIn(roles: roles);
  }

  //Current auth state
  bool get isSignedIn {
    return navigationNotifier.isSignedIn;
  }

  NavigationTarget get currentTarget {
    return navigationNotifier.currentTarget.navigationTarget;
  }

  List<NavigationTab> get navigationTabs {
    return navigationNotifier.navigationTabs;
  }

  NavigationConfig get navigationConfig {
    return navigationNotifier.filteredNavigationConfig;
  }

  Widget waitPage({required BuildContext context, String? text}) {
    Fframe.of(context)?.waitText = text;
    return FRouterConfig.instance.navigationConfig.waitPage.contentPane ?? const Center(child: CircularProgressIndicator());
  }

  Widget emptyPage() => FRouterConfig.instance.navigationConfig.emptyPage.contentPane ?? const Center(child: Text("Much empty"));
  Widget errorPage({required BuildContext context}) {
    return FRouterConfig.instance.navigationConfig.errorPage.contentPane ?? const Center(child: Icon((Icons.error)));
  }

  ///Get a drawer for the current context
  Drawer drawer({
    required BuildContext context,
    DrawerHeader? drawerHeader,
    Destination? signOutDestination,
  }) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader ?? const IgnorePointer(),
          ...navigationNotifier.filteredNavigationConfig.navigationTargets
              .where(
                ((NavigationTarget navigationTarget) => navigationTarget.destination != null),
              )
              .map(
                (NavigationTarget navigationTarget) => Column(
                  children: [
                    ListTile(
                      leading: navigationTarget.destination?.icon,
                      title: navigationTarget.destination?.navigationLabel,
                      onTap: () {
                        navigateTo(navigationTarget: navigationTarget);
                        Navigator.pop(context);
                      },
                    ),
                    // Text("${navigationTarget.navigationTabs?.length}"),
                    ...?navigationTarget.navigationTabs
                        ?.where(
                          ((NavigationTab navigationTab) => navigationTab.destination != null),
                        )
                        .map(
                          (NavigationTab navigationTab) => Padding(
                            padding: navigationTab.destination?.padding ??
                                const EdgeInsets.only(
                                  left: 24,
                                ),
                            child: ListTile(
                              leading: navigationTab.destination?.icon,
                              title: navigationTab.destination?.navigationLabel,
                              onTap: () {
                                navigateTo(navigationTarget: navigationTab);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
          if (!navigationNotifier.isSignedIn && navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination != null)
            ListTile(
              leading: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination?.icon,
              title: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination!.navigationLabel,
              onTap: () {
                navigateTo(navigationTarget: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget);
                Navigator.pop(context);
              },
            ),
          if (signOutDestination != null && navigationNotifier.isSignedIn)
            ListTile(
              leading: signOutDestination.icon,
              title: signOutDestination.navigationLabel,
              onTap: () {
                signOut();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  bool get hasTabs {
    return navigationNotifier.hasTabs;
  }

  int get tabLength {
    return navigationNotifier.navigationTabs.length;
  }

  int get currentTab {
    int index = navigationNotifier.navigationTabs.indexWhere(
      (NavigationTab navigationTab) => navigationTab.path == navigationNotifier.currentTarget.navigationTarget.path,
    );
    return index == -1 ? 0 : index;
  }

  tabSwitch({required TabController tabController, required}) {
    if (!tabController.indexIsChanging) {
      NavigationTarget currentTarget = navigationNotifier.currentTarget.navigationTarget;
      NavigationTarget pendingTarget = navigationNotifier.navigationTabs[tabController.index];

      pendingTarget = (pendingTarget.navigationTabs != null && pendingTarget.navigationTabs!.isNotEmpty) ? pendingTarget.navigationTabs!.first : pendingTarget;

      if (currentTarget.path != pendingTarget.path) {
        debugPrint("Switch from ${currentTarget.path} to ${pendingTarget.path}.");
        navigateTo(navigationTarget: pendingTarget);
      }
    }
  }

  List<Tab> tabBar(BuildContext context) {
    return navigationNotifier.navigationTabs
        .where(
          ((NavigationTab navigationTab) => navigationTab.destination != null),
        )
        .map(
          (NavigationTab navigationTab) => Tab(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                navigationTab.destination?.icon ?? const IgnorePointer(),
                (navigationTab.destination?.icon != null && navigationTab.destination?.tabLabel != null) ? const Text(" ") : const IgnorePointer(),
                Text(navigationTab.destination?.tabLabel ?? ''),
                // Text(
                //   L10n.string(
                //     navigationTab.destination?.tabLabel ?? '',
                //     placeholder: navigationTab.destination?.tabLabel ?? '',
                //     namespace: 'global',
                //   ),
                // ),
              ],
            ),
            // text: navigationTab.destination?.tabLabel ?? '',
          ),
        )
        .toList();
  }

  bool get hasSubTabs {
    return navigationNotifier.hasSubTabs;
  }

  int get subTabLength {
    return navigationNotifier.navigationSubTabs.length;
  }

  int get currentSubTab {
    int index = navigationNotifier.navigationSubTabs.indexWhere(
      (NavigationTab navigationTab) {
        debugPrint("currentSubTab: ${navigationTab.path} == ${navigationNotifier.currentTarget.navigationTarget.path}");
        return navigationTab.path == navigationNotifier.currentTarget.navigationTarget.path;
      },
    );
    return index == -1 ? 0 : index;
  }

  List<Tab> subTabBar(BuildContext context) {
    return navigationNotifier.navigationSubTabs
        .where(
          ((NavigationTab navigationTab) => navigationTab.destination != null),
        )
        .map(
          (NavigationTab navigationTab) => Tab(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                navigationTab.destination?.icon ?? const IgnorePointer(),
                (navigationTab.destination?.icon != null && navigationTab.destination?.tabLabel != null) ? const Text(" ") : const IgnorePointer(),
                Text(navigationTab.destination?.tabLabel ?? ''),
              ],
            ),
            // text: navigationTab.destination?.tabLabel ?? '',
          ),
        )
        .toList();
  }

  Widget navigationRail() {
    if (navigationNotifier.filteredNavigationConfig.navigationTargets.length >= 2) {
      return NavigationRail(
        selectedIndex: navigationNotifier.selectedNavRailIndex,
        onDestinationSelected: (int index) {
          if (index < navigationNotifier.filteredNavigationConfig.navigationTargets.length) {
            navigationNotifier.selectedNavRailIndex = index;
            NavigationTarget navigationTarget = navigationNotifier.filteredNavigationConfig.navigationTargets[index];
            navigateTo(navigationTarget: navigationTarget);
          } else {
            debugPrint("Sign in/out action");
            if (isSignedIn) {
              signIn();
            } else {
              NavigationTarget navigationTarget = navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget;
              navigateTo(navigationTarget: navigationTarget);
            }
          }
        },
        labelType: NavigationRailLabelType.all,
        destinations: [
          ...navigationNotifier.filteredNavigationConfig.navigationTargets
              .where(
                ((NavigationTarget navigationTarget) => navigationTarget.destination != null),
              )
              .map(
                (NavigationTarget navigationTarget) => NavigationRailDestination(
                  icon: navigationTarget.destination!.icon,
                  selectedIcon: navigationTarget.destination!.selectedIcon,
                  label: navigationTarget.destination!.navigationLabel, //TODO: parse the label through the l10n first
                  padding: navigationTarget.destination!.padding,
                ),
              ),
          if (!navigationNotifier.isSignedIn && navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination != null)
            NavigationRailDestination(
              icon: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination!.icon,
              selectedIcon: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination!.selectedIcon,
              label: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination!.navigationLabel,
              padding: navigationNotifier.filteredNavigationConfig.signInConfig.signInTarget.destination!.padding,
            ),
        ],
      );
    }
    return const IgnorePointer();
  }

  static FRouter of(BuildContext context) {
    final FRouter? fRouter = context.dependOnInheritedWidgetOfExactType<FRouter>();
    assert(fRouter != null, 'No FRouter found in context');
    return fRouter!;
  }

  @override
  bool updateShouldNotify(FRouter oldWidget) {
    return true;
  }
}

class RouterScreen extends StatefulWidget {
  const RouterScreen({Key? key}) : super(key: key);

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      navigationNotifier.isBuilding = false;
    });
    debugPrint("Build RouterScreen");
    return FRouterConfig.instance.mainScreen;
  }
}
