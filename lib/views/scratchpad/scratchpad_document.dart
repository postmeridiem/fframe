import 'package:flutter_highlight/themes/solarized-dark.dart';
import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:fframe/models/scratchpad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/iap/v1.dart';

import 'package:flutter_highlight/flutter_highlight.dart';

class scratchpadDocument extends StatelessWidget {
  const scratchpadDocument({
    required this.scratchpad,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Scratchpad scratchpad;
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
              HeaderCanvas(context, scratchpad.name!),
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
                  color: Colors.cyanAccent.shade400,
                )),
                Tab(
                    icon: Icon(
                  Icons.directions_transit,
                  color: Colors.cyanAccent.shade400,
                )),
                Tab(
                    icon: Icon(
                  Icons.directions_bike,
                  color: Colors.cyanAccent.shade400,
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
                OutlinedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('call api remote'),
                  onPressed: () async {
                    throwPopup(context, "data from api", await readFastAPI(prodenv: true));
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('call api local'),
                  onPressed: () async {
                    throwPopup(context, "data from api", await readFastAPI(prodenv: false));
                  },
                ),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal[800]),
          ),
        ),
      ),
    );
  }
}

// class FormTabs extends StatelessWidget {
//   const FormTabs(BuildContext context);

//   late TabController _tabController = TabController(vsync: this, length: 0);
//   final NavigationTab navigationTab;

//   @override
//   Widget build(BuildContext context) {
//     TabBar? _tabBar = null;
//     Widget? _contentBody; //= widget.navigationTarget.contentPane;
//     Widget? _scaffoldBody = null;

//     if (widget.navigationTarget.navigationTabs != null) {
//       //Process the tabbar;
//       _tabBar = TabBar(
//         tabs: [
//           Tab(
//               icon: Icon(
//             Icons.directions_car,
//             color: Colors.cyanAccent.shade400,
//           )),
//           Tab(
//               icon: Icon(
//             Icons.directions_transit,
//             color: Colors.cyanAccent.shade400,
//           )),
//           Tab(
//               icon: Icon(
//             Icons.directions_bike,
//             color: Colors.cyanAccent.shade400,
//           )),
//         ],
//         controller: _tabController,
//         onTap: (index) => _tabBarTap(context, index),
//       );

//       if (navigationTab.contentPane != null) {
//         _contentBody = navigationTab.contentPane;
//       } else {
//         _contentBody = EmptyScreen();
//       }
//     } else {
//       //Process from a screen without tabs
//       if (widget.navigationTarget.contentPane != null) {
//         _contentBody = widget.navigationTarget.contentPane;
//       } else {
//         _contentBody = EmptyScreen();
//       }
//     }

//     //Prevent content body from being empty.
//     _contentBody = _contentBody != null ? _contentBody : EmptyScreen();
//     _scaffoldBody = const TabBarView(
//       children: [
//         Icon(Icons.directions_car),
//         Icon(Icons.directions_transit),
//         Icon(Icons.directions_bike),
//       ],
//     );
//     return Scaffold(
//       appBar: _tabBar,
//       body: _scaffoldBody,
//     );
//   }
// }

readFastAPI({bool prodenv = true}) async {
  Uri uri;
  var signIn = GoogleSignIn(
    scopes: <String>[CloudIAPApi.cloudPlatformScope],
  );
  await signIn.signInSilently();
  GoogleSignInAccount? _currentUser = signIn.currentUser;
  Map<String, String> _headers = await _currentUser!.authHeaders;

  try {
    if (prodenv) {
      uri = Uri.https('admin-api.churned.io', 'clients/read/ex1', {'limit': '10'});
    } else {
      uri = Uri.http('127.0.0.1:8000', 'clients/read/ex1', {'limit': '10'});
    }

    var response = await http.get(uri, headers: _headers);
    return response.body.toString();
  } catch (e) {
    print(e);
    return "{}";
  }
}

Future<void> throwPopup(context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      // poor mans code expander -.-
      var msgrewrapped = message.replaceAll(",", ",\n").replaceAll("{", "{\n").replaceAll("}", "\n}");
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              FormattedJSON("${msgrewrapped}"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Would you like to approve of this message?'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('I Approve!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class FormattedJSON extends StatelessWidget {
  final String data;

  FormattedJSON(this.data);

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      // The original code to be highlighted
      data,

      // Specify language
      // It is recommended to give it a value for performance
      language: 'json',

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      theme: solarizedDarkTheme,

      // Specify padding
      padding: EdgeInsets.all(12),

      // Specify text style
      textStyle: TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 16,
      ),
    );
  }
}
