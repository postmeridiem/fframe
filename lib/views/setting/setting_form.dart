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
    print("presenting SettingsGeneralForm");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SettingsGeneralForm'),
            Text('stuff like \n<feedback url link in top bar> \n<toggle logout button> visibility'),
          ],
        ),
      ),
    );
  }
}

class SettingsListsForm extends StatefulWidget {
  const SettingsListsForm({Key? key}) : super(key: key);

  @override
  State<SettingsListsForm> createState() => _SettingsListsFormState();
}

class _SettingsListsFormState extends State<SettingsListsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("presenting SettingsListsForm");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SettingsListsForm'),
            Text('stuff like \n<manage suggestion severity levels>, \n<manage suggestion categories>'),
          ],
        ),
      ),
    );
  }
}

class SettingsPagesForm extends StatefulWidget {
  const SettingsPagesForm({Key? key}) : super(key: key);

  @override
  State<SettingsPagesForm> createState() => _SettingsPagesFormState();
}

class _SettingsPagesFormState extends State<SettingsPagesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("presenting SettingsPagesForm");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SettingsPagesForm'),
            Text('manage any navigation entity that needs to exist w/o a left navgrid'),
            Text('<manage what happens on the home page>\n<manage any pages that need to be public>'),
          ],
        ),
      ),
    );
  }
}

class SettingsAdvancedForm extends StatefulWidget {
  const SettingsAdvancedForm({Key? key}) : super(key: key);

  @override
  State<SettingsAdvancedForm> createState() => _SettingsAdvancedFormState();
}

class _SettingsAdvancedFormState extends State<SettingsAdvancedForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("presenting SettingsAdvancedForm");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SettingsAdvancedForm'),
            Text('stuff like \n<enable and set up email registration>,\n<enable or disable dark or light mode>,\n<show users in navigation>'),
          ],
        ),
      ),
    );
  }
}
