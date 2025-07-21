import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';

import 'unit_test_harness.dart';

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
