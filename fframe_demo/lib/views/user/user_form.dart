import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fframe_demo/models/user.dart';
import 'package:fframe_demo/services/user_service.dart';

// //Shows the selected customer in the right hand pane
class UserForm extends StatelessWidget {
  UserForm({required this.user, required this.documentReference, Key? key}) : super(key: key);
  final DocumentReference documentReference;
  final User user;
  final UserService usersService = UserService();
  // bool _toggled = false; //Dit kan niet... en zit op het verkeerde nivo. Toggled is niet een state van het document maar
  //is een state van de toggle-switch. Dus die ziet in de allClaims Loop

  @override
  Widget build(BuildContext context) {
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
          validator: (email) {
            if (validName(email)) {
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
          validator: (email) {
            if (validUUID(email)) {
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
          validator: (email) {
            if (validEmail(email)) {
              return null;
            } else {
              return 'Enter a valid email address';
            }
          },
        ),
      ),
    ]);
  }

  bool validName(String? email) {
    return true;
  }

  bool validUUID(String? email) {
    return true;
  }

  bool validEmail(String? email) {
    return true;
  }
}
