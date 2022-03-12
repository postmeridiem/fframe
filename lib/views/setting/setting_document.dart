import 'package:flutter/material.dart';
import 'package:fframe/models/setting.dart';
import 'package:fframe/views/setting/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class settingDocument extends StatelessWidget {
  const settingDocument({
    required this.setting,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Setting setting;
  final DocumentReference documentReference;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderCanvas(context, setting.name!),
              Divider(),
              ContentCanvas(context, setting),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentCanvas extends StatelessWidget {
  const ContentCanvas(BuildContext context, this.setting);
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    switch (setting.id) {
      case "01-generalsettings":
        {
          return Row(
            children: [
              SettingsGeneralForm(),
            ],
          );
        }

      case "02-managelists":
        {
          return Row(
            children: [
              SettingsListsForm(),
            ],
          );
        }

      case "99-advancedsettings":
        {
          return Row(
            children: [
              SettingsAdvancedForm(),
            ],
          );
        }

      default:
        {
          return Row(
            children: [
              Text("unconfigured"),
            ],
          );
        }
    }
  }
}

class ContextCanvas extends StatelessWidget {
  const ContextCanvas(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('context widget'),
                // Expanded(child: IgnorePointer()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderCanvas extends StatelessWidget {
  const HeaderCanvas(BuildContext context, this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DocumentTitle(context, title),
        Row(
          children: [
            Text(" [ save blurb ] "),
            Text(" [ form controls ] "),
          ],
        )
      ],
    );
  }
}

class DocumentTitle extends StatelessWidget {
  const DocumentTitle(BuildContext context, this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "${title.toUpperCase()}  ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
