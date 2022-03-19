import 'package:fframe/fframe.dart';
import 'package:fframe_demo/models/home.dart';
import 'package:fframe_demo/services/home_service.dart';
import 'package:fframe_demo/views/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Home>(
      key: key,
      query: HomeService().homeByMakeStream,
      documentStream: (String? documentId) => HomeService().documentStream(documentId: documentId),
      documentTabs: const [],
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Home home) {
        //List Tile per home
        return HomeList(
          home: home,
          selected: selected,
        );
      },
      titleBuilder: (Home home) {
        return const Text("Home");
      },
      //Right hand (document) pane
      documentBuilder: (
        BuildContext context,
        DocumentReference<Home> documentReference,
        Home home,
        // List<ActionButton> actionButtons,
        // List<DocumentTab> documentTabs,
        // List<Widget>? contextWidgets,
      ) {
        return HomeDocument(
          home: home,
          documentReference: documentReference,
        );
      },
    );
  }
}
