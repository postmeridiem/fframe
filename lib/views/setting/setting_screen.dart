import 'package:fframe/models/setting.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/settingService.dart';
import 'package:fframe/views/setting/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild settingScreen ");
    return DocumentScreen<Setting>(
      query: SettingService().queryStream(),
      documentStream: (String? documentId) => SettingService().documentStream(documentId: documentId),
      autoSave: false,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Setting setting) {
        //List Tile per setting
        return settingList(
          setting: setting,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<Setting>? documentReference, Setting setting) {
        // var roles = ['', ''];

        // roles.contains("settingEditor")

        return SettingDocument(
          documentReference: documentReference!,
          setting: setting,
          // allowEdit: roles.contains("settingEditor"),
        );
      },
    );
  }
}
