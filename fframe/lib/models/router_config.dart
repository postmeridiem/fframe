part of fframe;

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
    //Register parent/child relationships
    navigationConfig.navigationTargets.forEach(
      ((NavigationTarget navigationTarget) {
        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
            navigationTab.parentTarget = navigationTarget;
            navigationTab.path = "${navigationTab.parentTarget.path}/${navigationTab.path}";

            // if (navigationTab.navigationTabs != null && navigationTab.navigationTabs!.isNotEmpty) {
            //   debugPrint("Process the subtabs");
            //   for (NavigationTab navigationSubTab in navigationTab.navigationTabs!) {
            //     navigationSubTab.parentTarget = navigationTab;
            //     navigationSubTab.path = "/${navigationTab.path}/${navigationSubTab.path}";
            //   }
            // }
          }
        }
      }),
    );

    // instance.appliedNavigationConfig = NavigationConfig.clone(navigationConfig);
    instance.mainScreen = mainScreen;
    instance.navigationConfig = navigationConfig;
    return instance;
  }
}

typedef RouterBuilder = Widget Function(
  BuildContext context,
  // Material data,
);
