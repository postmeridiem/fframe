import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fframe/models/user.dart';
import 'package:fframe/services/userService.dart';

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
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          readOnly: true,
          controller: TextEditingController.fromValue(TextEditingValue(text: user.name!)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User UID',
          ),
          readOnly: true,
          controller: TextEditingController.fromValue(TextEditingValue(text: user.id!)),
        ),
      ),
    ]);
  }
}
