part of '../../fframe.dart';

class FRouterConfig {
  late NavigationConfig navigationConfig;
  late NavigationConfig filteredNavigationConfig;
  late Widget mainScreen;
  late RouterBuilder routerBuilder;

  static final FRouterConfig instance = FRouterConfig._internal();

  FRouterConfig._internal();

  factory FRouterConfig({
    required RouterBuilder routerBuilder,
    required NavigationConfig navigationConfig,
    required Widget mainScreen,
  }) {
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

    // navigationConfig.navigationTargets.forEach(
    //   ((NavigationTarget navigationTarget) {
    //     if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
    //       for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
    //         navigationTab.parentTarget = navigationTarget;
    //         navigationTab.path = "${navigationTab.parentTarget!.path}/${navigationTab.path}";
    //       }
    //     } else if (!navigationTarget.path.startsWith("/")) {
    //       navigationTarget.path = "/${navigationTarget.path}";
    //     }
    //   }),
    // );

    instance.mainScreen = mainScreen;
    instance.navigationConfig = navigationConfig;
    return instance;
  }
}

typedef RouterBuilder = Widget Function(
  BuildContext context,
  // Material data,
);
