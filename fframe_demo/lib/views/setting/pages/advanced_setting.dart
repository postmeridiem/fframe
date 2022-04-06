import 'package:flutter/material.dart';

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
          children: const [
            Text('SettingsAdvancedForm'),
          ],
        ),
      ),
    );
  }
}
