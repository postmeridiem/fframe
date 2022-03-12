import 'package:flutter/material.dart';
import 'package:fframe/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class suggestionDocument extends StatelessWidget {
  const suggestionDocument({
    required this.suggestion,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Suggestion suggestion;
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
              HeaderCanvas(context, suggestion.name!),
              Divider(),
              ContentCanvas(context),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentCanvas extends StatelessWidget {
  const ContentCanvas(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainCanvas(context),
        ContextCanvas(context),
      ],
    );
  }
}

class MainCanvas extends StatelessWidget {
  const MainCanvas(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 680,
        width: double.infinity,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.directions_car,
                  color: Colors.pink.shade900,
                )),
                Tab(
                    icon: Icon(
                  Icons.directions_transit,
                  color: Colors.pink.shade900,
                )),
                Tab(
                    icon: Icon(
                  Icons.directions_bike,
                  color: Colors.pink.shade900,
                )),
              ],
            ),
            body: TabBarView(
              children: [
                Container(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
          ),
        ),
      ),
    );
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
        HeaderControlWidget(context),
      ],
    );
  }
}

class HeaderControlWidget extends StatelessWidget {
  const HeaderControlWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(" [ save blurb ] "),
      Text(" [ form controls ] "),
    ]);
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
