import 'package:fframe/models/home.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/homeService.dart';
import 'package:fframe/views/home/home.dart';
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
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Home home) {
        //List Tile per home
        return HomeList(
          home: home,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<Home> documentReference, Home home) {
        return HomeDocument(
          home: home,
          documentReference: documentReference,
        );
      },
    );
  }
}
