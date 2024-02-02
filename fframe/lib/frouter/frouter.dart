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
  });

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
    //Remap parent/child structure
    NavigationConfig navigationConfig = NavigationConfig.clone(widget.navigationConfig);

    navigationConfig.navigationTargets.forEach(
      ((NavigationTarget navigationTarget) {
        //Enforce leading slash
        if (!navigationTarget.path.startsWith("/")) {
          navigationTarget.path = "/${navigationTarget.path}";
        }

        Console.log(
          "${navigationTarget.title} => ${navigationTarget.path}",
          scope: "FRouterInit",
          level: LogLevel.fframe,
        );

        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
            // ignore: unnecessary_null_comparison
            if (navigationTab.parentTarget == null) {
              navigationTab.parentTarget = navigationTarget;

              //Remove leading slash
              if (navigationTab.path.startsWith("/")) {
                navigationTab.path = navigationTab.path.substring(1);
              }

              navigationTab.path = "${navigationTab.parentTarget!.path}/${navigationTab.path}";
              Console.log(
                "${navigationTab.parentTarget!.title} => ${navigationTab.path}",
                scope: "FRouterInit",
                level: LogLevel.fframe,
              );
            } else {
              Console.log(
                "Already set: ${navigationTab.parentTarget!.title} => ${navigationTab.path}",
                scope: "FRouterInit",
                level: LogLevel.fframe,
              );
            }
          }
        } else if (!navigationTarget.path.startsWith("/")) {
          navigationTarget.path = "/${navigationTarget.path}";
        }
      }),
    );

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
