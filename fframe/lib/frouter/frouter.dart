part of fframe;

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
