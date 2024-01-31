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
        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
            navigationTab.parentTarget = navigationTarget;
            navigationTab.path = "${navigationTab.parentTarget.path}/${navigationTab.path}";
          }
        } else if (!navigationTarget.path.startsWith("/")) {
          navigationTarget.path = "/${navigationTarget.path}";
        }
      }),
    );
    instance.mainScreen = mainScreen;
    instance.navigationConfig = navigationConfig;
    return instance;
  }
}

typedef RouterBuilder = Widget Function(
  BuildContext context,
  // Material data,
);
