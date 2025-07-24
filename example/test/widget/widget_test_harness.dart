import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:firebase_core/firebase_core.dart';

import '../unit/unit_test_harness.dart';

final FirebaseOptions mockFirebaseOptions = FirebaseOptions(
  apiKey: 'test-api-key',
  appId: '1:1234567890:web:abcdef123456',
  messagingSenderId: '1234567890',
  projectId: 'test-project-id',
);

/// DEPRECATED: [MinimalFframe] is deprecated for widget testing. Use [TestHarness] instead.
class MinimalFframe extends StatelessWidget {
  final Widget child;
  const MinimalFframe({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Fframe(
      title: "Test",
      firebaseOptions: mockFirebaseOptions,
      navigationConfig: NavigationConfig(
        navigationTargets: [],
        signInConfig: SignInConfig(signInTarget: NavigationTarget(
          path: "/sign-in",
          title: "Sign In",
          contentPane: Container(),
          public: true,
        )),
        errorPage: NavigationTarget(
          path: "/error",
          title: "Error",
          contentPane: Container(),
          public: true,
        ),
        emptyPage: NavigationTarget(
          path: "/empty",
          title: "Empty",
          contentPane: Container(),
          public: true,
        ),
        waitPage: NavigationTarget(
          path: "/wait",
          title: "Wait",
          contentPane: child,
          public: true,
        ),
      ),
      lightMode: ThemeData.light(),
      darkMode: ThemeData.dark(),
      themeMode: ThemeMode.system,
      l10nConfig: L10nConfig(
        locale: const Locale('en', 'US'),
        supportedLocales: [const Locale('en', 'US')],
        localizationsDelegates: const [],
        source: L10nSource.assets,
        namespaces: ['fframe', 'global'],
      ),
      consoleLogger: Console(logThreshold: LogLevel.dev),
      providerConfigs: const [],
      enableNotficationSystem: false,
      debugShowCheckedModeBanner: false,
      globalActions: const [],
      postLoad: (_) async {},
      postSignIn: (_) async {},
      postSignOut: (_) async {},
    );
  }
}

/// [TestHarness] is the preferred test harness for widget tests in this project.
///
/// It sets up a [MaterialApp] with L10n and Console logger singletons initialized via [setupUnitTests].
/// This avoids async and Firestore dependencies, and ensures localization and logging are available.
///
/// Usage:
///   await tester.pumpWidget(TestHarness(child: MyWidget()));
///
/// [MinimalFframe] is deprecated for widget testing and should not be used in new or migrated tests.
class TestHarness extends StatelessWidget {
  const TestHarness({
    super.key,
    required this.child,
    this.l10nConfig,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
  });

  final Widget child;
  final L10nConfig? l10nConfig;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    // Initialize singletons using the centralized unit test setup.
    setupUnitTests();

    return MaterialApp(
      theme: theme ?? ThemeData.light(),
      darkTheme: darkTheme ?? ThemeData.dark(),
      themeMode: themeMode,
      locale: L10n.getLocale(),
      supportedLocales: L10n.getLocales(),
      localizationsDelegates: L10n.getDelegates(),
      home: Scaffold(
        body: child,
      ),
    );
  }
}
