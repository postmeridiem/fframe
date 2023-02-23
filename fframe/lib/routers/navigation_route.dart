import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:fframe/services/navigation_service.dart';

class FNavigationRouteInformationParser
    extends RouteInformationParser<NavigationNotifier> {
  @override
  Future<NavigationNotifier> parseRouteInformation(
      RouteInformation routeInformation) async {
    Console.log(
      "Updated to ${routeInformation.location!}s",
      scope:
          "fframeLog.FNavigationRouteInformationParser.parseRouteInformation",
      level: LogLevel.fframe,
    );
    navigationNotifier.parseRouteInformation(
        uri: Uri.parse(routeInformation.location!));
    return navigationNotifier;
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationNotifier configuration) {
    //Updates the browser history

    Console.log(
      "Updated to ${configuration.composeUri()}",
      scope:
          "fframeLog.FNavigationRouteInformationParser.restoreRouteInformation",
      level: LogLevel.fframe,
    );

    return RouteInformation(location: configuration.restoreRouteInformation());
  }
}

class FNavigationRouterDelegate extends RouterDelegate<NavigationNotifier>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  bool hasListener = false;

  FNavigationRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    Console.log(
      "init FNavigationRouterDelegate",
      scope: "fframeLog.FNavigationRouterDelegate",
      level: LogLevel.fframe,
    );

    navigationNotifier.addListener(_navigationNotifierListener);
  }

  _navigationNotifierListener() {
    Console.log(
      "Updated to ${navigationNotifier.uri}, notifyListeners",
      scope: "fframeLog.FNavigationRouterDelegate.navigationNotifier",
      level: LogLevel.fframe,
    );
    notifyListeners();
    // navigationNotifier.removeListener(_navigationNotifierListener);
  }

  @override
  NavigationNotifier? get currentConfiguration {
    Console.log(
      "Updated to ${navigationNotifier.uri?.path} :: ${navigationNotifier.uri?.query.toString()}",
      scope: "fframeLog.FNavigationRouterDelegate.currentConfiguration",
      level: LogLevel.fframe,
    );

    // currentConfiguration?.uri?.path;
    // navigationNotifier.notifyListeners();
    return navigationNotifier;
  }

  @override
  Widget build(BuildContext context) {
    Console.log("NavigationRouterDelegate.build",
        scope: "fframeLog.NavigationRouter", level: LogLevel.fframe);

    return Navigator(
      key: navigatorKey,
      pages: const [
        RouterPage(),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> setNewRoutePath(NavigationNotifier navigationNotifier) async {
    Console.log(
      "Updated to ${navigationNotifier.uri?.path} :: ${navigationNotifier.uri?.query.toString()}",
      scope: "fframeLog.FNavigationRouterDelegate.setNewRoutePath",
      level: LogLevel.fframe,
    );
    return;
  }

  @override
  void dispose() {
    navigationNotifier.removeListener(_navigationNotifierListener);
    super.dispose();
  }
}
