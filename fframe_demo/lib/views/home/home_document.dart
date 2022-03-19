import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fframe_demo/models/home.dart';
import 'package:fframe_demo/views/home/home_form.dart';

class HomeDocument extends StatelessWidget {
  const HomeDocument({
    required this.home,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Home home;
  final DocumentReference documentReference;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: MainCanvas(home: home, documentReference: documentReference),
        ),
        SizedBox(
          width: 250,
          child: ContextCanvas(home: home),
        ),
      ],
    );
  }
}

class MainCanvas extends StatelessWidget {
  const MainCanvas({Key? key, required this.home, required this.documentReference}) : super(key: key);
  final Home home;
  final DocumentReference documentReference;

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
                title: DocumentTitle(name: home.name!),
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
              HomeForm(home: home, documentReference: documentReference),
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

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({Key? key, required this.home}) : super(key: key);
  final Home home;

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
              children: const [],
            ),
          ),
        ),
      ),
    );
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
