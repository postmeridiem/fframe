import 'package:flutter/widgets.dart';
import 'models.dart';

class InitialConfig {
  late NavigationConfig navigationConfig;
  late Widget mainScreen;

  static final InitialConfig instance = InitialConfig._internal();

  InitialConfig._internal();

  factory InitialConfig({required NavigationConfig navigationConfig, required Widget mainScreen}) {
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
