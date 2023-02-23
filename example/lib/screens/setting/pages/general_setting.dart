import 'package:flutter/material.dart';
import 'package:fframe/helpers/console_logger.dart';

import 'package:example/helpers/prompts.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:fframe/helpers/fframe_prefs.dart';

class SettingsGeneralForm extends StatefulWidget {
  const SettingsGeneralForm({Key? key}) : super(key: key);

  @override
  State<SettingsGeneralForm> createState() => _SettingsGeneralFormState();
}

class _SettingsGeneralFormState extends State<SettingsGeneralForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Console.log("Opening SettingsGeneralForm", scope: "exampleApp.Settings");

    List<L10nReplacer> replacers = [
      L10nReplacer(from: "{locale}", replace: 'replaceworks'),
      L10nReplacer(from: "global", replace: 'KAZAN'),
    ];

    String label = L10n.interpolated(
      'test',
      placeholder: 'isniedaarnie',
      namespace: 'fframe',
      replacers: replacers,
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SettingsGeneralForm'),
            OutlinedButton(
              onPressed: () {
                promptOK(context, "testing l108 pull", label);
                // App.l10nConfig.locale = const Locale('nl','');
              },
              child: const Text("This is the placeholder and text at dev time"),
            ),
            OutlinedButton(
              onPressed: () {
                FframePrefs.setThemeMode(themeMode: ThemeMode.light);
              },
              child: const Text("make it light"),
            ),
            OutlinedButton(
              onPressed: () {
                FframePrefs.setThemeMode(themeMode: ThemeMode.dark);
              },
              child: const Text("make it dark"),
            ),
            OutlinedButton(
              onPressed: () {
                FframePrefs.setThemeMode(themeMode: ThemeMode.system);
              },
              child: const Text("make it system"),
            ),
            OutlinedButton(
              onPressed: () {
                FframePrefs.getThemeMode().then((value) {
                  switch (value) {
                    case ThemeMode.dark:
                      promptOK(context, "dark", "dark");
                      break;
                    case ThemeMode.light:
                      promptOK(context, "light", "light");
                      break;
                    case ThemeMode.system:
                      promptOK(context, "system", "system");
                      break;
                    default:
                      promptOK(context, "dunno", "dunno");
                  }
                });
              },
              child: const Text("what is in it?"),
            ),
            const Text(
                'General settings - dunno probably will get culled in the end'),
          ],
        ),
      ),
    );
  }
}
