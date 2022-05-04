import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fframe/helpers/l10n.dart';

final L10nConfig l10nConfig = L10nConfig(
  // if you disable this, no Localizations
  // will be made available. You also need
  // to set generate to false on flutter in
  // your pubspec.yaml and remove any usage
  enabled: true,

  // the default locale your App starts with
  locale: const Locale('en', ''),

  // the list of locales that are supported by your app
  supportedLocales: [
    const Locale('en', ''), // English, no country code
    const Locale('nl', ''), // Dutch, no country code
  ],

  // the localizations you make available to the
  // App. The top two are flutter and material level
  // localizations. The bottom one is the l10n integration
  localizationsDelegates: [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    AppLocalizations.delegate,
  ],
);
