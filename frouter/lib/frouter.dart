library frouter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frouter/models/initial_config.dart';
import 'package:frouter/services/navigation_service.dart';

import 'models/models.dart';
import 'pages/router_page.dart';

export 'models/models.dart';
export 'pages/router_page.dart';
export 'services/navigation_service.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';

//FFRame Router

class FRouterLoader extends StatelessWidget {
  const FRouterLoader({Key? key, required this.navigationConfig, this.debugMode = false, required this.mainScreen}) : super(key: key);

  final bool debugMode;

  final Widget mainScreen;
  final NavigationConfig navigationConfig;

  @override
  Widget build(BuildContext context) {
    InitialConfig(
      navigationConfig: navigationConfig,
      mainScreen: mainScreen,
    );
    return const ProviderScope(
      child: _FRouterConsumer(),
    );
  }
}

class _FRouterConsumer extends ConsumerWidget {
  const _FRouterConsumer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    navigationNotifier = ref.read(navigationProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: NavigationRouteInformationParser(),
      routerDelegate: NavigationRouterDelegate(),
    );
  }
}

class NavigationRouteInformationParser extends RouteInformationParser<NavigationNotifier> {
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

class NavigationRouterDelegate extends RouterDelegate<NavigationNotifier> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  NavigationRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
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
