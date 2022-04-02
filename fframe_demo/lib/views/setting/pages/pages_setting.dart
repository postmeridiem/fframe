import 'package:flutter/material.dart';

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
          children: const [
            Text('SettingsPagesForm'),
            Text(
                'Manage any navigation entity that needs to exist as a static page'),
            Text('Manage what happens on the home page'),
            Text('Manage any pages that need to be public'),
          ],
        ),
      ),
    );
  }
}
