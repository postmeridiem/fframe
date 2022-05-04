import 'package:flutter/material.dart';

class L10nConfig {
  L10nConfig({
    required this.enabled,
    required this.locale,
    required this.supportedLocales,
    required this.localizationsDelegates,
  });
  // this class configured what language
  // settings are provided to the MaterialApp

  // master switch if you want localization enabled in your project
  late bool enabled = false;

  // active locale
  late Locale locale;

  // define what locales you want active
  Iterable<Locale> supportedLocales = [];

  // mostly leave this one as is, unless you have a specific need
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [];
}
