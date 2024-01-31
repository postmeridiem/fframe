import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';

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
    String output = placeholder;
    // if (key == 'suggestions_tab_active') {
    //   debugger;
    // }
    if (L10n.instance.map.containsKey(namespace)) {
      var selectedNameSpace = L10n.instance.map[namespace];
      if (selectedNameSpace.containsKey(key)) {
        output = selectedNameSpace[key]!['translation'];
      } else {}
    } else {
      Console.log(
        "ERROR: Unknown namespace: $namespace while looking for <$key>",
        scope: "fframeLog.L10N.string",
        level: LogLevel.prod,
      );
    }
    return output;
  }

  static String interpolated(
    String key, {
    required String placeholder,
    String namespace = "global",
    required List<L10nReplacer> replacers,
  }) {
    String output = string(key, placeholder: placeholder, namespace: namespace);

    for (var replacer in replacers) {
      output = output.replaceAll(replacer.from, replacer.replace);
    }

    return output;
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

  static DateTime dateTimeFromTimestamp({required Timestamp timestamp}) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  static String stringFromDateTime({required DateTime datetime, String? formatMask}) {
    return DateFormat(formatMask ?? 'yyyy-MM-dd  HH:mm').format(datetime);
  }

  static String stringFromTimestamp({required Timestamp timestamp}) {
    return stringFromDateTime(datetime: dateTimeFromTimestamp(timestamp: timestamp));
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
    Locale output;
    String baseUrl = Uri.base.toString();
    if (!baseUrl.contains('#')) {
      // url is not a deeplink, no locale specified
      return defaultLoc;
    }
    List<String> rawuri = Uri.base.toString().split("#");
    Uri actual = Uri.parse(rawuri[1]);

    if (actual.queryParameters[urlparam] != null) {
      String locationquery = actual.queryParameters[urlparam] as String;
      String language;
      String country;

      // check for full or partial (language only) configurations
      // and then fill the outputs
      if (locationquery.contains('_')) {
        List<String> localesplit = locationquery.split("_");
        language = localesplit[0];
        country = localesplit[1];
      } else {
        language = locationquery;
        country = '';
      }
      output = Locale(language, country);
    } else {
      // there was no query parameter
      output = defaultLoc;
    }
    return output;
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
    Map<String, dynamic> output = {'fframe': {}, 'global': {}};
    List<String> namespaces = config.namespaces as List<String>;
    String mode = config.source.mode;

    Console.log("Translation loader mode: $mode.", scope: "fframeLog.L10N", level: LogLevel.fframe);
    switch (mode) {
      case 'local_assets':
        {
          for (String namespace in namespaces) {
            String sourcepath = "assets/translations/${namespace}_${config.locale.languageCode}_${config.locale.countryCode}.json";
            Console.log("Loading namespace translations from path: <$sourcepath>.", scope: "fframeLog.L10N", level: LogLevel.fframe);
            // loading namespace for locale
            final String response = await DefaultAssetBundle.of(context).loadString(sourcepath);
            final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
            output[namespace] = data;
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
        throw ("fframeLog.L10N: ERROR: Unconfigured translation source.");
    }

    return output;
  }
}
