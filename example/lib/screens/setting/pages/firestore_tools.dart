import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe/helpers/l10n.dart';

class SettingsFirestoreToolsForm extends StatefulWidget {
  const SettingsFirestoreToolsForm({super.key});

  @override
  State<SettingsFirestoreToolsForm> createState() => _SettingsFirestoreToolsFormFormState();
}

class _SettingsFirestoreToolsFormFormState extends State<SettingsFirestoreToolsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Console.log("Opening SettingsFirestoreToolsForm", scope: "exampleApp.Settings");

    return Form(
      key: _formKey,
      child: const Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StampUpdater(),
          ],
        ),
      ),
    );
  }
}

enum OperationType { update, delete }

class StampUpdate {
  StampUpdate({
    this.collection = '',
    this.operation = OperationType.update,
    this.fieldName = '',
    this.dataType = '',
    this.targetValueInput = '',
  });
  String collection;
  OperationType operation;
  String fieldName;
  String dataType;
  String targetValueInput;
  bool valid = false;

  Map<String, dynamic> toJson() => {
        'collection': collection,
        'operation': operation,
        'fieldName': fieldName,
        'dataType': dataType,
        'targetValueInput': targetValueInput,
      };

  void applyUpdate(StampUpdate settings) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    String targetValue = settings.targetValueInput;

    valid = true;
    db.collection(settings.collection).get().then(
          (res) => {
            res.docs.map(
              (snap) {
                // Map<String, dynamic> doc = snap.data();

                switch (settings.operation) {
                  case OperationType.update:
                    final data = {settings.fieldName: targetValue};
                    db.collection(collection).doc(snap.id).set(data, SetOptions(merge: true));

                    break;
                  case OperationType.delete:
                    break;
                  default:
                }
              },
            ),
          },
          onError: (e) => Console.log("ERROR: $e", scope: "exampleApp.SettingsFirestoreToolsForm.applyUpdate", level: LogLevel.prod),
        );
  }

  void validate() {}
}

class StampUpdater extends StatelessWidget {
  const StampUpdater({
    super.key,
  });

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
              Text(
                L10n.string(
                  'firestore_tools_stamp_updater',
                  placeholder: '==== The Firestore fucker-upper ====',
                  namespace: 'global',
                ),
                style: const TextStyle(
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
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 23, left: 8.0),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_collection_label',
                              placeholder: 'Collection',
                              namespace: 'global',
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: L10n.string(
                                'firestore_tools_stamper_collection_hint',
                                placeholder: 'enter the collection path you want to stamp-update',
                                namespace: 'global',
                              ),
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14, left: 8.0),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_operation_label',
                              placeholder: 'Operation',
                              namespace: 'global',
                            ),
                          ),
                        ),
                      ),
                      const TableCell(
                        child: OperationSelector(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 23, left: 8.0),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_fieldname_label',
                              placeholder: 'Field name',
                              namespace: 'global',
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: L10n.string(
                                'firestore_tools_stamper_fieldname_hint',
                                placeholder: 'enter the field do you want to stamp-update (or newly add)',
                                namespace: 'global',
                              ),
                              hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSecondary),
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
                          padding: const EdgeInsets.only(top: 23, left: 8.0),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_datatype_label',
                              placeholder: 'Data type',
                              namespace: 'global',
                            ),
                          ),
                        ),
                      ),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DataTypeSelector(),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24, left: 8.0),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_targetvalue_label',
                              placeholder: 'Target value',
                              namespace: 'global',
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: L10n.string(
                                'firestore_tools_stamper_targetvalue_hint',
                                placeholder: 'enter the value you want to stamp-update to all docs in collection',
                                namespace: 'global',
                              ),
                              hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSecondary),
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
                          child: Text(
                            "PROFILE",
                          ),
                        ),
                        onPressed: () {
                          FRouter.of(context).navigateToRoute(context, route: "profile");
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
                        icon: const Icon(Icons.list, size: 18),
                        label: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_firestore_button',
                              placeholder: 'Open collection in FS...',
                              namespace: 'global',
                            ),
                          ),
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
                        label: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            L10n.string(
                              'firestore_tools_stamper_apply_button',
                              placeholder: 'Apply values to collection',
                              namespace: 'global',
                            ),
                          ),
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

const List<String> types = <String>['string', 'number', 'boolean', 'timestamp', 'null'];

class DataTypeSelector extends StatefulWidget {
  const DataTypeSelector({super.key});

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

class OperationSelector extends StatefulWidget {
  const OperationSelector({super.key});

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

forAllInCollection(String collection) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db.collection(collection).get().then(
        (res) => {
          res.docs.map((snap) {
            Map<String, dynamic> doc = snap.data();
            Timestamp cdTS = doc['createdDate'];
            Timestamp edTS = Timestamp((cdTS.seconds + 7776000), 0);

            final data = {"expirationDate": edTS};
            db.collection(collection).doc(snap.id).set(data, SetOptions(merge: true));
          }),
        },
        onError: (e) => Console.log("ERROR: $e", scope: "exampleApp.SettingsFirestoreToolsForm.forAllInCollection", level: LogLevel.prod),
      );

  return true;
}

touchUpdateDate(String collection) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db.collection(collection).get().then(
        (res) => {
          res.docs.map((snap) {
            Timestamp updateStamp = Timestamp.now();

            final data = {"updatedDate": updateStamp};
            db.collection(collection).doc(snap.id).set(data, SetOptions(merge: true));
          }),
        },
        onError: (e) => Console.log("ERROR: $e", scope: "exampleApp.SettingsFirestoreToolsForm.touchUpdateDate", level: LogLevel.prod),
      );

  return true;
}
