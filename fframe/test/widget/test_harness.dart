import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';

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
    // Initialize L10n with a default config for testing
    L10n(
      l10nConfig: l10nConfig ??
          L10nConfig(
            locale: const Locale('en', 'US'),
            supportedLocales: [const Locale('en', 'US')],
            localizationsDelegates: [],
            source: L10nSource.assets,
          ),
      localeData: const {},
    );

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
