import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/setting.dart';
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
      // formKey: GlobalKey<FormState>(),
      //Indicate where the documents are located and how to convert them to and fromt their models.
      collection: "/fframe/settings/collection",
      fromFirestore: Setting.fromFirestore,
      toFirestore: (setting, options) => setting.toFirestore(),
      query: (query) {
        return query.where("active", isEqualTo: true);
      },
      createNew: () => Setting(),
      //Optional title widget
      titleBuilder: (context, data) {
        return Text(
          data.name ?? "New Setting",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        showCreateButton: false,
        builder: (_, selected, data, __) {
          return SettingListItem(
            setting: data,
            selected: selected,
          );
        },
      ),

      // Center part, shows a fireatore doc. Tabs possible
      document: settingDocument(),
    );
  }
}

Document<Setting> settingDocument() {
  return Document<Setting>(
    autoSave: false,
    showSaveButton: false,
    scrollableHeader: false,
    documentTabsBuilder: (context, data, isReadOnly, isNew, fFrameUser) {
      return [
        DocumentTab<Setting>(
          lockViewportScroll: true,
          tabBuilder: (fFrameUser) {
            return const Tab(
              text: "Setting",
              icon: Icon(
                Icons.tune,
              ),
            );
          },
          childBuilder: (setting, readOnly) {
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
              case "98-palette":
                {
                  return const PaletteForm();
                }
              case "99-firestore-tools":
                {
                  return const SettingsFirestoreToolsForm();
                }
              default:
                {
                  return const Text("unconfigured");
                }
            }
          },
        ),
      ];
    },
    contextCards: [],
  );
}
