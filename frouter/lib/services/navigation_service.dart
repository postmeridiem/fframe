import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/initial_config.dart';
import '../models/models.dart';

late NavigationNotifier navigationNotifier;

final navigationProvider = ChangeNotifierProvider<NavigationNotifier>((ref) {
  return NavigationNotifier(ref: ref);
});

final targetStateProvider = StateProvider<TargetState>((ref) {
  return TargetState.defaultRoute();
});

final queryStateProvider = StateProvider<QueryState>((ref) {
  return QueryState();
});

class TargetState {
  TargetState({
    required this.navigationTarget,
  });

  final NavigationTarget navigationTarget;

  factory TargetState.processRouteRequest({required NavigationTarget navigationTarget}) {
    if (navigationTarget.navigationTabs != null) {
      debugPrint("Cannot route to a path which has tabs. Mandatory apply the first tab");
      navigationTarget = navigationTarget.navigationTabs!.first;
    }
    return TargetState(navigationTarget: navigationTarget);
  }

  factory TargetState.fromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      //This either routes to a / route or to the default route.
      return TargetState(
        navigationTarget: navigationNotifier.navigationConfig.navigationTargets.firstWhere(
          (NavigationTarget navigationTarget) => navigationTarget.path == "/",
          orElse: () => TargetState.defaultRoute().navigationTarget,
        ),
      );
    }

    //Check if this is a login path
    if (navigationNotifier.navigationConfig.signInConfig.signInTarget.path == uri.pathSegments.first) {
      return TargetState(navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget);
    }
    //Check if this is an invite path
    if (navigationNotifier.navigationConfig.signInConfig.invitionTarget?.path == uri.pathSegments.first) {
      return TargetState(navigationTarget: navigationNotifier.navigationConfig.signInConfig.invitionTarget!);
    }

    //Check if this is part of the config
    TargetState targetState = TargetState(
      navigationTarget: navigationNotifier.navigationConfig.navigationTargets.firstWhere(
        (NavigationTarget navigationTarget) => navigationTarget.path == uri.pathSegments.first,
        orElse: () {
          debugPrint("No route found to ${uri.pathSegments.first}. Please update the navigation config.");
          return navigationNotifier.navigationConfig.errorPage;
        },
      ),
    );

    if (uri.pathSegments.length > 1) {
      debugPrint("Search for subroutes. If not found..... error page");
      if (targetState.navigationTarget.navigationTabs == null || targetState.navigationTarget.navigationTabs!.isEmpty) {
        return TargetState(navigationTarget: navigationNotifier.navigationConfig.errorPage);
      }

      try {
        NavigationTab navigationTab = targetState.navigationTarget.navigationTabs!.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == uri.pathSegments.last);
        targetState = TargetState(navigationTarget: navigationTab);
      } catch (e) {
        TargetState(navigationTarget: navigationNotifier.navigationConfig.errorPage);
      }
    } else if (targetState.navigationTarget.navigationTabs != null) {
      //Cannot route to a path which has tabs. Mandatory apply the first tab
      targetState = TargetState(navigationTarget: targetState.navigationTarget.navigationTabs!.first);
    }

    return targetState;
  }

  factory TargetState.defaultRoute() {
    if (navigationNotifier.navigationConfig.navigationTargets.isEmpty && RouterConfig.instance.navigationConfig.navigationTargets.isNotEmpty && navigationNotifier.isSignedIn == false) {
      //Assume there are no applicable routes within the access control. Route to the signin page
      return TargetState(
        navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget,
      );
    }
    TargetState targetState = TargetState(
      navigationTarget: navigationNotifier.navigationConfig.navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.landingPage, orElse: () {
        debugPrint("***** No default route has been configured. Please update the navigation config. *****");
        return navigationNotifier.navigationConfig.errorPage;
      }),
    );
    debugPrint("DefaultRoute to ${targetState.navigationTarget.title} at ${targetState.navigationTarget.path}");
    return targetState;
  }

  @override
  String toString() {
    return "${navigationTarget.title} at path ${navigationTarget.path}";
  }
}

class QueryState {
  QueryState({this.queryParameters});

  final Map<String, String>? queryParameters;

  factory QueryState.fromUri(Uri uri) {
    return QueryState(queryParameters: uri.queryParameters);
  }

  factory QueryState.mergeComponents(QueryState queryState, Map<String, String>? queryParameters) {
    Map<String, String> newQueryParameters = {};
    newQueryParameters.addAll(queryState.queryParameters ?? {});
    newQueryParameters.addAll(queryParameters ?? {});
    debugPrint("Merged parameters: ${newQueryParameters.toString()}");
    return QueryState(queryParameters: newQueryParameters); //, context: context);
  }

  String get queryString {
    return queryParameters?.entries.map((queryParameter) => "${queryParameter.key}=${queryParameter.value}").join("&") ?? "";
  }

  @override
  String toString() {
    return queryString;
  }
}

class NavigationNotifier extends ChangeNotifier {
  final Ref ref;
  Uri? _uri;

  TargetState? _targetState;
  QueryState? _queryState;
  // NavigationTarget? _postSignInTarget;
  bool _isbuilding = false;
  bool _buildPending = false;

  bool _isSignedIn = false;
  List<String>? _roles;

  late NavigationConfig navigationConfig = RouterConfig.instance.navigationConfig;

  NavigationNotifier({required this.ref}) {
    _filterNavigationRoutes();
  }

  int selectedNavRailIndex = 0;
  bool get isSignedIn => _isSignedIn;

  signIn({List<String>? roles}) {
    _roles = roles;
    _isSignedIn = true;
    _filterNavigationRoutes();
    TargetState? targetState = TargetState.defaultRoute();
    QueryState? queryState = QueryState(queryParameters: null);
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

  List<NavigationTab> get navigationTabs {
    if (_targetState!.navigationTarget is NavigationTab) {
      NavigationTab currentTab = _targetState!.navigationTarget as NavigationTab;
      NavigationTarget parentTarget = currentTab.parentTarget;
      return parentTarget.navigationTabs!;
    }
    return [];
  }

  _filterNavigationRoutes() {
    navigationConfig = NavigationConfig.clone(RouterConfig.instance.navigationConfig);
    if (_isSignedIn) {
      //Check routes for roles
      navigationConfig.navigationTargets.removeWhere(
        (NavigationTarget navigationTarget) {
          //Check tabs first(if any)
          if (navigationTarget.navigationTabs != null) {
            List<NavigationTab> navigationTabs = _filterTabRoutes(navigationTarget.navigationTabs!);
            return navigationTabs.isEmpty;
          }

          //Remove all routes which are not private
          if (navigationTarget.private == false) {
            return true;
          }

          //If the target does not require roles. Return false
          if (navigationTarget.roles == null) {
            return false;
          }

          //If the user does not have roles. return true
          if (_roles == null) {
            return true;
          }

          //Check if the intersection contains a value. If so return false
          Set<String> userRoles = _roles!.toSet();
          Set<String> targetRoles = navigationTarget.roles!.toSet();

          Set<String> interSection = userRoles.intersection(targetRoles);
          return interSection.isEmpty;
        },
      );
    } else {
      //Not signed in. Keep public routes
      navigationConfig.navigationTargets.removeWhere((NavigationTarget navigationTarget) {
        if (navigationTarget.navigationTabs != null) {
          List<NavigationTab> navigationTabs = _filterTabRoutes(navigationTarget.navigationTabs!);
          return navigationTabs.isEmpty;
        }

        return navigationTarget.public == false;
      });
    }
  }

  List<NavigationTab> _filterTabRoutes(List<NavigationTab> navigationTabs) {
    if (_isSignedIn) {
      navigationTabs.removeWhere((NavigationTab navigationTab) {
        //Signed in. Keep private routes
        if (navigationTab.private == false) {
          return true;
        }

        //If the target does not require roles. Return false
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
    TargetState? targetState = TargetState.fromUri(uri);
    QueryState? queryState = QueryState.fromUri(uri);

    debugPrint("FRouter.generateRoute: ${targetState.toString()} :: ${queryState.toString()}");

    if (_targetState == null && _queryState == null) {
      debugPrint("NavigationNotifier.parseRouteInformation => Initial load, set defaults");
    }
    processRouteInformation(targetState: targetState, queryState: queryState);
  }

  processRouteInformation({TargetState? targetState, QueryState? queryState}) {
    _targetState = targetState ?? ref.read(targetStateProvider);
    _queryState = queryState ?? ref.read(queryStateProvider);

    uri = composeUri();
  }

  Uri composeUri() {
    String pathComponent = "/";
    if (_targetState != null) {
      if (_targetState!.navigationTarget is NavigationTab) {
        NavigationTab navigationTab = _targetState!.navigationTarget as NavigationTab;
        pathComponent = "${navigationTab.parentTarget.path}/${_targetState!.navigationTarget.path}";
      } else {
        pathComponent = _targetState!.navigationTarget.path;
      }
    }
    // String pathComponent = (_targetState == null) ? _uri?.path ?? "/" : _targetState!.navigationTarget.path;
    String queryComponent = (_queryState == null) ? _uri?.query ?? "" : _queryState!.queryString;

    //Trigger the setter and te external method with it;
    return Uri.parse("/$pathComponent${queryComponent != "" ? "?$queryComponent" : ""}");
  }

  String restoreRouteInformation() {
    return composeUri().toString();
  }

  Uri? get uri {
    return _uri;
  }

  set uri(Uri? uri) {
    debugPrint("NavigationService.setUri: ${uri.toString()} was: $_uri");

    if (_uri == uri) {
      debugPrint("Uri unchanged, do nothing");
    }

    if (_uri == null) {
      debugPrint("New load, schedule build. Building: $_isbuilding");
      _uri = uri;
      _buildPending = true;
    } else {
      _uri = uri;
    }

    if (_isbuilding != false || _buildPending != true) {
      updateProviders();
      notifyListeners();
    } else {
      debugPrint("Schedule delayed build");
    }
  }

  updateProviders() {
    StateController<TargetState> targetStateNotifier = ref.read(targetStateProvider.notifier);
    StateController<QueryState> queryStateNotifier = ref.read(queryStateProvider.notifier);

    if (targetStateNotifier.state.navigationTarget.path != _targetState!.navigationTarget.path) {
      debugPrint("Update targetState to ${_targetState!.navigationTarget.title} ${_targetState!.navigationTarget.path}");
      targetStateNotifier.update((state) => _targetState!);
    }
    if (queryStateNotifier.state.queryString != _queryState!.queryString) {
      debugPrint("Update queryState to ${_queryState!.queryString}");
      queryStateNotifier.update((state) => _queryState!);
    }
  }

  set isBuilding(bool isBuilding) {
    debugPrint("Set isBuilding to $isBuilding, buildPending = $_buildPending");
    _isbuilding = isBuilding;
    if (isBuilding == false && _buildPending == true) {
      debugPrint("Initiate delayed build for $uri");
      _buildPending = false;
      updateProviders();
    }
  }

  bool get isBuilding => _isbuilding;
}
