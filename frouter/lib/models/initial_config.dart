import 'package:flutter/widgets.dart';
import 'package:frouter/frouter.dart';

class RouterConfig {
  late NavigationConfig navigationConfig;
  // late NavigationConfig appliedNavigationConfig;
  late Widget mainScreen;
  late RouterBuilder routerBuilder;
  late Listenable? refreshListenable;

  static final RouterConfig instance = RouterConfig._internal();

  RouterConfig._internal();

  factory RouterConfig({required RouterBuilder routerBuilder, required NavigationConfig navigationConfig, required Widget mainScreen, Listenable? refreshListenable}) {
    //Register parent/child relationships
    navigationConfig.navigationTargets.forEach(
      ((NavigationTarget navigationTarget) {
        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
            navigationTab.parentTarget = navigationTarget;
            navigationTab.path = "${navigationTab.parentTarget.path}/${navigationTab.path}";
          }
        }
      }),
    );

    // instance.appliedNavigationConfig = NavigationConfig.clone(navigationConfig);
    instance.mainScreen = mainScreen;
    instance.navigationConfig = navigationConfig;
    instance.refreshListenable = refreshListenable;
    return instance;
  }
}
