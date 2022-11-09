import 'dart:convert';

import 'package:flutter/material.dart';

class L10n {
  static final L10n instance = L10n._internal();

// stores the current config
  late L10nConfig config;
// stores current language map. has some boot up defaults
  late Map<String, dynamic> map = {};

  L10n._internal();

  factory L10n({required L10nConfig l10nConfig, required Map<String, dynamic> localeData}) {
    instance.config = l10nConfig;
    instance.map = localeData;

    return instance;
  }

  static String string(
    String key, {
    required String placeholder,
    String namespace = "global",
  }) {
    String _output = placeholder;
    // if (key == 'suggestions_tab_active') {
    //   debugger;
    // }
    if (L10n.instance.map.containsKey(namespace)) {
      var _namespace = L10n.instance.map[namespace];
      if (_namespace.containsKey(key)) {
        _output = _namespace[key]!['translation'];
      } else {
        // debugPrint("L10N MISSING KEY: Inserted placeholder. Key not found: <$key>.");
      }
    } else {
      debugPrint("L10N ERROR: Unknown namespace: $namespace.");
    }
    return _output;
  }

  static String interpolated(
    String key, {
    required String placeholder,
    String namespace = "global",
    required List<L10nReplacer> replacers,
  }) {
    String _output = string(key, placeholder: placeholder, namespace: namespace);

    for (var replacer in replacers) {
      _output = _output.replaceAll(replacer.from, replacer.replace);
    }

    return _output;
  }

  static Locale getLocale() {
    return L10n.instance.config.locale;
  }

  static Iterable<LocalizationsDelegate<dynamic>> getDelegates() {
    return L10n.instance.config.localizationsDelegates;
  }

  static Iterable<Locale> getLocales() {
    return L10n.instance.config.supportedLocales;
  }
}

class L10nConfig {
  L10nConfig({
    required this.locale,
    required this.supportedLocales,
    required this.localizationsDelegates,
    required this.source,
    this.namespaces,
  });
  // this class configured what language
  // settings are provided to the MaterialApp

  // active locale
  late Locale locale;

  // define what locales you want active
  Iterable<Locale> supportedLocales = [];

  // mostly leave this one as is, unless you have a specific need
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [];

  // define what namespaces you want active
  List<String>? namespaces = ['fframe', 'global'];

  // define what root url to download the language files from.
  // if it is unspecified, the language files will be loaded
  // from your lib/l10n/ dir
  L10nSource source;

// apply a url parameter (e.g. ?locale=en_US) to the default language
  static Locale urlReader(Locale defaultLoc, {String urlparam = "locale"}) {
    Locale _output;
    String _baseUrl = Uri.base.toString();
    if (!_baseUrl.contains('#')) {
      // url is not a deeplink, no locale specified
      return defaultLoc;
    }
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
}

class L10nSource {
  L10nSource({this.mode = 'local_assets'});
  final String mode;

  static L10nSource assets = L10nSource(mode: 'local_assets');
  static L10nSource bucket = L10nSource(mode: 'firebase_bucket');
  static L10nSource firestore = L10nSource(mode: 'firestore_collection');
}

class L10nReplacer {
  L10nReplacer({required this.from, required this.replace});
  final String from;
  final String replace;
}

class L10nReader {
  L10nReader();

  static Future<Map<String, dynamic>> read(BuildContext context, L10nConfig config) async {
    Map<String, dynamic> _output = {'fframe': {}, 'global': {}};
    List<String> _namespaces = config.namespaces as List<String>;
    String _mode = config.source.mode;

    debugPrint("L10N: Translation loader mode: $_mode.");
    switch (_mode) {
      case 'local_assets':
        {
          for (String _namespace in _namespaces) {
            String _sourcepath = "assets/translations/${_namespace}_${config.locale.languageCode}_${config.locale.countryCode}.json";
            debugPrint("L10N: Loading namespace translations from path: <$_sourcepath>.");
            // loading namespace for locale
            final String response = await DefaultAssetBundle.of(context).loadString(_sourcepath);
            final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
            _output[_namespace] = data;
          }
        }
        break;
      case 'firebase_bucket':
        {}
        break;
      case 'firestore_collection':
        {}
        break;

      default:
        throw ("L10N ERROR: Unconfigured translation source.");
    }

    return _output;
  }
}
