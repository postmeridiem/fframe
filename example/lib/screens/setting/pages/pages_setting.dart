import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

// ignore: unnecessary_import
import 'package:url_launcher/url_launcher.dart';

import 'package:example/models/fframe_page.dart';
import 'package:example/helpers/icons.dart';
import 'package:example/helpers/strings.dart';

class SettingsPagesForm extends StatefulWidget {
  const SettingsPagesForm({super.key});

  @override
  State<SettingsPagesForm> createState() => _SettingsPagesFormState();
}

class _SettingsPagesFormState extends State<SettingsPagesForm> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String currentPageId = '';
  late FframePage curPage;

  @override
  Widget build(BuildContext context) {
    Console.log("Opening SettingsPagesForm", scope: "exampleApp.Settings");
    String path = 'fframe/pages/collection';
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
                      FframePage currentPage = FframePage.fromFirestore(listSnap, SnapshotOptions());
                      listdata.add(
                        ListTile(
                          title: Text(currentPage.name as String),
                          leading: Icon(
                            iconMap[currentPage.icon as String],
                            color: currentPage.icon == 'block' ? Theme.of(context).disabledColor : null,
                          ),
                          onTap: () {
                            setState(() {
                              currentPageId = currentPage.id as String;
                              curPage = currentPage;
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
                currentPageId != ''
                    ? CurrentPageEditor(currentPage: curPage)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 32,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          Text(
                            "Select a page",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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

class CurrentPageEditor extends StatefulWidget {
  const CurrentPageEditor({
    super.key,
    required this.currentPage,
  });

  final FframePage currentPage;

  @override
  State<CurrentPageEditor> createState() => _CurrentPageEditorState();
}

class _CurrentPageEditorState extends State<CurrentPageEditor> {
  // nameController.
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController.text = widget.currentPage.name as String;

    TextEditingController typeController = TextEditingController();
    typeController.text = widget.currentPage.body as String;

    TextEditingController iconController = TextEditingController();
    iconController.text = widget.currentPage.icon as String;

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
                child: Text("${widget.currentPage.id}"),
              ),
              const SizedBox(
                width: 150,
                child: Text("created"),
              ),
              Expanded(
                child: TimestampDateTimeText(timestamp: widget.currentPage.creationDate as Timestamp),
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
                    // widget.currentPage.name = fieldValue;
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
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 32,
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.https(
                    "console.firebase.google.com",
                    "/project/fframe-dev/firestore/data/~2Ffframe~2Fpages~2Fcollection~2F${widget.currentPage.id}",
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
                  color: Theme.of(context).colorScheme.onSurface,
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
