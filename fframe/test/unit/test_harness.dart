import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/l10n.dart';

/// Initializes the necessary Fframe singletons for unit testing.
///
/// Call this function in the `setUp` block of your test files.
void setupUnitTests() {
  // L10n calls Console.log, so the Console must be initialized first.
  Console(logThreshold: LogLevel.prod);

  // Initialize L10n with mock data
  L10n(
    l10nConfig: L10nConfig(
      locale: const Locale('en', 'US'),
      supportedLocales: [const Locale('en', 'US')],
      localizationsDelegates: [],
      source: L10nSource.assets,
    ),
    localeData: {
      'global': {
        'greeting': {'translation': 'Hello, World!'},
      },
      'user': {
        'profile_title': {'translation': 'User Profile'},
      },
    },
  );
}