// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/helpers/strings.dart';

class SettingsFirestoreToolsForm extends StatefulWidget {
  const SettingsFirestoreToolsForm({Key? key}) : super(key: key);

  @override
  State<SettingsFirestoreToolsForm> createState() =>
      _SettingsFirestoreToolsFormFormState();
}

class _SettingsFirestoreToolsFormFormState
    extends State<SettingsFirestoreToolsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("presenting Firestore Tools");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '==== The Firestore Fucker-upper ====',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.tertiary,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(500),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Collection"),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'enter the collection you want to stamp-update',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Action"),
                                ),
                              ),
                              TableCell(
                                child: Row(
                                  children: [
                                    Text("radio 1"),
                                    Text("radio 2"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Field name"),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'enter the field do you want to stamp-update (or newly add)',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Data type"),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'enter the value you want to stamp-update to all docs in collection',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Target value"),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'enter the value you want to stamp-update to all docs in collection',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.nightlife, size: 18),
                            label: const Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              child: Text('Click it FOR GLORY...'),
                            ),
                            onPressed: () {
                              forAllInCollection('none');
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Card(
            //   color: Theme.of(context).colorScheme.tertiary,
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: Column(
            //       children: [
            //         Row(
            //           children: const [
            //             Text("collection"),
            //             TextField(),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

forAllInCollection(String collection) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db.collection(collection).get().then(
        (res) => {
          res.docs.forEach((snap) {
            Map<String, dynamic> doc = snap.data();
            Timestamp _cdTS = doc['createdDate'];
            Timestamp _edTS = Timestamp((_cdTS.seconds + 7776000), 0);
            debugPrint(
                "${snap.id} - created: ${dateTimeTextTS(_cdTS)} ---> expires: ${dateTimeTextTS(_edTS)}");

            final data = {"expirationDate": _edTS};
            db
                .collection(collection)
                .doc(snap.id)
                .set(data, SetOptions(merge: true));
          }),
        },
        onError: (e) => print("Error completing: $e"),
      );

  return true;
}

touchUpdateDate(String collection) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db.collection(collection).get().then(
        (res) => {
          res.docs.forEach((snap) {
            Timestamp _updateStamp = Timestamp.now();
            debugPrint("${snap.id} - updated record");

            final data = {"updatedDate": _updateStamp};
            db
                .collection(collection)
                .doc(snap.id)
                .set(data, SetOptions(merge: true));
          }),
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );

  return true;
}
