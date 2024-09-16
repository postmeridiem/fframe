import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/models/fframe_list.dart';
import 'package:example/helpers/icons.dart';
import 'package:example/helpers/strings.dart';

class SettingsListsForm extends StatefulWidget {
  const SettingsListsForm({super.key});

  @override
  State<SettingsListsForm> createState() => _SettingsListsFormState();
}

class _SettingsListsFormState extends State<SettingsListsForm> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String currentListId = '';
  late FframeList curList;

  @override
  Widget build(BuildContext context) {
    Console.log("Opening SettingsListsForm", scope: "exampleApp.Settings");
    String path = 'fframe/lists/collection';
    CollectionReference col = FirebaseFirestore.instance.collection(path);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<QuerySnapshot>(
                future: col.orderBy('name', descending: false).get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(100.0),
                      child: Text(
                        "Something went wrong",
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    List<ListTile> listdata = [];
                    for (int i = 0; i < data.length; i++) {
                      DocumentSnapshot<Map<String, dynamic>> listSnap = data[i] as DocumentSnapshot<Map<String, dynamic>>;
                      FframeList currentList = FframeList.fromFirestore(listSnap, SnapshotOptions());
                      listdata.add(
                        ListTile(
                          title: Text(currentList.name as String),
                          leading: Icon(
                            iconMap[currentList.icon as String],
                            color: currentList.icon == 'block' ? Theme.of(context).disabledColor : null,
                          ),
                          onTap: () {
                            setState(() {
                              currentListId = currentList.id as String;
                              curList = currentList;
                            });
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text("Focus on: ${currentList.name}"),
                            //   ),
                            // );
                          },
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView(
                        children: listdata,
                      ),
                    );
                  }

                  return const Padding(padding: EdgeInsets.all(100.0), child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                currentListId != ''
                    ? CurrentListEditor(currentList: curList)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 32,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          Text(
                            "Select a list",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentListEditor extends StatefulWidget {
  const CurrentListEditor({
    super.key,
    required this.currentList,
  });

  final FframeList currentList;

  @override
  State<CurrentListEditor> createState() => _CurrentListEditorState();
}

class _CurrentListEditorState extends State<CurrentListEditor> {
  // nameController.
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController.text = widget.currentList.name as String;

    TextEditingController typeController = TextEditingController();
    typeController.text = widget.currentList.type as String;

    TextEditingController iconController = TextEditingController();
    iconController.text = widget.currentList.icon as String;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 150,
                child: Text("Id"),
              ),
              Expanded(
                child: Text("${widget.currentList.id}"),
              ),
              const SizedBox(
                width: 150,
                child: Text("created"),
              ),
              Expanded(
                child: TimestampDateTimeText(timestamp: widget.currentList.creationDate as Timestamp),
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 150,
              child: Text("Name"),
            ),
            Expanded(
              child: TextField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                onChanged: (String fieldValue) {},
                onSubmitted: (String fieldValue) {
                  setState(() {
                    // widget.currentList.name = fieldValue;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 150,
              child: Text("Type"),
            ),
            Expanded(
              child: TextField(
                controller: typeController,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                onChanged: (String fieldValue) {},
                onSubmitted: (String fieldValue) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 150,
              child: Text("Icon"),
            ),
            Expanded(
              child: TextField(
                controller: iconController,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                onChanged: (String fieldValue) {},
                onSubmitted: (String fieldValue) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 150,
                child: Text("Options"),
              ),
              Expanded(
                child: Card(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.currentList.options}"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              label: const Text('Firestore Document',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.list,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 32,
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.https(
                    "console.firebase.google.com",
                    "/project/fframe-dev/firestore/data/~2Ffframe~2Flists~2Fcollections~2F${widget.currentList.id}",
                  ),
                );
              },
            ),
            OutlinedButton.icon(
              label: const Text('Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.save,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 32,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
