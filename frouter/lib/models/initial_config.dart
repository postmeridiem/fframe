import 'package:flutter/widgets.dart';
import 'package:frouter/frouter.dart';
import 'models.dart';

class InitialConfig {
  late NavigationConfig navigationConfig;
  late Widget mainScreen;
  late RouterBuilder routerBuilder;

  static final InitialConfig instance = InitialConfig._internal();

  InitialConfig._internal();

  factory InitialConfig({required RouterBuilder routerBuilder, required NavigationConfig navigationConfig, required Widget mainScreen}) {
    //Register parent/child relationships
    navigationConfig.navigationTargets.forEach(
      ((NavigationTarget navigationTarget) {
        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
            navigationTab.parentTarget = navigationTarget;
          }
        }
      }),
    );

    instance.mainScreen = mainScreen;
    instance.navigationConfig = navigationConfig;
    return instance;
  }
}
