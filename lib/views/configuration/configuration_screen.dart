import 'package:fframe/models/configuration.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/configurationService.dart';
import 'package:fframe/views/configuration/configuration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class configurationScreen extends StatefulWidget {
  const configurationScreen({Key? key}) : super(key: key);

  @override
  State<configurationScreen> createState() => _configurationScreenState();
}

class _configurationScreenState extends State<configurationScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild configurationScreen ");
    return DocumentScreen<Configuration>(
      query: ConfigurationService().queryStream(active: true),
      documentStream: (String? documentId) => ConfigurationService().documentStream(documentId: documentId),
      autoSave: false,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Configuration configuration) {
        //List Tile per configuration
        return configurationList(
          configuration: configuration,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<Configuration>? documentReference, Configuration configuration) {
        // var roles = ['', ''];

        // roles.contains("configurationEditor")

        return configurationDocument(
          documentReference: documentReference!,
          configuration: configuration,
          // allowEdit: roles.contains("configurationEditor"),
        );
      },
    );
  }
}
