import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fframe/helpers/l10n.dart';

final L10nConfig l10nConfig = L10nConfig(
  enabled: true,
  supportedLocales: [
    const Locale('en', ''), // English, no country code
    const Locale('nl', ''), // Dutch, no country code
  ],
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
);
