import 'package:example/firebase_options.dart';
import 'package:example/pages/empty_page.dart';
import 'package:example/pages/error_page.dart';
import 'package:example/pages/wait_page.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/l10n.dart';

import 'package:example/themes/themes.dart';

import 'package:example/screens/signInPage/signin_page.dart';
import 'package:example/screens/suggestion/suggestion.dart';
import 'package:example/screens/setting/setting.dart';
import 'package:example/screens/user/user.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your FlutFrame application.
  @override
  Widget build(BuildContext context) {
    final NavigationConfig navigationConfig = NavigationConfig(
      navigationTargets: [
        suggestionNavigationTarget,
        settingNavigationTarget,
        usersNavigationTarget,
      ],
      signInConfig: SignInConfig(signInTarget: signInPageNavigationTarget),
      errorPage: NavigationTarget(
        path: "",
        title: "",
        contentPane: const ErrorPage(),
        public: true,
      ),
      emptyPage: NavigationTarget(
        path: "",
        title: "",
        contentPane: const EmptyPage(),
        public: true,
      ),
      waitPage: NavigationTarget(
        path: "",
        title: "",
        contentPane: const WaitPage(),
        public: true,
      ),
    );

    final L10nConfig l10nConfig = L10nConfig(
      // the default locale your App starts with
      // passed through url string reader here to enable url
      // deeplinking of an l10n locale.
      // You also pass the default Locale here.
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
      navigationConfig: navigationConfig,
      lightMode: appLightTheme,
      darkMode: appDarkTheme,
      l10nConfig: l10nConfig,
      providerConfigs: const [
        // EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId:
              "43505871602-e9dt1461ephd9pq233v585op5aan02lv.apps.googleusercontent.com",
        ),
      ],
      issuePageLink: "https://github.com/postmeridiem/fframe/issues",
      debugShowCheckedModeBanner: false,
    );
  }
}
