part of '../fframe.dart';

class RouterPage extends Page {
  const RouterPage();

  @override
  Route createRoute(BuildContext context) {
    Console.log("RouterPage.createRoute", scope: "fframeLog.RouterPage", level: LogLevel.fframe);
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Consumer(builder: (context, ref, child) {
        Console.log("Build FRouter", scope: "fframeLog.RouterPage", level: LogLevel.fframe);
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
    super.key,
    required this.ref,
    // required this.signedIn,
    // this.roles,
  }) : super(child: const RouterScreen());
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
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    // Console.log(
    //   "${navigationTarget.path} ${queryParameters == null ? "without" : "with"} queryString ${queryParameters?.toString() ?? ""}. Reset queryString: $resetQueryString",
    //   scope: "fframeLog.FRouter.navigateTo",
    //   level: LogLevel.fframe,
    // );
    Console.log(
      "Update route to /${navigationTarget.path} with query: `${newQueryState.toString()}`. Reset queryString: $resetQueryString",
      scope: "fframeLog.FRouter.navigateTo",
      level: LogLevel.prod,
    );

    TargetState targetState = TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(targetState: targetState, queryState: newQueryState);
  }

  ///Text based route Only
  ///FRouter.of(context).navigateToRoute(route: String);
  ///Text based route and id
  ///FRouter.of(context).navigateToRoute(route: String, id: String);
  navigateToRoute<T>(BuildContext context, {required String route, String id = ''}) {
    bool idMode = id == '' ? false : true;
    Console.log("Update route to $route ${idMode ? "into id: $id" : ""}", scope: "fframeLog.navigateToRoute", level: LogLevel.prod);
    Map<String, String> queryParameters = idMode ? {"id": id} : {};

    NavigationTarget navigationTarget = Fframe.of(context)!.navigationConfig.navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == route);

    QueryState newQueryState = QueryState(queryParameters: queryParameters);

    TargetState targetState = TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(targetState: targetState, queryState: newQueryState);
  }

  navigateToRouteFromNavigationTargets<T>(List<NavigationTarget> navigationTargets, {required String route, String id = ''}) {
    bool idMode = id == '' ? false : true;
    Console.log(
      "Update route to $route ${idMode ? "into id: $id" : ""}",
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
        target = navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == selector1);
      } else {
        String segment = routeSegments[i];
        selector1 += "/${routeSegments[i - 1]}/$segment";
        selector2 += "/$segment";
        target = target!.navigationTabs!.firstWhere((NavigationTab tab) => (tab.path == selector1 || tab.path == selector2));
      }
    }

    //NavigationTarget navigationTarget = navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == routeSegments.last);

    QueryState newQueryState = QueryState(queryParameters: queryParameters);

    TargetState targetState = TargetState.processRouteRequest(navigationTarget: target!);
    navigationNotifier.processRouteInformation(targetState: targetState, queryState: newQueryState);
  }

  ///Only QS (persist path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"});
  ///Only QS (replace path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"}, resetQueryString: true);
  updateQueryString<T>({required Map<String, String> queryParameters, bool? resetQueryString = false}) {
    Console.log(
      "Updated QueryString to ${queryParameters.toString()}}",
      scope: "fframeLog.FRouter.updateQueryString",
      level: LogLevel.fframe,
    );
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
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
    // navigationNotifier.signOut();
  }

  // ///Notify a login, optionally parse a list of current user roles
  // signIn({List<String>? roles}) {
  //   navigationNotifier.signIn(roles: roles);
  // }

  //Current auth state
  bool get isSignedIn {
    return navigationNotifier.isSignedIn;
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
          ...navigationNotifier.navigationConfig.navigationTargets
              .where(
                ((NavigationTarget navigationTarget) => navigationTarget.destination != null),
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
                              title: navigationTab.destination?.navigationLabel(),
                              onTap: () {
                                navigateTo(navigationTarget: navigationTab);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                  ],
                ),
              ),
          if (!navigationNotifier.isSignedIn && navigationNotifier.navigationConfig.signInConfig.signInTarget.destination != null)
            ListTile(
              leading: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination?.icon,
              title: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.navigationLabel(),
              onTap: () {
                navigateTo(navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget);
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
    Console.log(
      "Check if there are tabs",
      scope: "fframeLog.FRouter.hasTabs",
      level: LogLevel.prod,
    );
    return navigationNotifier.hasTabs;
  }

  int get tabLength {
    Console.log(
      "Count the amount of tabs",
      scope: "fframeLog.FRouter.tabLength",
      level: LogLevel.prod,
      color: ConsoleColor.yellow,
    );
    return navigationNotifier.navigationTabs.length;
  }

  int get currentTab {
    Console.log(
      "Define the current tab",
      scope: "fframeLog.FRouter.currentTab",
      level: LogLevel.prod,
      color: ConsoleColor.yellow,
    );
    int index = navigationNotifier.navigationTabs.indexWhere(
      (NavigationTab navigationTab) => navigationTab.path == navigationNotifier.currentTarget!.navigationTarget.path,
    );
    debugger(when: index == -1);
    return index == -1 ? 0 : index;
  }

  tabSwitch({required TabController tabController, required}) {
    Console.log(
      "Change from one tab to another tab",
      scope: "fframeLog.FRouter.tabSwitch",
      level: LogLevel.prod,
      color: ConsoleColor.yellow,
    );
    if (!tabController.indexIsChanging) {
      NavigationTarget currentTarget = navigationNotifier.currentTarget!.navigationTarget;
      NavigationTarget pendingTarget = navigationNotifier.navigationTabs[tabController.index];

      pendingTarget = (pendingTarget.navigationTabs != null && pendingTarget.navigationTabs!.isNotEmpty) ? pendingTarget.navigationTabs!.first : pendingTarget;

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
    List<Tab> filteredTabs = navigationNotifier.navigationTabs
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
                Text(navigationTab.destination?.tabLabel!() ?? ''),
              ],
            ),
            // text: navigationTab.destination?.tabLabel ?? '',
          ),
        )
        .toList();
    return filteredTabs;
  }

  Widget navigationRail() {
    return AnimatedBuilder(
        animation: navigationNotifier,
        builder: (context, child) {
          List<NavigationRailDestination> destinations = [
            ...navigationNotifier.navigationConfig.navigationTargets
                .where(
                  ((NavigationTarget navigationTarget) => navigationTarget.destination != null),
                )
                .map(
                  (NavigationTarget navigationTarget) => NavigationRailDestination(
                    icon: navigationTarget.destination!.icon,
                    selectedIcon: navigationTarget.destination!.selectedIcon,
                    label: navigationTarget.destination!.navigationLabel(),
                    padding: navigationTarget.destination!.padding,
                  ),
                ),
            if (!navigationNotifier.isSignedIn && navigationNotifier.navigationConfig.signInConfig.signInTarget.destination != null)
              NavigationRailDestination(
                icon: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.icon,
                selectedIcon: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.selectedIcon,
                label: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.navigationLabel(),
                padding: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.padding,
              ),
          ];

          if (navigationNotifier.navigationConfig.navigationTargets.length >= 2) {
            navigationNotifier.selectedNavRailIndex = 0;
            NavigationTarget? currentTarget = navigationNotifier.currentTarget?.navigationTarget;

            if (currentTarget != null) {
              for (NavigationTarget navigationTarget in navigationNotifier.navigationConfig.navigationTargets.where(
                ((NavigationTarget navigationTarget) => navigationTarget.destination != null),
              )) {
                if (currentTarget.path == navigationTarget.path) {
                  //This is a single-item path
                  break; //Jump from the loop
                } else if (currentTarget.path.startsWith("${navigationTarget.path}/")) {
                  //This is a subpath
                  break; //Jump from the loop
                } else {
                  navigationNotifier.selectedNavRailIndex = navigationNotifier.selectedNavRailIndex! + 1;
                }
              }
            }

            if (navigationNotifier.selectedNavRailIndex == null || navigationNotifier.selectedNavRailIndex! < 0 || navigationNotifier.selectedNavRailIndex! > navigationNotifier.navigationConfig.navigationTargets.length) {
              navigationNotifier.selectedNavRailIndex = 0;
            }

            //Prevent null values
            // print(navigationNotifier.selectedNavRailIndex);
            // navigationNotifier.selectedNavRailIndex == 0 ? navigationNotifier.selectedNavRailIndex = 1 : navigationNotifier.selectedNavRailIndex;
            // debugger(when: navigationNotifier.selectedNavRailIndex == null);
            // debugger(when: navigationNotifier.selectedNavRailIndex! < destinations.length);

            return NavigationRail(
              selectedIndex: navigationNotifier.selectedNavRailIndex,
              onDestinationSelected: (int index) {
                if (index < navigationNotifier.navigationConfig.navigationTargets.length) {
                  navigationNotifier.selectedNavRailIndex = index;
                  NavigationTarget navigationTarget = navigationNotifier.navigationConfig.navigationTargets[index];
                  navigateTo(navigationTarget: navigationTarget);
                } else {
                  Console.log(
                    "Sign in/out action",
                    scope: "fframeLog.FRouter.navigationRail",
                    level: LogLevel.fframe,
                  );

                  if (!isSignedIn) {
                    NavigationTarget navigationTarget = navigationNotifier.navigationConfig.signInConfig.signInTarget;
                    navigateTo(navigationTarget: navigationTarget);
                  }
                }
              },
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
            );
          }
          return const IgnorePointer();
        });
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
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => navigationNotifier.markBuildDone());
  }

  @override
  Widget build(BuildContext context) {
    Console.log("Build RouterScreen", scope: "fframeLog.RouterScreen", level: LogLevel.fframe);
    return FRouterConfig.instance.mainScreen;
  }
}
