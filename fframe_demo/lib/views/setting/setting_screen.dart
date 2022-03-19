import 'package:fframe/fframe.dart';
import 'package:fframe_demo/models/setting.dart';
import 'package:fframe_demo/services/setting_service.dart';
import 'package:fframe_demo/views/setting/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild settingScreen ");
    return DocumentScreen<Setting>(
      query: SettingService().queryStream(),
      documentStream: (String? documentId) => SettingService().documentStream(documentId: documentId),
      autoSave: false,
      documentTabs: const [],

      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Setting setting) {
        //List Tile per setting
        return settingList(
          setting: setting,
          selected: selected,
        );
      },
      titleBuilder: (Setting setting) {
        return Text(setting.name ?? "New Setting");
      },
      //Right hand (document) pane
      documentBuilder: (
        BuildContext context,
        DocumentReference<Setting> documentReference,
        Setting setting,
        // List<ActionButton> actionButtons,
        // List<DocumentTab> documentTabs,
        // List<Widget>? contextWidgets,
      ) {
        // var roles = ['', ''];

        // roles.contains("settingEditor")

        return SettingDocument(
          documentReference: documentReference,
          setting: setting,
          // allowEdit: roles.contains("settingEditor"),
        );
      },
    );
  }
}
