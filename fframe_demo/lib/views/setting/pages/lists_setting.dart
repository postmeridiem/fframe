import 'package:flutter/material.dart';

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
          children: const [
            Text('SettingsListsForm'),
            Text('Manage lists for selection boxes and stuff'),
          ],
        ),
      ),
    );
  }
}
