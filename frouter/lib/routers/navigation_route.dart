import 'package:flutter/widgets.dart';
import 'package:frouter/pages/router_page.dart';
import 'package:frouter/services/navigation_service.dart';

class FNavigationRouteInformationParser extends RouteInformationParser<NavigationNotifier> {
  @override
  Future<NavigationNotifier> parseRouteInformation(RouteInformation routeInformation) async {
    debugPrint("NavigationRouteInformationParser.parseRouteInformation");
    navigationNotifier.parseRouteInformation(uri: Uri.parse(routeInformation.location!));
    return navigationNotifier;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  RouteInformation? restoreRouteInformation(NavigationNotifier navigationNotifier) {
    //Updates the browser history
    debugPrint("NavigationRouteInformationParser.restoreRouteInformation => ${navigationNotifier.composeUri()}");

    return RouteInformation(location: navigationNotifier.restoreRouteInformation());
  }
}

class FNavigationRouterDelegate extends RouterDelegate<NavigationNotifier> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  FNavigationRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    navigationNotifier.addListener(() {
      debugPrint("NavigationRouterDelegate.navigationNotifier updated to ${navigationNotifier.uri}");
      notifyListeners();
    });
  }

  @override
  NavigationNotifier? get currentConfiguration {
    debugPrint("NavigationRouterDelegate.currentConfiguration => ${navigationNotifier.uri?.path} :: ${navigationNotifier.uri?.query.toString()}");
    // currentConfiguration?.uri?.path;
    return navigationNotifier;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("NavigationRouterDelegate.build");
    return Navigator(
      key: navigatorKey,
      pages: [
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
    debugPrint("NavigationRouterDelegate.setNewRoutePath");

    debugPrint("NavigationRouterDelegate.setNewRoutePath => ${navigationNotifier.uri?.path} :: ${navigationNotifier.uri?.query.toString()}");
    return;
  }
}
