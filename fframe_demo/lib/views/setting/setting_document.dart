import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:fframe_demo/models/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fframe_demo/views/setting/setting.dart';

class SettingDocument extends StatelessWidget {
  const SettingDocument({
    required this.setting,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Setting setting;
  final DocumentReference documentReference;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: MainCanvas(setting: setting),
        ),
        SizedBox(
          width: 250,
          child: ContextCanvas(setting: setting),
        ),
      ],
    );
  }
}

class MainCanvas extends StatelessWidget {
  const MainCanvas({Key? key, required this.setting}) : super(key: key);
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        primary: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                primary: false,
                title: DocumentTitle(name: setting.name!),
                floating: true,
                pinned: false,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                // TODO: figure out how to get the appbar here without the tabs
                bottom: const TabBar(
                  tabs: <Tab>[
                    Tab(
                      icon: Icon(
                        Icons.settings,
                      ),
                    ),
                  ], // <-- total of 2 tabs
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SettingsFormSelector(setting: setting),
            ],
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
              onPressed: () => {},
              icon: Icon(
                Icons.close,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            ActionButton(
              onPressed: () => {},
              icon: Icon(
                Icons.save,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            ActionButton(
              onPressed: () => {},
              icon: Icon(
                Icons.add,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsFormSelector extends StatelessWidget {
  const SettingsFormSelector({Key? key, required this.setting}) : super(key: key);
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    switch (setting.id) {
      case "01-generalsettings":
        {
          return const SettingsGeneralForm();
        }
      case "02-managelists":
        {
          return const SettingsListsForm();
        }
      case "03-managepages":
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
  }
}

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({Key? key, required this.setting}) : super(key: key);
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                ContextWidgetCard(title: "sidewidget 1"),
                ContextWidgetCard(title: "sidewidget 2"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderCanvas extends StatelessWidget {
  const HeaderCanvas({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DocumentTitle(name: title),
        const HeaderControlWidget(),
      ],
    );
  }
}

class HeaderControlWidget extends StatelessWidget {
  const HeaderControlWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      Card(
        child: Text(""),
      ),
      Card(
        child: Text(" [ form controls ] "),
      ),
    ]);
  }
}

class DocumentTitle extends StatelessWidget {
  const DocumentTitle({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ContextWidgetCard extends StatelessWidget {
  const ContextWidgetCard({Key? key, context, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Column(children: [
            Text(title,
                style: TextStyle(
                  // fontFamily: mainFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )),
            Divider(color: Theme.of(context).colorScheme.onBackground),
            Text(
              "injected widget goes here",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
