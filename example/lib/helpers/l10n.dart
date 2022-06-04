import 'package:flutter/material.dart';

import 'package:fframe/helpers/l10n.dart';
export 'package:fframe/helpers/l10n.dart';

// to manage the translations and labels, update the
// translation files your project's assets dir

L10nConfig l10nConfig = L10nConfig(
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
  localizationsDelegates: [],

  source: L10nSource.assets,
);
