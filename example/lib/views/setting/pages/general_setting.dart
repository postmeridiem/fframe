import 'package:flutter/material.dart';

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
                // App.l10nConfig.locale = const Locale('nl','');
              },
              child: const Text("header"),
            ),
            const Text(
                'General settings - dunno probably will get culled in the end'),
          ],
        ),
      ),
    );
  }
}
