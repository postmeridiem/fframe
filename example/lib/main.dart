import 'package:flutter/material.dart';

import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:example/firebase_options.dart';

import 'package:example/themes/themes.dart';

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
    final L10nConfig l10nConfig = L10nConfig(
      // the default locale your App starts with
      // passed through url string reader here to enable url
      // deeplinking of an l10n locale. You can also just pass a Locale.
      locale: L10nConfig.urlReader(const Locale('en', 'US')),

      // the list of locales that are supported by your app
      supportedLocales: [
        const Locale('en', 'US'), // English, US country code
        const Locale('nl', 'NL'), // Dutch, Netherlands country code
      ],

      // Pass the localizations for flutter and material level
      // widget localizations. Stuff you can't reach otherwise, basically.
      // TODO: @JS needs to be provided. need to figure out a clean way
      localizationsDelegates: [],

      // set the source configuration
      source: L10nSource.assets,

      // define the namespaces that need to be loaded
      namespaces: ['fframe', 'global'],
    );

    return Fframe(
      title: "FlutFrame Demo",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      authenticatedNavigationTargets: authenticatedNavigationTargets,
      unAuthenticatedNavigationTargets: unAuthenticatedNavigationTargets,
      lightMode: appLightTheme,
      darkMode: appDarkTheme,
      l10nConfig: l10nConfig,
      issuePageLink: "https://github.com/postmeridiem/fframe/issues",
    );
  }
}
