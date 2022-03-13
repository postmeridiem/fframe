import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fframe/models/home.dart';
import 'package:fframe/services/homeService.dart';

// //Shows the selected customer in the right hand pane
class HomeForm extends StatelessWidget {
  HomeForm({required this.home, required this.documentReference, Key? key}) : super(key: key);
  final DocumentReference documentReference;
  final Home home;
  final HomeService homesService = HomeService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Text("this needs to dock against the navrail without the document list showing"),
          Text("I'm thinking I need to add pagescreen.dart to the screens, but that was overwhelming :)"),
          Text("also, should the url scheme be /home or /pages/home?\n"),
          Text("or are you thinking in another direction completely? "),
          Text("\n=========\n ${home.body} \n=========\n "),
          Row(
            children: [],
          )
        ],
      ),
    );
  }
}
