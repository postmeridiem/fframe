import 'dart:js' as js;

import 'package:fframe/models/runConfig.dart';
import 'package:fframe/services/runConfigService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

//Shows the selected runConfig in the right hand pane
class RunConfigDocument extends StatelessWidget {
  RunConfigDocument({required this.runConfig, required this.documentReference, Key? key}) : super(key: key);
  final DocumentReference documentReference;
  final RunConfig runConfig;
  final RunConfigService runConfigService = RunConfigService();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      "Run Configuration",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.teal[800]),
                    ),
                    // SwitchListTile(
                    //   title: Text("Active"),
                    //   value: runConfig.active!,
                    //   onChanged: (bool value) {
                    //     runConfig.active = value;
                    //     runConfigService.applyChanges(runConfig: runConfig, documentReference: documentReference);
                    //   },
                    // ),
                  ],
                ),
                Divider(),
//                Text("parent: ${runConfig.creationDate}"),
//                Text("parent: ${runConfig.updatedDate}"),
                Focus(
                  child: TextField(
                    readOnly: false,
                    controller: TextEditingController.fromValue(TextEditingValue(text: runConfig.name ?? '')),
                    onSubmitted: (String value) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      // runConfig.name = value;
                      runConfigService.applyChanges(runConfig: runConfig, documentReference: documentReference);
                    }
                  },
                ),
                Divider(),
                Row(children: [
                  // This is the main content.
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Currently Running Tasks",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal[800]),
                          ),
                          RunconfigRunTable(runconfigId: runConfig.id!),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  SizedBox(
                    width: 250,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.alarm_add_outlined, size: 18),
                                label: Text('Manage schedule...'),
                                onPressed: () {
                                  throwPopup(context, "schedule manager", "that ain't much yet, hoss...");
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.schedule_outlined, size: 18),
                                label: Text('Open schedule...'),
                                onPressed: () {
                                  js.context.callMethod('open', [
                                    'https://console.cloud.google.com/cloudscheduler/jobs/edit/europe-west3/${runConfig.clientId}-${runConfig.id}?project=fframe'
                                  ]);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.storage_outlined, size: 18),
                                label: Text('Open bucket...'),
                                onPressed: () {
                                  js.context.callMethod('open', ['https://console.cloud.google.com/storage/browser/data-' + runConfig.id!.toLowerCase()]);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.more_outlined, size: 18),
                                label: Text('Do more things...'),
                                onPressed: () {
                                  throwPopup(context, "more things manager", "what did you expect?!?");
                                },
                              ),
                            ),
                          ],
                          //bvbbqkhch49rdbxfohnu-mrqkd0x2jkxfal6ts9bm?project=fframe
                        )),
                  ),
                ]),
              ],
            )),
      ),
    ]);
  }
}
// // A collection of {'name': string, 'age': number}
// final usersCollection = FirebaseFirestore.instance.collection('users');

class RunconfigRunTable extends StatefulWidget {
  RunconfigRunTable({Key? key, required this.runconfigId}) : super(key: key);
  final String runconfigId;
  @override
  State<RunconfigRunTable> createState() => _RunconfigRunTableState(runconfigId);
}

class _RunconfigRunTableState extends State<RunconfigRunTable> {
  _RunconfigRunTableState(this.runconfigId);
  final String runconfigId;

  @override
  void initState() {
    //for future use, you'll know when.....
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var runsCollection = FirebaseFirestore.instance
        .collection('runs')
//        .orderBy('createdDate', descending: false)
        .where('runconfigId', isEqualTo: runconfigId)
        .where('active', isEqualTo: true);
    return SingleChildScrollView(
      child: Scrollbar(
        child: FirestoreDataTable(
          rowsPerPage: 3,
          showCheckboxColumn: false,
          showFirstLastButtons: true,
          sortColumnIndex: 1,
          sortAscending: true,
          query: runsCollection,
          columnLabels: {
            'runId': Text('Run'),
            'createdDate': Text('Created'),
            'stepCurrent': Text('Current Step'),
          },
        ),
      ),
    );
  }
}

Future<void> throwPopup(context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('I do!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
