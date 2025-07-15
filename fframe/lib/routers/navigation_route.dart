import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:fframe/services/navigation_service.dart';

class FNavigationRouteInformationParser extends RouteInformationParser<NavigationNotifier> {
  @override
  Future<NavigationNotifier> parseRouteInformation(RouteInformation routeInformation) async {
    Console.log("parseRouteInformation to ${routeInformation.uri}", scope: "fframeLog.FNavigationRouteInformationParser.parseRouteInformation", level: LogLevel.dev);
    NavigationNotifier.instance.parseRouteInformation(uri: routeInformation.uri);
    return NavigationNotifier.instance;
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationNotifier configuration) {
    //Updates the browser history

    Console.log(
      "restoreRouteInformation",
      scope: "fframeLog.FNavigationRouteInformationParser.restoreRouteInformation",
      level: LogLevel.dev,
    );

    return RouteInformation(uri: configuration.restoreRouteInformation());
  }
}

class FNavigationRouterDelegate extends RouterDelegate<NavigationNotifier> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  bool hasListener = false;

  FNavigationRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    Console.log(
      "init FNavigationRouterDelegate",
      scope: "fframeLog.FNavigationRouterDelegate",
      level: LogLevel.dev,
    );

    NavigationNotifier.instance.addListener(_navigationNotifierListener);
  }

  void _navigationNotifierListener() {
    Console.log(
      "_navigationNotifierListener",
      scope: "fframeLog.FNavigationRouterDelegate._navigationNotifier",
      level: LogLevel.dev,
    );
    notifyListeners();
    // navigationNotifier.removeListener(_navigationNotifierListener);
  }

  @override
  NavigationNotifier? get currentConfiguration {
    Console.log(
      "get currentConfiguration",
      scope: "fframeLog.FNavigationRouterDelegate.currentConfiguration",
      level: LogLevel.dev,
    );

    // currentConfiguration?.uri?.path;
    // navigationNotifier.notifyListeners();
    return NavigationNotifier.instance;
  }

  @override
  Widget build(BuildContext context) {
    Console.log("NavigationRouterDelegate.build", scope: "fframeLog.NavigationRouter", level: LogLevel.dev);

    return Navigator(
      key: navigatorKey,
      pages: const [
        RouterPage(),
      ],
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => FFErrorPage(),
        );
      },
    );
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> setNewRoutePath(NavigationNotifier navigationNotifier) async {
    Console.log(
      "setNewRoutePath",
      scope: "fframeLog.FNavigationRouterDelegate.setNewRoutePath ${navigationNotifier.uri}",
      level: LogLevel.dev,
    );
    navigationNotifier.notifyListeners();
    return;
  }

  @override
  void dispose() {
    NavigationNotifier.instance.removeListener(_navigationNotifierListener);
    super.dispose();
  }
}
