import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';
import 'package:flutter/material.dart';
import 'package:fframe/providers/state_providers.dart';

late NavigationNotifier navigationNotifier;

final navigationProvider = ChangeNotifierProvider<NavigationNotifier>((ref) {
  return NavigationNotifier(ref: ref);
});

class NextState {
  NextState({
    required this.targetState,
    required this.queryState,
  });

  final TargetState targetState;
  final QueryState queryState;
}

class NavigationNotifier extends ChangeNotifier {
  final Ref ref;
  Uri? _uri;
  List<NextState> nextState = [];

  TargetState? _targetState;
  QueryState? _queryState;
  // NavigationTarget? _postSignInTarget;
  bool _isbuilding = false;
  bool _buildPending = false;

  bool? _isSignedIn;
  List<String>? _roles;

  final NavigationConfig navigationConfig =
      FRouterConfig.instance.navigationConfig;
  late NavigationConfig filteredNavigationConfig =
      FRouterConfig.instance.navigationConfig;

  NavigationNotifier({required this.ref}) {
    _filterNavigationRoutes();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) => authChangeListener(user));
  }

  int selectedNavRailIndex = 0;
  bool get pendingAuth => _isSignedIn == null;
  bool get isSignedIn => _isSignedIn ?? false;

  authChangeListener(User? user) async {
    if (user != null) {
      try {
        IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        List<String>? roles = [];

        Map<String, dynamic>? claims = idTokenResult.claims;

        if (claims != null && claims.containsKey("roles") == true) {
          Console.log(
            "Has roles in ${claims["roles"].runtimeType}",
            scope: "fframeLog.NavigationNotifier.authChangeListener",
            level: LogLevel.dev,
          );

          if ("${claims["roles"].runtimeType}".toLowerCase() ==
              "JSArray<dynamic>".toLowerCase()) {
            roles = List<String>.from(claims["roles"]);
          } else if (List<dynamic> == claims["roles"].runtimeType ||
              List<String> == claims["roles"].runtimeType) {
            roles = List<String>.from(claims["roles"]);
          } else {
            //Legacy mode... it's a map..
            Map<String, dynamic>? rolesMap =
                Map<String, dynamic>.from(claims["roles"]);
            rolesMap.removeWhere((key, value) => value == false);
            roles = List<String>.from(rolesMap.keys);
          }
        }
        roles = roles.map((role) => role.toLowerCase()).toList();
        Console.log(
          "User is signed in as ${user.uid} ${user.displayName} with roles: ${roles.join(", ")}",
          scope: "fframeLog.NavigationNotifier.authChangeListener",
          level: LogLevel.dev,
        );
        signIn(roles: roles);
      } catch (e) {
        Console.log(
          "ERROR: Unable to interpret claims ${e.toString()}",
          scope: "fframeLog.NavigationNotifier.authChangeListener",
          level: LogLevel.dev,
        );
        signIn();
      }
    } else {
      signOut();
    }
  }

  signIn({List<String>? roles}) {
    _roles = roles;
    _isSignedIn = true;
    _filterNavigationRoutes();
    TargetState? targetState = TargetState.defaultRoute();
    QueryState? queryState = QueryState.defaultroute();
    if (navigationNotifier.nextState.isNotEmpty) {
      navigationNotifier.nextState.removeAt(0);
    }
    processRouteInformation(targetState: targetState, queryState: queryState);
  }

  signOut() {
    _roles = null;
    _isSignedIn = false;

    _filterNavigationRoutes();
    TargetState? targetState = TargetState.defaultRoute();
    QueryState? queryState = QueryState(queryParameters: null);
    processRouteInformation(targetState: targetState, queryState: queryState);
  }

  TargetState get currentTarget {
    return _targetState!;
  }

  bool get hasTabs {
    return _targetState!.navigationTarget is NavigationTab;
  }

  bool get hasSubTabs {
    // if (_targetState == null) {
    //   return false;
    // }

    if (_targetState!.navigationTarget is NavigationTab) {
      NavigationTab navigationTab =
          _targetState!.navigationTarget as NavigationTab;
      return navigationTab.navigationTabs != null ||
          (navigationTab.navigationTabs != null &&
              navigationTab.navigationTabs!.isNotEmpty) ||
          (navigationTab.parentTarget is NavigationTab);
    }
    return false;
    // return _targetState!.navigationTarget.navigationTabs != null || (_targetState!.navigationTarget.navigationTabs != null && _targetState!.navigationTarget.navigationTabs!.isNotEmpty);
  }

  List<NavigationTab> get navigationTabs {
    if (_targetState!.navigationTarget is NavigationTab) {
      NavigationTab currentTab =
          _targetState!.navigationTarget as NavigationTab;
      NavigationTarget parentTarget = currentTab.parentTarget;
      return parentTarget.navigationTabs!;
    }
    return [];
  }

  // List<NavigationTab> get navigationSubTabs {
  //   if (hasSubTabs) {
  //     NavigationTab currentTab = _targetState!.navigationTarget as NavigationTab;
  //     if ((currentTab.parentTarget is NavigationTab)) {
  //       return currentTab.parentTarget.navigationTabs!;
  //     }
  //     return currentTab.navigationTabs!;
  //   }
  //   return [];
  // }

  _filterNavigationRoutes() {
    filteredNavigationConfig = NavigationConfig.clone(navigationConfig);
    FRouterConfig.instance.filteredNavigationConfig = filteredNavigationConfig;
    if (_isSignedIn ?? false) {
      //Check routes for roles
      filteredNavigationConfig.navigationTargets.removeWhere(
        (NavigationTarget navigationTarget) {
          //Remove all routes which are not private
          if (navigationTarget.private == false) {
            return true;
          }

          //If the user does not have roles. return true
          if (_roles == null) {
            return true;
          }

          //Role comparison
          Set<String> userRolesSet =
              _roles!.map((role) => role.toLowerCase()).toSet();
          List<String> targetRoles = navigationTarget.roles ?? [];

          //Check tabs first(if any)
          if (navigationTarget.navigationTabs != null) {
            //Get all roles allowed to see this tab.
            navigationTarget.navigationTabs!
                .where((NavigationTab navigationTab) =>
                    navigationTab.roles != null)
                .forEach((NavigationTab navigationTab) {
              targetRoles.addAll(navigationTab.roles!);
            });

            navigationTarget.navigationTabs!
                .removeWhere((NavigationTab navigationTab) {
              //If the tab is not private, remove it
              if (navigationTab.private == false) {
                return true;
              }
              //If the tab has no role limitations, allow it
              if (navigationTab.roles == null) {
                return false;
              }

              //Check if the intersection contains a value. If so return false
              Set<String> targetRolesSet = navigationTab.roles!
                  .map((role) => role.toLowerCase())
                  .toSet();
              Set<String> interSection =
                  userRolesSet.intersection(targetRolesSet);
              Console.log(
                "${navigationTarget.title}/${navigationTab.title} => ${interSection.isEmpty ? "no access" : "access"} (user: ${userRolesSet.toString()} router: ${targetRolesSet.toString()})",
                scope: "fframeLog.NavigationNotifier._filterNavigationRoutes",
                level: LogLevel.fframe,
              );
              return interSection.isEmpty;
            });
          }

          if (targetRoles.isEmpty) {
            //No role based limitations apply
            Console.log(
              "${navigationTarget.title} => allow",
              scope: "fframeLog.NavigationNotifier._filterNavigationRoutes",
              level: LogLevel.fframe,
            );
            return false;
          }

          //Check if the intersection contains a value. If so return false
          Set<String> targetRolesSet =
              targetRoles.map((role) => role.toLowerCase()).toSet();

          Set<String> interSection = userRolesSet.intersection(targetRolesSet);
          Console.log(
            "${navigationTarget.title} => ${interSection.isEmpty ? "no access" : "access"} (user: ${userRolesSet.toString()} router: ${targetRolesSet.toString()})",
            scope: "fframeLog.NavigationNotifier._filterNavigationRoutes",
            level: LogLevel.fframe,
          );
          return interSection.isEmpty;
        },
      );
    } else {
      //Not signed in. Keep public routes
      filteredNavigationConfig.navigationTargets
          .removeWhere((NavigationTarget navigationTarget) {
        if (navigationTarget.navigationTabs != null) {
          List<NavigationTab> navigationTabs =
              _filterTabRoutes(navigationTarget.navigationTabs!);
          return navigationTabs.isEmpty;
        }

        return navigationTarget.public == false;
      });
    }
  }

  List<NavigationTab> _filterTabRoutes(List<NavigationTab> navigationTabs) {
    if (_isSignedIn ?? false) {
      navigationTabs.removeWhere((NavigationTab navigationTab) {
        //Signed in. Keep private routes
        if (navigationTab.private == false) {
          return true;
        }

        //If the target does not require roles. Return true
        if (navigationTab.roles == null) {
          return false;
        }

        //If the user does not have roles. return true
        if (_roles == null) {
          return true;
        }

        //Check if the intersection contains a value. If so return false
        Set<String> userRoles = _roles!.toSet();
        Set<String> targetRoles = navigationTab.roles!.toSet();

        Set<String> interSection = userRoles.intersection(targetRoles);
        return interSection.isEmpty;
      });
    } else {
      //Not signed in. Keep public routes
      navigationTabs.removeWhere(
        (NavigationTab navigationTab) => navigationTab.public == false,
      );
    }

    return navigationTabs;
  }

  parseRouteInformation({required Uri uri}) {
    Console.log(
      "$uri for ${uri.userInfo}",
      scope: "fframeLog.NavigationNotifier.parseRouteInformation",
      level: LogLevel.fframe,
    );

    TargetState? targetState = TargetState.fromUri(uri);
    QueryState? queryState = QueryState.fromUri(uri);

    if (uri.path != "/") {
      Console.log(
        "Store initial link for later use: ${targetState.navigationTarget.title} ${queryState.queryString}",
        scope: "fframeLog.NavigationNotifier.parseRouteInformation",
        level: LogLevel.fframe,
      );
      nextState
          .add(NextState(targetState: targetState, queryState: queryState));
    }

    Console.log(
      "${targetState.navigationTarget.path} :: ${queryState.toString()}",
      scope: "fframeLog.NavigationNotifier.parseRouteInformation",
      level: LogLevel.fframe,
    );

    processRouteInformation(targetState: targetState, queryState: queryState);
  }

  processRouteInformation({TargetState? targetState, QueryState? queryState}) {
    _targetState = targetState ?? ref.read(targetStateProvider);
    _queryState = queryState ?? ref.read(queryStateProvider);

    uri = composeUri();
  }

  Uri composeUri() {
    String pathComponent = (_targetState == null)
        ? _uri?.path ?? "/"
        : _targetState!.navigationTarget.path;
    String queryComponent =
        (_queryState == null) ? _uri?.query ?? "" : _queryState!.queryString;
    Uri uri = Uri.parse(
        "/$pathComponent${queryComponent != "" ? "?$queryComponent" : ""}"
            .replaceAll("//", "/"));
    //Trigger the setter and te external method with it;
    Console.log(
      "compose URI: ${uri.toString()}",
      scope: "fframeLog.NavigationNotifier.parseRouteInformation",
      level: LogLevel.fframe,
    );
    return uri;
  }

  String restoreRouteInformation() {
    return composeUri().toString();
  }

  Uri? get uri {
    return _uri;
  }

  set uri(Uri? uri) {
    Console.log(
      "NavigationService.setUri: ${uri.toString()} was: $_uri",
      scope: "fframeLog.NavigationNotifier.uri",
      level: LogLevel.fframe,
    );

    if (_uri == uri) {
      return;
    }

    if (_uri == null) {
      Console.log(
        "New load, schedule build. Building: $_isbuilding",
        scope: "fframeLog.NavigationNotifier.uri",
        level: LogLevel.fframe,
      );
      _uri = uri;
      _buildPending = true;
    } else {
      _uri = uri;
    }

    if (_isbuilding != false || _buildPending != true) {
      updateProviders();
      notifyListeners();
    } else {
      Console.log(
        "Schedule delayed build",
        scope: "fframeLog.NavigationNotifier.uri",
        level: LogLevel.fframe,
      );
    }
  }

  updateProviders() {
    StateController<TargetState> targetStateNotifier =
        ref.read(targetStateProvider.notifier);
    StateController<QueryState> queryStateNotifier =
        ref.read(queryStateProvider.notifier);

    if (targetStateNotifier.state.navigationTarget.path !=
        _targetState!.navigationTarget.path) {
      Console.log(
        "Update targetState to ${_targetState!.navigationTarget.title} ${_targetState!.navigationTarget.path}",
        scope: "fframeLog.NavigationNotifier.updateProviders",
        level: LogLevel.fframe,
      );
      targetStateNotifier.update((state) => _targetState!);
    }
    if (queryStateNotifier.state.queryString != _queryState!.queryString) {
      Console.log(
        "Update queryState to ${_queryState!.queryString}",
        scope: "fframeLog.NavigationNotifier.updateProviders",
        level: LogLevel.fframe,
      );
      queryStateNotifier.update((state) => _queryState!);
    }
  }

  set isBuilding(bool isBuilding) {
    Console.log(
      "Set isBuilding to $isBuilding, buildPending = $_buildPending",
      scope: "fframeLog.NavigationNotifier.isBuilding",
      level: LogLevel.fframe,
    );
    _isbuilding = isBuilding;
    if (isBuilding == false && _buildPending == true) {
      Console.log(
        "Initiate delayed build for $uri",
        scope: "fframeLog.NavigationNotifier.isBuilding",
        level: LogLevel.fframe,
      );
      _buildPending = false;
      updateProviders();
    }
  }

  bool get isBuilding => _isbuilding;
}
