import 'package:flutter/material.dart';

import 'package:fframe/fframe.dart';

import 'package:fframe_demo/firebase_config.dart';
import 'package:fframe_demo/themes/themes.dart';
import 'package:fframe_demo/l10n/l10n.dart';

import 'package:fframe_demo/views/signInPage/signin_page.dart';
import 'package:fframe_demo/views/suggestion/suggestion.dart';
import 'package:fframe_demo/views/setting/setting.dart';
import 'package:fframe_demo/views/user/user.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your FlutFrame application.
  @override
  Widget build(BuildContext context) {
    final List<NavigationTarget> authenticatedNavigationTargets = [
      // homeNavigationTargets,
      suggestionNavigationTargets,
      settingNavigationTargets,
      usersNavigationTargets,
    ];

    final List<NavigationTarget> unAuthenticatedNavigationTargets = [
      signInPageNavigationTargets,
    ];

    return Fframe(
      title: "FlutFrame Demo",
      firebaseOptions: DefaultFirebaseConfig.platformOptions,
      authenticatedNavigationTargets: authenticatedNavigationTargets,
      unAuthenticatedNavigationTargets: unAuthenticatedNavigationTargets,
      lightMode: appLightTheme,
      darkMode: appDarkTheme,
      l10nConfig: l10nConfig,
      issuePageLink: "https://github.com/postmeridiem/fframe/issues",
    );
  }
}
