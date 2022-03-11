import 'package:fframe/models/scratchpad.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/scratchpadService.dart';
import 'package:fframe/views/scratchpad/scratchpad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class scratchpadScreen extends StatefulWidget {
  const scratchpadScreen({
    Key? key,
    required this.active,
  }) : super(key: key);
  final bool active;

  @override
  State<scratchpadScreen> createState() => _scratchpadScreenState();
}

class _scratchpadScreenState extends State<scratchpadScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild scratchpadScreen ");
    return DocumentScreen<Scratchpad>(
      query: ScratchpadService().queryStream(active: widget.active),
      documentStream: (String? documentId) => ScratchpadService().documentStream(documentId: documentId),
      autoSave: false,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Scratchpad scratchpad) {
        //List Tile per scratchpad
        return scratchpadList(
          scratchpad: scratchpad,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<Scratchpad>? documentReference, Scratchpad scratchpad) {
        // var roles = ['', ''];

        // roles.contains("scratchpadEditor")

        return scratchpadDocument(
          documentReference: documentReference!,
          scratchpad: scratchpad,
          // allowEdit: roles.contains("scratchpadEditor"),
        );
      },
    );
  }
}
