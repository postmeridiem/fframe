import 'package:flutter/material.dart';

import 'package:fframe/fframe.dart';

import 'package:example/firebase_config.dart';
import 'package:example/themes/themes.dart';
import 'package:example/l10n/l10n.dart';

import 'package:example/views/signInPage/signin_page.dart';
import 'package:example/views/suggestion/suggestion.dart';
import 'package:example/views/setting/setting.dart';
import 'package:example/views/user/user.dart';

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
