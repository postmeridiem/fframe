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
        navigationTarget: InitialConfig.instance.navigationConfig.navigationTargets.firstWhere(
          (NavigationTarget navigationTarget) => navigationTarget.path == "/",
          orElse: () => TargetState.defaultRoute().navigationTarget,
        ),
      );
    }

    TargetState targetState = TargetState(
      navigationTarget: InitialConfig.instance.navigationConfig.navigationTargets.firstWhere(
        (NavigationTarget navigationTarget) => navigationTarget.path == uri.pathSegments.first,
        orElse: () {
          debugPrint("No route found to ${uri.pathSegments.first}. Please update the navigation config.");
          return InitialConfig.instance.navigationConfig.errorPage;
        },
      ),
    );

    if (uri.pathSegments.length > 1) {
      debugPrint("Search for subroutes. If not found..... error page");
      if (targetState.navigationTarget.navigationTabs == null || targetState.navigationTarget.navigationTabs!.isEmpty) {
        return TargetState(navigationTarget: InitialConfig.instance.navigationConfig.errorPage);
      }

      try {
        NavigationTab navigationTab = targetState.navigationTarget.navigationTabs!.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == uri.pathSegments.last);
        targetState = TargetState(navigationTarget: navigationTab);
      } catch (e) {
        TargetState(navigationTarget: InitialConfig.instance.navigationConfig.errorPage);
      }
    } else if (targetState.navigationTarget.navigationTabs != null) {
      //Cannot route to a path which has tabs. Mandatory apply the first tab
      targetState = TargetState(navigationTarget: targetState.navigationTarget.navigationTabs!.first);
    }

    return targetState;
  }

  factory TargetState.defaultRoute() {
    TargetState targetState = TargetState(
      navigationTarget: InitialConfig.instance.navigationConfig.navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.landingPage, orElse: () {
        debugPrint("No default route has been configured. Please update the navigation config.");
        return InitialConfig.instance.navigationConfig.errorPage;
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
  QueryState({
    this.queryParameters,
  });

  final Map<String, String>? queryParameters;

  factory QueryState.fromUri(Uri uri) {
    return QueryState(queryParameters: uri.queryParameters);
  }

  factory QueryState.mergeComponents(QueryState queryState, Map<String, String>? queryParameters) {
    Map<String, String> newQueryParameters = {};
    newQueryParameters.addAll(queryState.queryParameters ?? {});
    newQueryParameters.addAll(queryParameters ?? {});
    debugPrint("Merged parameters: ${newQueryParameters.toString()}");
    return QueryState(queryParameters: newQueryParameters);
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
  // TODO: Route sign in via the sign in path, instead of just loading the widget;
  // NavigationTarget? _postSignInTarget;
  bool _isbuilding = false;
  bool _buildPending = false;

  bool _isSignedIn = false;

  NavigationNotifier({required this.ref});

  bool get isSignedIn => _isSignedIn;
  set isSignedIn(bool isSignedIn) {
    debugPrint("New sign in state: $isSignedIn");
    _isSignedIn = isSignedIn;
    updateProviders();
    notifyListeners();
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
