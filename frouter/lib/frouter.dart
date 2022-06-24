library frouter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frouter/models/initial_config.dart';
import 'package:frouter/routers/navigation_route.dart';
import 'package:frouter/services/navigation_service.dart';

import 'models/models.dart';
// import 'pages/router_page.dart';

export 'models/models.dart';
export 'pages/router_page.dart';
export 'routers/navigation_route.dart';
export 'services/navigation_service.dart';
export 'services/query_state.dart';
export 'services/target_state.dart';
export 'providers/state_providers.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';

//FFRame Router

@immutable
// ignore: must_be_immutable
class FRouterLoader extends StatelessWidget {
  FRouterLoader({
    Key? key,
    required this.navigationConfig,
    this.debugMode = false,
    required this.routerBuilder,
    required this.mainScreen,
  }) : super(key: key);

  final bool debugMode;

  final Widget mainScreen;
  final NavigationConfig navigationConfig;
  final RouterBuilder routerBuilder;

  /// The route information parser used by the go router.
  final FNavigationRouteInformationParser routeInformationParser = FNavigationRouteInformationParser();
  late FNavigationRouterDelegate routerDelegate; // = FNavigationRouterDelegate();

  @override
  Widget build(BuildContext context) {
    RouterConfig(
      navigationConfig: navigationConfig,
      routerBuilder: routerBuilder,
      mainScreen: mainScreen,
    );
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          navigationNotifier = ref.read(navigationProvider);
          routerDelegate = FNavigationRouterDelegate();
          return routerBuilder(context);
        },
      ),
    );
  }
}

typedef RouterBuilder = Widget Function(
  BuildContext context,
  // Material data,
);
