// Shared harness for exercising the example app's real navigation
// configuration outside a running Fframe app. Used by
// landing_page_resolution_test.dart (automated) and visual_preview.dart
// (manual visual inspection via `flutter run -d chrome`).

import 'package:example/pages/empty_page.dart';
import 'package:example/pages/error_page.dart';
import 'package:example/pages/wait_page.dart';
import 'package:example/screens/customwidget/navigation.dart';
import 'package:example/screens/list_grid/list_grid.dart';
import 'package:example/screens/list_grid_single_column_widget/list_grid_single_colum.dart';
import 'package:example/screens/setting/setting.dart';
import 'package:example/screens/signInPage/signin_page.dart';
import 'package:example/screens/suggestion/suggestion.dart';
import 'package:example/screens/swimlanes/swimlanes.dart';
import 'package:example/screens/tabloader/tabloader.dart';
import 'package:example/screens/user/user.dart';
import 'package:example/screens/user_profile/user_profile.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/services/navigation_service.dart';
import 'package:flutter/material.dart';

/// The same navigation configuration MainApp passes to Fframe in lib/main.dart.
///
/// FRouterConfig normalises paths and filters targets/tabs in place, and the
/// example navigation targets are shared top-level finals, so every caller
/// gets a fresh clone to stay independent of previous router initialisations.
NavigationConfig exampleNavigationConfig() {
  return NavigationConfig.clone(
    NavigationConfig(
      navigationTargets: [
        suggestionNavigationTarget,
        tabloaderNavigationTarget,
        customNavigationTarget,
        listGridNavigationTarget,
        listGridSingleColumnNavigationTarget,
        swimlanesNavigationTarget,
        usersNavigationTarget,
        settingNavigationTarget,
        userProfileNavigationTarget,
      ],
      signInConfig: SignInConfig(signInTarget: signInPageNavigationTarget),
      errorPage: NavigationTarget(
        path: "",
        title: "error",
        contentPane: const ErrorPage(),
        public: true,
      ),
      emptyPage: NavigationTarget(
        path: "",
        title: "empty",
        contentPane: const EmptyPage(),
        public: true,
      ),
      waitPage: NavigationTarget(
        path: "",
        title: "wait",
        contentPane: const WaitPage(),
        public: true,
      ),
    ),
  );
}

/// Runs the same router initialisation Fframe performs when the auth state
/// resolves: role-filter the navigation config for [user], then (re)initialise
/// the NavigationNotifier and TargetState singletons.
void initRouterFor(FFrameUser? user) {
  FRouterConfig(
    routerBuilder: (BuildContext context) => const SizedBox.shrink(),
    navigationConfig: exampleNavigationConfig(),
    mainScreen: const SizedBox.shrink(),
    user: user,
  );
  NavigationNotifier(
    fFrameUser: user,
    navigationConfig: FRouterConfig.instance.navigationConfig,
  );
  TargetState();
}
