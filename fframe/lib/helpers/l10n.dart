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

// apply a url parameter (e.g. ?locale=en_US) to the default language
l10nUrlReader(Locale defaultLoc, {String urlparam = "locale"}) {
  Locale _output;
  List<String> rawuri = Uri.base.toString().split("#");
  Uri actual = Uri.parse(rawuri[1]);

  if (actual.queryParameters[urlparam] != null) {
    String _locationquery = actual.queryParameters[urlparam] as String;
    String _language;
    String _country;

    // check for full or partial (language only) configurations
    // and then fill the outputs
    if (_locationquery.contains('_')) {
      List<String> _localesplit = _locationquery.split("_");
      _language = _localesplit[0];
      _country = _localesplit[1];
    } else {
      _language = _locationquery;
      _country = '';
    }
    _output = Locale(_language, _country);
  } else {
    // there was no query parameter
    _output = defaultLoc;
  }
  debugPrint("Locale set to [$_output]");
  return _output;
}
