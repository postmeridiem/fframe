import 'package:fframe/extensions/query.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/appuser.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    return DocumentScreen<AppUser>(
      // formKey: GlobalKey<FormState>(),
      collection: "users",
      fromFirestore: AppUser.fromFirestore,
      toFirestore: (user, options) => user.toFirestore(),
      createNew: () => AppUser(),
      // query: (Query<AppUser> query) {
      //   return query.orderBy("lastName");
      // },
      titleBuilder: (context, data) {
        return Text(
          data.displayName ?? "New User",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },
      // documentList: DocumentList<AppUser>(
      //   showCreateButton: false,
      //   seperatorHeight: 5,
      //   headerBuilder: (BuildContext headerBuildContext, int documentCount) {
      //     return Text("Header $documentCount docs");
      //   },
      //   builder: (BuildContext context,bool selected, data, FFrameUser? user) {
      //     return Text(data.displayName!);
      //   }
      // ),
      queryBuilder: (query) => query.orderBy("displayName").startsWith("displayName", "Arno"),
      document: _document(),
      dataGrid: DataGridConfig<AppUser>(
        // rowHeight: 300,
        rowsPerPage: 4,
        dataGridConfigColumns: [
          DataGridConfigColumn(
            headerBuilder: () => DataColumn(
                label: Text("Image ${isAscending ? "up" : "down"}"),
                tooltip: "Je moeder",
                onSort: (int columnIndex, bool ascending) {
                  setState(() {
                    isAscending = ascending;
                  });
                }),
            dataCellBuilder: (AppUser appUser, save) {
              return DataCell(SizedBox(
                width: 200,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.amberAccent,
                    child: Text("${appUser.displayName}",
                        style: const TextStyle(color: Colors.black)),
                  ),
                ),
              ));
            },
          )
        ],
      ),
    );
  }

  Document<AppUser> _document() {
    return Document<AppUser>(
      autoSave: false,
      documentTabsBuilder: (context, data, isReadOnly, isNew, fFrameUser) {
        return [];
      },
    );
  }
}
