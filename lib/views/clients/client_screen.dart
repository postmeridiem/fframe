import 'package:fframe/models/client.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/clientService.dart';
import 'package:fframe/views/clients/clients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class clientScreen extends StatefulWidget {
  const clientScreen({
    Key? key,
    required this.active,
  }) : super(key: key);
  final bool active;

  @override
  State<clientScreen> createState() => _clientScreenState();
}

class _clientScreenState extends State<clientScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild clientScreen ");
    return DocumentScreen<Client>(
      query: ClientService().queryStream(active: widget.active),
      documentStream: (String? documentId) => ClientService().documentStream(documentId: documentId),
      autoSave: false,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Client client) {
        //List Tile per client
        return clientList(
          client: client,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<Client>? documentReference, Client client) {
        // var roles = ['', ''];

        // roles.contains("clientEditor")

        return clientDocument(
          documentReference: documentReference!,
          client: client,
          // allowEdit: roles.contains("clientEditor"),
        );
      },
    );
  }
}
