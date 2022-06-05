import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frouter/models/initial_config.dart';
import 'package:frouter/services/navigation_service.dart';

import '../models/models.dart';

class RouterPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    debugPrint("RouterPage.createRoute");
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Consumer(builder: (context, ref, child) {
        debugPrint("Build FRouter");
        return FRouter(
          ref: ref,
          child: const RouterScreen(),
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
    required Widget child,
    required this.ref,
  }) : super(key: key, child: child);
  final WidgetRef ref;

  ///Path Only
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget);
  ///Path and update QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryString: {"id": "cow"});
  ///Path and replace QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryString: {"id": "cow"}, resetQueryString: true);
  navigateTo({required NavigationTarget navigationTarget, Map<String, String>? queryParameters, bool? resetQueryString = true}) {
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
  updateQueryString({required Map<String, String> queryParameters, bool? resetQueryString = false}) {
    debugPrint("FRouter: update QueryString to ${queryParameters.toString()}");
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    debugPrint(newQueryState.toString());

    navigationNotifier.processRouteInformation(queryState: newQueryState);
    // navigationNotifier.uri = Uri.parse("${navigationNotifier.uri!.path}?${queryParameters.entries.map((queryStringEntry) => "${queryStringEntry.key}=${queryStringEntry.value}").join("&")}");
  }

  ///Notify a logout
  logout() {
    navigationNotifier.signOut();
  }

  ///Notify a login, optionally parse a list of current user roles
  login({List<String>? roles}) {
    navigationNotifier.signIn(roles: roles);
  }

  bool get isSignedIn {
    return navigationNotifier.isSignedIn;
  }

  NavigationConfig get navigationConfig {
    return navigationNotifier.navigationConfig;
  }

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
                      title: navigationTarget.destination?.label,
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
                              title: navigationTab.destination?.label,
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
              title: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.label,
              onTap: () {
                navigateTo(navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget);
                Navigator.pop(context);
              },
            ),
          if (signOutDestination != null && navigationNotifier.isSignedIn)
            ListTile(
              leading: signOutDestination.icon,
              title: signOutDestination.label,
              onTap: () {
                logout();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  NavigationRail navigationRail({NavigationRailDestination? signOutDestination}) {
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
            logout();
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
                label: navigationTarget.destination!.label,
                padding: navigationTarget.destination!.padding,
              ),
            ),
        if (!navigationNotifier.isSignedIn && navigationNotifier.navigationConfig.signInConfig.signInTarget.destination != null)
          NavigationRailDestination(
            icon: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.icon,
            selectedIcon: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.selectedIcon,
            label: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.label,
            padding: navigationNotifier.navigationConfig.signInConfig.signInTarget.destination!.padding,
          ),
        if (signOutDestination != null && navigationNotifier.isSignedIn) signOutDestination,
      ],
    );
  }

  // Consumer contentBuilder({required DocumentBuilder documentBody, required EmptyPageBuilder emptyPage}) {
  //   // return const Text("xx");
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       TargetState targetState = ref.watch(targetStateProvider);
  //       QueryState queryState = ref.watch(queryStateProvider);
  //       debugPrint("ReSpawn DocumentBody for ${targetState.navigationTarget.title} ${queryState.queryString} ");
  //       Widget returnWidget = queryState.queryString.isEmpty
  //           ? documentBody(
  //               context,
  //               ValueKey(queryState.queryString),
  //               queryState,
  //             )
  //           : emptyPage(context);
  //       // return returnWidget;
  //       return AnimatedSwitcher(
  //         key: ValueKey("query_${key.toString()}"),
  //         duration: const Duration(milliseconds: 250),
  //         child: returnWidget,
  //       );
  //     },
  //   );
  // }

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

typedef DocumentBuilder = Widget Function(BuildContext context, Key key, QueryState queryState);
typedef EmptyPageBuilder = Widget Function(BuildContext context);
