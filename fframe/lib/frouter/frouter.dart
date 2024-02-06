//FFRame Router
part of '../../fframe.dart';

@immutable
// ignore: must_be_immutable
class FRouterInit extends StatefulWidget {
  FRouterInit({
    super.key,
    required this.navigationConfig,
    this.debugMode = false,
    required this.routerBuilder,
    required this.mainScreen,
  }) {
    Console.log("FRouterInit", scope: "Fframe", level: LogLevel.dev);
  }

  final bool debugMode;

  final Widget mainScreen;
  final NavigationConfig navigationConfig;
  final RouterBuilder routerBuilder;

  @override
  State<FRouterInit> createState() => _FRouterInitState();
}

class _FRouterInitState extends State<FRouterInit> {
  /// The route information parser used by the go router.
  final FNavigationRouteInformationParser routeInformationParser = FNavigationRouteInformationParser();

  late FNavigationRouterDelegate routerDelegate;

  @override
  void initState() {
    super.initState();

    FRouterConfig(
      navigationConfig: widget.navigationConfig,
      routerBuilder: widget.routerBuilder,
      mainScreen: widget.mainScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          navigationNotifier = ref.read(navigationProvider);
          routerDelegate = FNavigationRouterDelegate();
          return widget.routerBuilder(context);
        },
      ),
    );
  }
}
