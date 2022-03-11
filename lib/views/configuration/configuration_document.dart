import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:fframe/models/configuration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/iap/v1.dart';

import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';

class configurationDocument extends StatelessWidget {
  const configurationDocument({
    required this.configuration,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Configuration configuration;
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
              HeaderCanvas(context, configuration.name!),
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
        child: SKUTable(),
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

class SKUTable extends StatefulWidget {
  SKUTable({Key? key}) : super(key: key);
  @override
  State<SKUTable> createState() => _SKUTableState();
}

class _SKUTableState extends State<SKUTable> {
  _SKUTableState();

  @override
  void initState() {
    //for future use, you'll know when.....
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var skusCollection = FirebaseFirestore.instance
        //wrap
        .collection('sku')
        .orderBy('creationDate', descending: false)
        .where('active', isEqualTo: true);
    return SingleChildScrollView(
      child: Scrollbar(
        child: FirestoreDataTable(
          rowsPerPage: 10,
          showCheckboxColumn: false,
          showFirstLastButtons: true,
          query: skusCollection,
          columnLabels: {
            'name': Text('Name'),
            'creationDate': Text('Created'),
            'updatedDate': Text('Updated'),
          },
        ),
      ),
    );
  }
}
