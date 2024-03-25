import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';
import 'package:fframe/routers/navigation_route.dart';
import 'package:flutter/material.dart';
import 'package:fframe/providers/state_providers.dart';

late FNavigationRouteInformationParser routeInformationParser;
late NavigationNotifier navigationNotifier;
late FNavigationRouterDelegate routerDelegate;

final navigationProvider = ChangeNotifierProvider<NavigationNotifier>(
  (ref) {
    return NavigationNotifier(
      ref: ref,
      fFrameUser: null,
      navigationConfig: FRouterConfig.instance.navigationConfig,
    );
  },
);

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
  FFrameUser? fFrameUser;

  TargetState? _targetState;
  QueryState? _queryState;
  // NavigationTarget? _postSignInTarget;
  bool _isbuilding = false;
  bool _buildPending = false;

  // bool? _isSignedIn;

  // NavigationConfig navigationConfig = FRouterConfig.instance.navigationConfig;
  NavigationConfig _initialNavigationConfig = FRouterConfig.instance.navigationConfig;

  NavigationNotifier({required this.ref, required this.fFrameUser, required NavigationConfig navigationConfig}) {
    Console.log(
      "init NavigationNotifier",
      scope: "fframeLog.NavigationNotifier",
      level: LogLevel.dev,
    );
    _initialNavigationConfig = navigationConfig;
    // _filterNavigationRoutes(navigationConfig);
    QueryState.instance.addListener(queryStateListener);
    // FirebaseAuth.instance.authStateChanges().listen((User? user) => authChangeListener(user));
  }

  @override
  void dispose() {
    QueryState.instance.removeListener(queryStateListener);
    super.dispose();
  }

  int? selectedNavRailIndex;
  bool get isSignedIn => FRouterConfig.instance.user == null ? false : true;

  queryStateListener() {
    Console.log(
      "queryStateListener",
      scope: "fframeLog.NavigationNotifier.currentTarget",
      level: LogLevel.dev,
    );

    processRouteInformation(queryState: QueryState.instance);
  }

  TargetState? get currentTarget {
    Console.log(
      "get currentTarget",
      scope: "fframeLog.NavigationNotifier.currentTarget",
      level: LogLevel.dev,
    );
    return _targetState;
  }

  bool get hasTabs {
    Console.log(
      "get hasTabs",
      scope: "fframeLog.NavigationNotifier.hasTabs",
      level: LogLevel.dev,
    );
    return _targetState!.navigationTarget is NavigationTab;
  }

  bool get hasSubTabs {
    Console.log(
      "get hasSubTabs",
      scope: "fframeLog.NavigationNotifier.hasSubTabs",
      level: LogLevel.dev,
    );
    // if (_targetState == null) {
    //   return false;
    // }

    if (_targetState!.navigationTarget is NavigationTab) {
      NavigationTab navigationTab = _targetState!.navigationTarget as NavigationTab;
      return navigationTab.navigationTabs != null || (navigationTab.navigationTabs != null && navigationTab.navigationTabs!.isNotEmpty) || (navigationTab.parentTarget is NavigationTab);
    }
    return false;
    // return _targetState!.navigationTarget.navigationTabs != null || (_targetState!.navigationTarget.navigationTabs != null && _targetState!.navigationTarget.navigationTabs!.isNotEmpty);
  }

  List<NavigationTab> get navigationTabs {
    Console.log(
      "Getting navigation tabs",
      scope: "fframeLog.NavigationNotifier.navigationTabs",
      level: LogLevel.fframe,
    );
    if (_targetState!.navigationTarget is NavigationTab) {
      NavigationTab currentTab = _targetState!.navigationTarget as NavigationTab;
      NavigationTarget parentTarget = currentTab.parentTarget!;
      return parentTarget.navigationTabs!;
    }
    return [];
  }

  NavigationConfig get navigationConfig {
    NavigationConfig navigationConfig = NavigationConfig.clone(_initialNavigationConfig);
    return navigationConfig;
  }

  parseRouteInformation({required Uri uri}) {
    Console.log(
      "parseRouteInformation",
      scope: "fframeLog.NavigationNotifier.parseRouteInformation uri: ${uri.toString()}}",
      level: LogLevel.fframe,
    );
    if (_buildPending) {
      Console.log(
        "Build already pending",
        scope: "fframeLog.NavigationNotifier.parseRouteInformation",
        level: LogLevel.fframe,
      );
    } else {
      TargetState? targetState = TargetState.fromUri(this, uri);
      QueryState? queryState = QueryState.fromUri(uri);

      Console.log(
        "Parsing path: /#/${targetState.navigationTarget.path} query: ${queryState.toString()}",
        scope: "fframeLog.NavigationNotifier.parseRouteInformation",
        level: LogLevel.fframe,
      );

      if (uri.path != "/") {
        Console.log(
          "Store initial link for later use: ${targetState.navigationTarget.title} ${queryState.queryString}",
          scope: "fframeLog.NavigationNotifier.parseRouteInformation",
          level: LogLevel.fframe,
        );
        nextState.add(NextState(targetState: targetState, queryState: queryState));
      }

      processRouteInformation(targetState: targetState, queryState: queryState);
    }
  }

  processRouteInformation({TargetState? targetState, QueryState? queryState}) {
    Console.log(
      "processRouteInformation",
      scope: "fframeLog.NavigationNotifier.processRouteInformation",
      level: LogLevel.fframe,
    );
    _targetState = targetState ?? ref.read(targetStateProvider);
    _queryState = queryState ?? ref.read(queryStateProvider);

    uri = composeUri();
  }

  Uri composeUri() {
    Console.log(
      "Compose the uri",
      scope: "fframeLog.NavigationNotifier.composeUri",
      level: LogLevel.fframe,
    );
    String pathComponent = (_targetState == null)
        ? _uri?.path ?? "/"
        : _targetState!.navigationTarget.path.isNotEmpty
            ? _targetState!.navigationTarget.path
            : "/";

    String queryComponent = (_queryState == null) ? _uri?.query ?? "" : _queryState!.queryString;
    Uri uri = Uri.parse("/$pathComponent${queryComponent != "" ? "?$queryComponent" : ""}".replaceAll("//", "/"));

    //Trigger the setter and te external method with it;
    Console.log(
      "Created URI for: ${uri.toString()} from path: $pathComponent and query: $queryComponent",
      scope: "fframeLog.NavigationNotifier.composeUri",
      level: LogLevel.dev,
    );

    // debugger(when: queryComponent.isNotEmpty, message: "QS is not empty ${QueryState.instance.queryString}");

    return uri;
  }

  markBuildDone() {
    _isbuilding = false;
    _buildPending == true;
    Console.log(
      "Mark build done",
      scope: "fframeLog.NavigationNotifier.markBuildDone buildPending: $_buildPending",
      level: LogLevel.fframe,
    );
    if (_buildPending) {
      _buildPending = false;

      if (navigationNotifier.nextState.isNotEmpty) {
        NextState nextState = navigationNotifier.nextState.first;
        processRouteInformation(targetState: nextState.targetState, queryState: nextState.queryState);
      }

      updateProviders();
      notifyListeners();
    }
  }

  Uri restoreRouteInformation() {
    Console.log(
      "restoreRouteInformation",
      scope: "fframeLog.NavigationNotifier.restoreRouteInformation",
      level: LogLevel.fframe,
    );
    return composeUri();
  }

  Uri? get uri {
    Console.log(
      "NavigationService.getUri: ${_uri.toString()}",
      scope: "fframeLog.NavigationNotifier.uri",
      level: LogLevel.fframe,
    );
    return composeUri();
  }

  set uri(Uri? uri) {
    Console.log(
      "NavigationService.setUri: ${uri.toString()} was: $_uri",
      scope: "fframeLog.NavigationNotifier.uri",
      level: LogLevel.fframe,
    );

    if (_uri == uri && _buildPending == false) {
      return;
    }

    if (_uri == null) {
      _buildPending = true;
      Console.log(
        "New load, schedule build. Building: $_isbuilding, Setting build pending to $_buildPending",
        scope: "fframeLog.NavigationNotifier.uri",
        level: LogLevel.fframe,
      );
      _uri = uri;
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
    Console.log(
      "NavigationService.updateProviders",
      scope: "fframeLog.NavigationNotifier.updateProviders",
      level: LogLevel.fframe,
    );

    StateController<TargetState> targetStateNotifier = ref.read(targetStateProvider.notifier);
    StateController<QueryState> queryStateNotifier = ref.read(queryStateProvider.notifier);

    if (targetStateNotifier.state.navigationTarget.path != _targetState!.navigationTarget.path) {
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
      QueryState.instance.notifyListeners();
      queryStateNotifier.update((state) => _queryState!);
    }
  }

  set isBuilding(bool isBuilding) {
    Console.log(
      "Set isBuilding: $isBuilding, buildPending: $_buildPending",
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
