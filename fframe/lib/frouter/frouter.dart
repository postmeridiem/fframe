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
    required this.user,
  }) {
    Console.log("FRouterInit", scope: "Fframe", level: LogLevel.dev);
  }

  final bool debugMode;

  final Widget mainScreen;
  final NavigationConfig navigationConfig;
  final RouterBuilder routerBuilder;
  final FFrameUser? user;
  @override
  State<FRouterInit> createState() => _FRouterInitState();
}

class _FRouterInitState extends State<FRouterInit> {
  @override
  void initState() {
    super.initState();

    FRouterConfig(
      navigationConfig: widget.navigationConfig,
      routerBuilder: widget.routerBuilder,
      mainScreen: widget.mainScreen,
      user: widget.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          navigationNotifier = ref.read(navigationProvider);
          navigationNotifier.fFrameUser = Fframe.of(context)?.user;
          routerDelegate = FNavigationRouterDelegate();
          routeInformationParser = FNavigationRouteInformationParser();
          return widget.routerBuilder(context);
        },
      ),
    );
  }
}
