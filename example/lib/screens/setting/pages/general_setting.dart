import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:example/helpers/prompts.dart';
import 'package:fframe/helpers/l10n.dart';

class SettingsGeneralForm extends StatefulWidget {
  const SettingsGeneralForm({Key? key}) : super(key: key);

  @override
  State<SettingsGeneralForm> createState() => _SettingsGeneralFormState();
}

class _SettingsGeneralFormState extends State<SettingsGeneralForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("presenting SettingsGeneralForm");

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
                promptOK(context, "let there be lightman", label);
                Fframe.of(context)!.setThemeMode(newThemeMode: ThemeMode.light);
                // App.l10nConfig.locale = const Locale('nl','');
              },
              child: const Text("let there be lightman"),
            ),
            const Text(
                'General settings - dunno probably will get culled in the end'),
          ],
        ),
      ),
    );
  }
}
