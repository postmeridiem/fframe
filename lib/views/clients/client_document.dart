import 'package:flutter/material.dart';
import 'package:fframe/models/client.dart';
import 'package:fframe/services/clientService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';

//Shows the selected client in the right hand pane
class clientDocument extends StatelessWidget {
  clientDocument({required this.client, required this.documentReference, Key? key}) : super(key: key);
  final DocumentReference documentReference;
  final Client client;
  final ClientService clientService = ClientService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      "Client",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SwitchListTile(
                      title: Text("Active"),
                      value: client.active!,
                      onChanged: (bool value) {
                        client.active = value;
                        clientService.applyChanges(client: client, documentReference: documentReference);
                      },
                    ),
                  ],
                ),
                Divider(),
//                Text("parent: ${client.creationDate}"),
//                Text("parent: ${client.updatedDate}"),
                Focus(
                  child: TextField(
                    readOnly: false,
                    controller: TextEditingController.fromValue(TextEditingValue(text: client.name ?? '')),
                    onSubmitted: (String value) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      // client.name = value;
                      clientService.applyChanges(client: client, documentReference: documentReference);
                    }
                  },
                ),
                Divider(),
                Text(
                  "Currently Running Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ClientRunTable(clientId: client.id!),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ClientRunTable extends StatefulWidget {
  ClientRunTable({Key? key, required this.clientId}) : super(key: key);
  final String clientId;
  @override
  State<ClientRunTable> createState() => _ClientRunTableState(clientId);
}

class _ClientRunTableState extends State<ClientRunTable> {
  _ClientRunTableState(this.clientId);
  final String clientId;

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
        .where('clientId', isEqualTo: clientId)
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
