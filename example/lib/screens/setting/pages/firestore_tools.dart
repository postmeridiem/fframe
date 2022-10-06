import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:url_launcher/url_launcher.dart';

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
          children: const [
            StampUpdater(),
          ],
        ),
      ),
    );
  }
}

class StampUpdater extends StatelessWidget {
  const StampUpdater({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                '==== The Firestore fucker-upper ====',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(200),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(top: 23, left: 8.0),
                          child: Text("Collection"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'enter the collection you want to stamp-update',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(top: 14, left: 8.0),
                          child: Text("Action"),
                        ),
                      ),
                      TableCell(
                        child: OperationSelector(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(top: 23, left: 8.0),
                          child: Text("Field name"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'enter the field do you want to stamp-update (or newly add)',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(top: 23, left: 8.0),
                          child: Text("Data type"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DataTypeSelector(),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24, left: 8.0),
                          child: Text("Target value"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'enter the value you want to stamp-update to all docs in collection',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.list, size: 18),
                        label: const Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Text('Open collection in FS...'),
                        ),
                        onPressed: () {
                          launchUrl(
                            Uri.https(
                              "console.firebase.google.com",
                              "/project/fframe-dev/firestore/data/",
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.nightlife, size: 18),
                        label: const Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Text('Apply values to collection'),
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
            ],
          ),
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

const List<String> types = <String>[
  'string',
  'number',
  'boolean',
  'timestamp',
  'null'
];

class DataTypeSelector extends StatefulWidget {
  const DataTypeSelector({Key? key}) : super(key: key);

  @override
  State<DataTypeSelector> createState() => _DataTypeSelectorState();
}

class _DataTypeSelectorState extends State<DataTypeSelector> {
  String dropdownValue = types.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 8,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: types.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(value),
          ),
        );
      }).toList(),
    );
  }
}

enum OperationType { update, delete }

class OperationSelector extends StatefulWidget {
  const OperationSelector({Key? key}) : super(key: key);

  @override
  State<OperationSelector> createState() => _OperationSelectorState();
}

class _OperationSelectorState extends State<OperationSelector> {
  OperationType? _operationType = OperationType.update;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 200,
          child: ListTile(
            title: const Text(
              'Update',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            leading: Radio<OperationType>(
              value: OperationType.update,
              groupValue: _operationType,
              onChanged: (OperationType? value) {
                setState(() {
                  _operationType = value;
                });
              },
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: ListTile(
            title: const Text(
              'Delete',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            leading: Radio<OperationType>(
              value: OperationType.delete,
              groupValue: _operationType,
              onChanged: (OperationType? value) {
                setState(() {
                  _operationType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
