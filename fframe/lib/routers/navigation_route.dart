import 'package:fframe/fframe.dart';
import 'package:flutter/widgets.dart';
import 'package:fframe/services/navigation_service.dart';

class FNavigationRouteInformationParser
    extends RouteInformationParser<NavigationNotifier> {
  @override
  Future<NavigationNotifier> parseRouteInformation(
      RouteInformation routeInformation) async {
    debugPrint(
        "fframeLog.NavigationRouteInformationParser.parseRouteInformation: Updated to ${routeInformation.location!}");
    navigationNotifier.parseRouteInformation(
        uri: Uri.parse(routeInformation.location!));
    return navigationNotifier;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  RouteInformation? restoreRouteInformation(
      NavigationNotifier navigationNotifier) {
    //Updates the browser history
    debugPrint(
        "fframeLog.NavigationRouteInformationParser.restoreRouteInformation: Updated to ${navigationNotifier.composeUri()}");

    return RouteInformation(
        location: navigationNotifier.restoreRouteInformation());
  }
}

class FNavigationRouterDelegate extends RouterDelegate<NavigationNotifier>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  bool hasListener = false;

  FNavigationRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    debugPrint(
        "fframeLog.FNavigationRouterDelegate: init FNavigationRouterDelegate");

    navigationNotifier.addListener(_navigationNotifierListener);
  }

  _navigationNotifierListener() {
    debugPrint(
        "fframeLog.FNavigationRouterDelegate.navigationNotifier: Updated to ${navigationNotifier.uri}, notifyListeners");
    notifyListeners();
    // navigationNotifier.removeListener(_navigationNotifierListener);
  }

  @override
  NavigationNotifier? get currentConfiguration {
    debugPrint(
        "fframeLog.FNavigationRouterDelegate.currentConfiguration: Updated to ${navigationNotifier.uri?.path} :: ${navigationNotifier.uri?.query.toString()}");
    // currentConfiguration?.uri?.path;
    // navigationNotifier.notifyListeners();
    return navigationNotifier;
  }

  @override
  Widget build(BuildContext context) {
    Fframe.of(context)!.log("NavigationRouterDelegate.build",
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
    debugPrint(
        "fframeLog.FNavigationRouterDelegate.setNewRoutePath: Updated to ${navigationNotifier.uri?.path} :: ${navigationNotifier.uri?.query.toString()}");
    return;
  }

  @override
  void dispose() {
    navigationNotifier.removeListener(_navigationNotifierListener);
    super.dispose();
  }
}
