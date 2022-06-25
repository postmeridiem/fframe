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
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryString: {"id": "cow"});
  ///Path and replace QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryString: {"id": "cow"}, resetQueryString: true);
  navigateTo<T>({required NavigationTarget navigationTarget, Map<String, String>? queryParameters, bool? resetQueryString = true, T? context}) {
    debugPrint("FRouter: navigate to ${navigationTarget.path} ${queryParameters == null ? "without" : "with"} queryString ${queryParameters?.toString() ?? ""}. Reset queryString: $resetQueryString");
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    debugPrint(newQueryState.toString());

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
    return navigationNotifier.navigationConfig;
  }

  Widget get waitPage => RouterConfig.instance.navigationConfig.waitPage.contentPane ?? const Center(child: CircularProgressIndicator());
  Widget get errorPage => RouterConfig.instance.navigationConfig.errorPage.contentPane ?? const Center(child: Icon((Icons.error)));
  Widget get emptyPage => RouterConfig.instance.navigationConfig.emptyPage.contentPane ?? const Center(child: Text("Much empty"));

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
          if (!navigationNotifier.isSignedIn && navigationNotifier.navigationConfig.signInConfig.signInTarget.destination != null)
            ListTile(
              leading: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination?.icon,
              title: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.navigationLabel,
              onTap: () {
                navigateTo(navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget);
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
    return navigationNotifier.navigationTabs.indexWhere(
      (NavigationTab navigationTab) => navigationTab.path == navigationNotifier.currentTarget.navigationTarget.path,
    );
  }

  tabSwitch({required TabController tabController, required}) {
    if (!tabController.indexIsChanging) {
      NavigationTarget currentTarget = navigationNotifier.currentTarget.navigationTarget;
      NavigationTarget pendingTarget = navigationNotifier.navigationTabs[tabController.index];
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
            icon: navigationTab.destination?.icon,
            text: navigationTab.destination?.tabLabel ?? '',
          ),
        )
        .toList();
  }

  Widget navigationRail() {
    if (navigationNotifier.navigationConfig.navigationTargets.length >= 2) {
      return NavigationRail(
        selectedIndex: navigationNotifier.selectedNavRailIndex,
        onDestinationSelected: (int index) {
          if (index < navigationNotifier.navigationConfig.navigationTargets.length) {
            navigationNotifier.selectedNavRailIndex = index;
            NavigationTarget navigationTarget = navigationNotifier.navigationConfig.navigationTargets[index];
            navigateTo(navigationTarget: navigationTarget);
          } else {
            debugPrint("Sign in/out action");
            if (isSignedIn) {
              signIn();
            } else {
              NavigationTarget navigationTarget = navigationNotifier.navigationConfig.signInConfig.signInTarget;
              navigateTo(navigationTarget: navigationTarget);
            }
          }
        },
        labelType: NavigationRailLabelType.all,
        destinations: [
          ...navigationNotifier.navigationConfig.navigationTargets
              .where(
                ((NavigationTarget navigationTarget) => navigationTarget.destination != null),
              )
              .map(
                (NavigationTarget navigationTarget) => NavigationRailDestination(
                  icon: navigationTarget.destination!.icon,
                  selectedIcon: navigationTarget.destination!.selectedIcon,
                  label: navigationTarget.destination!.navigationLabel,
                  padding: navigationTarget.destination!.padding,
                ),
              ),
          if (!navigationNotifier.isSignedIn && navigationNotifier.navigationConfig.signInConfig.signInTarget.destination != null)
            NavigationRailDestination(
              icon: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.icon,
              selectedIcon: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.selectedIcon,
              label: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.navigationLabel,
              padding: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.padding,
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
    return RouterConfig.instance.mainScreen;
  }
}
