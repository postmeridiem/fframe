import 'package:example/models/appuser.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

// //Shows the selected customer in the right hand pane
class UserForm extends StatelessWidget {
  const UserForm({required this.user, Key? key}) : super(key: key);
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    // register shared validator class for common patterns
    var validator = Validator();

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          readOnly: false,
          controller: TextEditingController.fromValue(
              TextEditingValue(text: user.displayName!)),
          validator: (curValue) {
            if (validator.validString(curValue)) {
              return null;
            } else {
              return 'Enter a valid email address';
            }
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User UID',
          ),
          readOnly: false,
          controller: TextEditingController.fromValue(
              TextEditingValue(text: user.uid ?? '')),
          validator: (curValue) {
            if (validator.validUUID(curValue)) {
              return null;
            } else {
              return 'Enter a valid UUID address';
            }
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
          ),
          controller: TextEditingController.fromValue(
              TextEditingValue(text: user.creationDate!.toDate().toString())),
          validator: (curValue) {
            if (validator.validEmail(curValue)) {
              return null;
            } else {
              return 'Enter a valid email address';
            }
          },
        ),
      ),
    ]);
  }
}
