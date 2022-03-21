import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fframe/helpers/validator.dart';

import 'package:fframe_demo/models/user.dart';
import 'package:fframe_demo/services/user_service.dart';

// //Shows the selected customer in the right hand pane
class UserForm extends StatelessWidget {
  UserForm({required this.user, required this.documentReference, Key? key}) : super(key: key);
  final DocumentReference documentReference;
  final User user;
  final UserService usersService = UserService();

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
          controller: TextEditingController.fromValue(TextEditingValue(text: user.name!)),
          validator: (curValue) {
            if (validator.validName(curValue)) {
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
          controller: TextEditingController.fromValue(TextEditingValue(text: user.id!)),
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
          controller: TextEditingController.fromValue(TextEditingValue(text: user.creationDate!.toDate().toString())),
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
