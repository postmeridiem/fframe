import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe_demo/models/setting.dart';
import 'setting.dart';

class SettingScreen<Setting> extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Setting>(
      //Indicate where the documents are located and how to convert them to and fromt their models.
      collection: "/fframe/settings/collection",
      fromFirestore: Setting.fromFirestore,
      toFirestore: (setting, options) => setting.toFirestore(),
      createNew: () => Setting(),
      //Optional title widget
      titleBuilder: (context, data) {
        return Text(
          data.name ?? "New Setting",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        builder: (context, selected, data) {
          return SettingListItem(
            setting: data,
            selected: selected,
          );
        },
      ),

      // Center part, shows a fireatore doc. Tabs possible
      document: _document(),
    );
  }

  Document<Setting> _document() {
    return Document<Setting>(
      autoSave: false,
      tabs: [
        DocumentTab<Setting>(
          tabBuilder: () {
            return const Tab(
              text: "Setting",
              icon: Icon(
                Icons.tune,
              ),
            );
          },
          childBuilder: (setting) {
            switch (setting.id) {
              case "01-generalsettings":
                {
                  return const SettingsGeneralForm();
                }
              case "70-managelists":
                {
                  return const SettingsListsForm();
                }
              case "80-managepages":
                {
                  return const SettingsPagesForm();
                }
              case "99-advancedsettings":
                {
                  return const SettingsAdvancedForm();
                }
              default:
                {
                  return const Text("unconfigured");
                }
            }
          },
        ),
      ],
      contextCards: [],
    );
  }
}
