part of fframe;

class RouterPage extends Page {
  const RouterPage();

  @override
  Route createRoute(BuildContext context) {
    Console.log("RouterPage.createRoute",
        scope: "fframeLog.RouterPage", level: LogLevel.fframe);
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) =>
          Consumer(builder: (context, ref, child) {
        Console.log("Build FRouter",
            scope: "fframeLog.RouterPage", level: LogLevel.fframe);
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
  navigateTo<T>(
      {required NavigationTarget navigationTarget,
      Map<String, String>? queryParameters,
      bool? resetQueryString = true,
      T? context}) {
    Console.log(
      "${navigationTarget.path} ${queryParameters == null ? "without" : "with"} queryString ${queryParameters?.toString() ?? ""}. Reset queryString: $resetQueryString",
      scope: "fframeLog.FRouter.navigateTo",
      level: LogLevel.fframe,
    );
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true)
        ? QueryState(queryParameters: queryParameters)
        : QueryState.mergeComponents(queryState, queryParameters);
    Console.log(
      "Updated to ${newQueryState.toString()}",
      scope: "fframeLog.FRouter.newQueryState",
      level: LogLevel.fframe,
    );

    TargetState targetState =
        TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(
        targetState: targetState, queryState: newQueryState);
  }

  ///Text based route Only
  ///FRouter.of(context).navigateToRoute(route: String);
  ///Text based route and id
  ///FRouter.of(context).navigateToRoute(route: String, id: String);
  navigateToRoute<T>(BuildContext context,
      {required String route, String id = ''}) {
    bool idMode = id == '' ? false : true;
    Console.log("$route ${idMode ? "into id: $id" : ""}",
        scope: "fframeLog.navigateToRoute", level: LogLevel.prod);
    Map<String, String> queryParameters = idMode ? {"id": id} : {};

    NavigationTarget navigationTarget = Fframe.of(context)!
        .navigationConfig
        .navigationTargets
        .firstWhere((NavigationTarget navigationTarget) =>
            navigationTarget.path == route);

    QueryState newQueryState = QueryState(queryParameters: queryParameters);

    TargetState targetState =
        TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(
        targetState: targetState, queryState: newQueryState);
  }

  navigateToRouteFromNavigationTargets<T>(
      List<NavigationTarget> navigationTargets,
      {required String route,
      String id = ''}) {
    bool idMode = id == '' ? false : true;
    Console.log(
      "Updated to $route ${idMode ? "into id: $id" : ""}",
      scope: "fframeLog.FRouter.navigateToRouteFromNavigationTargets",
      level: LogLevel.prod,
    );
    Map<String, String> queryParameters = idMode ? {"id": id} : {};
    List<String> routeSegments = route.split('/');
    String selector1 = routeSegments[0];
    String selector2 = routeSegments[0];
    NavigationTarget? target;

    for (int i = 0; i < routeSegments.length; i++) {
      if (i == 0) {
        target = navigationTargets.firstWhere(
            (NavigationTarget navigationTarget) =>
                navigationTarget.path == selector1);
      } else {
        String segment = routeSegments[i];
        selector1 += "/${routeSegments[i - 1]}/$segment";
        selector2 += "/$segment";
        target = target!.navigationTabs!.firstWhere((NavigationTab tab) =>
            (tab.path == selector1 || tab.path == selector2));
      }
    }

    //NavigationTarget navigationTarget = navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == routeSegments.last);

    QueryState newQueryState = QueryState(queryParameters: queryParameters);

    TargetState targetState =
        TargetState.processRouteRequest(navigationTarget: target!);
    navigationNotifier.processRouteInformation(
        targetState: targetState, queryState: newQueryState);
  }

  ///Only QS (persist path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"});
  ///Only QS (replace path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"}, resetQueryString: true);
  updateQueryString<T>(
      {required Map<String, String> queryParameters,
      bool? resetQueryString = false}) {
    Console.log(
      "Updated QueryString to ${queryParameters.toString()}}",
      scope: "fframeLog.FRouter.updateQueryString",
      level: LogLevel.fframe,
    );
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true)
        ? QueryState(queryParameters: queryParameters)
        : QueryState.mergeComponents(queryState, queryParameters);
    Console.log(
      newQueryState.toString(),
      scope: "fframeLog.FRouter.updateQueryString",
      level: LogLevel.fframe,
    );

    navigationNotifier.processRouteInformation(queryState: newQueryState);
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
    return FRouterConfig.instance.navigationConfig.waitPage.contentPane ??
        const Center(child: CircularProgressIndicator());
  }

  Widget emptyPage() =>
      FRouterConfig.instance.navigationConfig.emptyPage.contentPane ??
      const Center(child: Text("Much empty"));
  Widget errorPage({required BuildContext context}) {
    return FRouterConfig.instance.navigationConfig.errorPage.contentPane ??
        const Center(child: Icon((Icons.error)));
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
                ((NavigationTarget navigationTarget) =>
                    navigationTarget.destination != null),
              )
              .map(
                (NavigationTarget navigationTarget) => Column(
                  children: [
                    ListTile(
                      leading: navigationTarget.destination?.icon,
                      title: navigationTarget.destination?.navigationLabel(),
                      onTap: () {
                        navigateTo(navigationTarget: navigationTarget);
                        Navigator.pop(context);
                      },
                    ),
                    // Text("${navigationTarget.navigationTabs?.length}"),
                    ...?navigationTarget.navigationTabs
                        ?.where(
                          ((NavigationTab navigationTab) =>
                              navigationTab.destination != null),
                        )
                        .map(
                          (NavigationTab navigationTab) => Padding(
                            padding: navigationTab.destination?.padding ??
                                const EdgeInsets.only(
                                  left: 24,
                                ),
                            child: ListTile(
                              leading: navigationTab.destination?.icon,
                              title:
                                  navigationTab.destination?.navigationLabel(),
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
          if (!navigationNotifier.isSignedIn &&
              navigationNotifier.filteredNavigationConfig.signInConfig
                      .signInTarget.destination !=
                  null)
            ListTile(
              leading: navigationNotifier.filteredNavigationConfig.signInConfig
                  .signInTarget.destination?.icon,
              title: navigationNotifier.filteredNavigationConfig.signInConfig
                  .signInTarget.destination!
                  .navigationLabel(),
              onTap: () {
                navigateTo(
                    navigationTarget: navigationNotifier
                        .filteredNavigationConfig.signInConfig.signInTarget);
                Navigator.pop(context);
              },
            ),
          if (signOutDestination != null && navigationNotifier.isSignedIn)
            ListTile(
              leading: signOutDestination.icon,
              title: signOutDestination.navigationLabel(),
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
      (NavigationTab navigationTab) =>
          navigationTab.path ==
          navigationNotifier.currentTarget.navigationTarget.path,
    );
    return index == -1 ? 0 : index;
  }

  tabSwitch({required TabController tabController, required}) {
    if (!tabController.indexIsChanging) {
      NavigationTarget currentTarget =
          navigationNotifier.currentTarget.navigationTarget;
      NavigationTarget pendingTarget =
          navigationNotifier.navigationTabs[tabController.index];

      pendingTarget = (pendingTarget.navigationTabs != null &&
              pendingTarget.navigationTabs!.isNotEmpty)
          ? pendingTarget.navigationTabs!.first
          : pendingTarget;

      if (currentTarget.path != pendingTarget.path) {
        Console.log(
          "Switch from ${currentTarget.path} to ${pendingTarget.path}.",
          scope: "fframeLog.FRouter.tabSwitch",
          level: LogLevel.prod,
        );
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
                (navigationTab.destination?.icon != null &&
                        navigationTab.destination?.tabLabel != null)
                    ? const Text(" ")
                    : const IgnorePointer(),
                Text(navigationTab.destination?.tabLabel!() ?? ''),
              ],
            ),
            // text: navigationTab.destination?.tabLabel ?? '',
          ),
        )
        .toList();
  }

  Widget navigationRail() {
    if (navigationNotifier.filteredNavigationConfig.navigationTargets.length >=
        2) {
      return NavigationRail(
        selectedIndex: navigationNotifier.selectedNavRailIndex,
        onDestinationSelected: (int index) {
          if (index <
              navigationNotifier
                  .filteredNavigationConfig.navigationTargets.length) {
            navigationNotifier.selectedNavRailIndex = index;
            NavigationTarget navigationTarget = navigationNotifier
                .filteredNavigationConfig.navigationTargets[index];
            navigateTo(navigationTarget: navigationTarget);
          } else {
            Console.log(
              "Sign in/out action",
              scope: "fframeLog.FRouter.navigationRail",
              level: LogLevel.fframe,
            );

            if (isSignedIn) {
              signIn();
            } else {
              NavigationTarget navigationTarget = navigationNotifier
                  .filteredNavigationConfig.signInConfig.signInTarget;
              navigateTo(navigationTarget: navigationTarget);
            }
          }
        },
        labelType: NavigationRailLabelType.all,
        destinations: [
          ...navigationNotifier.filteredNavigationConfig.navigationTargets
              .where(
                ((NavigationTarget navigationTarget) =>
                    navigationTarget.destination != null),
              )
              .map(
                (NavigationTarget navigationTarget) =>
                    NavigationRailDestination(
                  icon: navigationTarget.destination!.icon,
                  selectedIcon: navigationTarget.destination!.selectedIcon,
                  label: navigationTarget.destination!.navigationLabel(),
                  padding: navigationTarget.destination!.padding,
                ),
              ),
          if (!navigationNotifier.isSignedIn &&
              navigationNotifier.filteredNavigationConfig.signInConfig
                      .signInTarget.destination !=
                  null)
            NavigationRailDestination(
              icon: navigationNotifier.filteredNavigationConfig.signInConfig
                  .signInTarget.destination!.icon,
              selectedIcon: navigationNotifier.filteredNavigationConfig
                  .signInConfig.signInTarget.destination!.selectedIcon,
              label: navigationNotifier.filteredNavigationConfig.signInConfig
                  .signInTarget.destination!
                  .navigationLabel(),
              padding: navigationNotifier.filteredNavigationConfig.signInConfig
                  .signInTarget.destination!.padding,
            ),
        ],
      );
    }
    return const IgnorePointer();
  }

  static FRouter of(BuildContext context) {
    final FRouter? fRouter =
        context.dependOnInheritedWidgetOfExactType<FRouter>();
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
    Console.log("Build RouterScreen",
        scope: "fframeLog.RouterScreen", level: LogLevel.fframe);
    Future.delayed(Duration.zero, () {
      navigationNotifier.isBuilding = false;
    });
    return FRouterConfig.instance.mainScreen;
  }
}
