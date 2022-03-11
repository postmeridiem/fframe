import 'package:fframe/models/runConfig.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/runConfigService.dart';
import 'package:fframe/views/runConfigs/runConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class runConfigScreen extends StatefulWidget {
  const runConfigScreen({Key? key}) : super(key: key);

  @override
  State<runConfigScreen> createState() => _runConfigScreenState();
}

class _runConfigScreenState extends State<runConfigScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild runConfigScreen ");
    return DocumentScreen<RunConfig>(
      query: RunConfigService().queryStream(active: true),
      documentStream: (String? documentId) => RunConfigService().documentStream(documentId: documentId),
      autoSave: false,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, RunConfig runConfig) {
        //List Tile per runConfig
        return RunConfigList(
          runConfig: runConfig,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<RunConfig>? documentReference, RunConfig runConfig) {
        // var roles = ['', ''];

        // roles.contains("runConfigEditor")

        return RunConfigDocument(
          documentReference: documentReference!,
          runConfig: runConfig,
          // allowEdit: roles.contains("runConfigEditor"),
        );
      },
    );
  }
}
