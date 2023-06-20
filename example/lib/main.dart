import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:fframe/fframe.dart';
import 'package:example/themes/themes.dart';
import 'package:fframe/helpers/console_logger.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:example/firebase_options.dart';
import 'package:example/pages/empty_page.dart';
import 'package:example/pages/error_page.dart';
import 'package:example/pages/wait_page.dart';

import 'package:example/screens/signInPage/signin_page.dart';
import 'package:example/screens/suggestion/suggestion.dart';
import 'package:example/screens/setting/setting.dart';
import 'package:example/screens/tabloader/tabloader.dart';
import 'package:example/screens/user/user.dart';
import 'package:example/screens/user_profile/user_profile.dart';
import 'package:example/screens/user_list/user_list.dart';
import 'package:example/screens/list_grid/list_grid.dart';
import 'package:flutterfire_ui/i10n.dart';

import 'helpers/header_buttons.dart';

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
        tabloaderNavigationTarget,
        settingNavigationTarget,
        usersNavigationTarget,
        userListNavigationTarget,
        listGridNavigationTarget,
        userProfileNavigationTarget,
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
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

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
      themeMode: ThemeMode.system,
      l10nConfig: l10nConfig,
      consoleLogger: Console(logThreshold: LogLevel.fframe),
      providerConfigs: const [
        // EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: "252859371693-n0lhonhub6tosste2ns0a0n4s923du2l.apps.googleusercontent.com",
        ),
      ],
      debugShowCheckedModeBanner: false,
      globalActions: const [
        BarButtonShare(),
        BarButtonDuplicate(),
        BarButtonFeedback(),
      ],
      postLoad: (context) async {
        // you can omit this optional event handler
        Console.log("Executing postLoad code from main.dart", scope: "exampleApp.postLoad", level: LogLevel.dev);
      },
      postSignOut: (context) async {
        // you can omit this optional event handler
        Console.log("Executing postSignOut code from main.dart", scope: "exampleApp.postSignOut", level: LogLevel.dev);
      },
      postSignIn: (
        context,
      ) async {
        // These console logs serve as a working example of how to include Console logging in
        // your own application. See <TODO add wiki> for more information.

        Console.log("Log example for quick usage. these will show up on prod level debug settings, so clean them up");

        Console.log(L10n.string("main_demo_l10n", placeholder: "this is a log from the L10n engine (placeholder)"));

        Console.log("Executing postSignIn code from main.dart", scope: "exampleApp.postSignIn");

        Console.log("Log example fframe level", scope: "exampleApp.postSignIn", level: LogLevel.fframe);

        Console.log("Log example dev level", scope: "exampleApp.postSignIn", level: LogLevel.dev);

        Console.log("Log example prod level", scope: "exampleApp.postSignIn", level: LogLevel.prod);
      },
    );
  }
}
