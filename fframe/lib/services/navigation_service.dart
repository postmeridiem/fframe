import 'package:fframe/fframe.dart';
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
    required this.selectionState,
  });

  final TargetState targetState;
  final SelectionState selectionState;
}

class NavigationNotifier extends ChangeNotifier {
  static final NavigationNotifier instance = NavigationNotifier._internal();
  NavigationNotifier._internal();

  late Ref ref;
  Uri? _uri = Uri();
  List<NextState> nextState = [];
  late FFrameUser? fFrameUser;

  TargetState? _targetState;
  bool _isbuilding = false;
  bool _buildPending = false;

  // NavigationConfig navigationConfig = FRouterConfig.instance.navigationConfig;
  late NavigationConfig _initialNavigationConfig = FRouterConfig.instance.navigationConfig;

  factory NavigationNotifier({required Ref ref, FFrameUser? fFrameUser, required NavigationConfig navigationConfig}) {
    Console.log(
      "init NavigationNotifier",
      scope: "fframeLog.NavigationNotifier",
      level: LogLevel.dev,
    );
    instance.ref = ref;
    instance.fFrameUser = fFrameUser;
    instance._initialNavigationConfig = navigationConfig;
    SelectionState.instance.addListener(instance.selectionStateListener);
    return instance;
  }

  @override
  void dispose() {
    SelectionState.instance.removeListener(selectionStateListener);
    super.dispose();
  }

  int? selectedNavRailIndex;
  bool get isSignedIn => FRouterConfig.instance.user == null ? false : true;

  selectionStateListener() {
    Console.log(
      "selectionStateListener",
      scope: "fframeLog.NavigationNotifier.currentTarget",
      level: LogLevel.dev,
    );

    processRouteInformation();
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
      SelectionState selectionState = SelectionState.instance.fromUri(uri: uri);

      Console.log(
        "Parsing path: /#/${targetState.navigationTarget.path} query: ${selectionState.toString()}",
        scope: "fframeLog.NavigationNotifier.parseRouteInformation",
        level: LogLevel.fframe,
      );

      if (uri.path != "/") {
        Console.log(
          "Store initial link for later use: ${targetState.navigationTarget.title} ${selectionState.queryString}",
          scope: "fframeLog.NavigationNotifier.parseRouteInformation",
          level: LogLevel.fframe,
        );
        nextState.add(NextState(targetState: targetState, selectionState: selectionState));
      }

      processRouteInformation(targetState: targetState, selectionState: selectionState);
    }
  }

  processRouteInformation({TargetState? targetState, SelectionState? selectionState}) {
    Console.log(
      "processRouteInformation",
      scope: "fframeLog.NavigationNotifier.processRouteInformation",
      level: LogLevel.fframe,
    );
    _targetState = targetState ?? ref.read(targetStateProvider);
    // _selectionState = selectionState ?? SelectionState.instance;

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

    // debugger();
    String queryString = SelectionState.instance.queryString;
    Uri uri = Uri.parse("/$pathComponent${queryString != "" ? "?$queryString" : ""}".replaceAll("//", "/"));

    //Trigger the setter and te external method with it;
    Console.log(
      "Created URI for: ${uri.toString()} from path: $pathComponent and query: $queryString",
      scope: "fframeLog.NavigationNotifier.composeUri",
      level: LogLevel.dev,
    );

    // debugger(when: queryComponent.isNotEmpty, message: "QS is not empty ${QueryState.instance.queryString}");

    return uri;
  }

  markBuildDone<T>(DocumentConfig<T> documentConfig) async {
    _isbuilding = false;
    Console.log(
      "Mark build done",
      scope: "fframeLog.NavigationNotifier.markBuildDone buildPending: $_buildPending",
      level: LogLevel.fframe,
    );
    if (SelectionState.instance.pendingUri != null && SelectionState.instance.pendingUri!.query != "") {
      // if (_buildPending) {
      _buildPending = false;

      String? docId = SelectionState.instance.pendingUri!.queryParameters[documentConfig.queryStringIdParam];
      if (docId != null) {
        SelectedDocument<T> selectedDocument = SelectedDocument<T>(id: docId, documentConfig: documentConfig);
        selectedDocument.open();
      }

      // updateProviders();
      // notifyListeners();
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
    if (_uri == uri) {
      return;
    }

    Console.log(
      "NavigationService.setUri: ${uri.toString()} was: $_uri",
      scope: "fframeLog.NavigationNotifier.uri",
      level: LogLevel.fframe,
    );

    if (_buildPending == true) {
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

    if (targetStateNotifier.state.navigationTarget.path != _targetState!.navigationTarget.path) {
      Console.log(
        "Update targetState to ${_targetState!.navigationTarget.title} ${_targetState!.navigationTarget.path}",
        scope: "fframeLog.NavigationNotifier.updateProviders",
        level: LogLevel.fframe,
      );
      targetStateNotifier.update((state) => _targetState!);
    }
    // if (SelectionState.instance.queryString != _selectionState!.queryString) {
    //   Console.log(
    //     "Update selectionState to ${_selectionState!.queryString}",
    //     scope: "fframeLog.NavigationNotifier.updateProviders",
    //     level: LogLevel.fframe,
    //   );
    //   // QueryState.instance.notifyListeners();
    //   // selectionStateNotifier.update((state) => _selectionState!);
    // }
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
