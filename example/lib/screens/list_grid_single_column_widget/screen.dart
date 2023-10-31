import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/suggestion.dart';
import 'list_grid_single_colum.dart';

enum ListGridQueryStates { active, inactive }

class ListGridScreen<Suggestion> extends StatefulWidget {
  const ListGridScreen({
    Key? key,
    required this.listgridQueryState,
  }) : super(key: key);
  final ListGridQueryStates listgridQueryState;

  @override
  State<ListGridScreen> createState() => _ListGridScreenState();
}

class _ListGridScreenState extends State<ListGridScreen> {
  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Suggestion>(
      //Indicate where the documents are located and how to convert them to and fromt their models.
      // formKey: GlobalKey<FormState>(),
      collection: "suggestions",
      fromFirestore: Suggestion.fromFirestore,
      toFirestore: (Suggestion suggestion, SetOptions? options) {
        return suggestion.toFirestore();
      },
      createDocumentId: (Suggestion suggestion) {
        return "${suggestion.name}";
      },

      preSave: (Suggestion suggestion) {
        //Here you can do presave stuff to the context document.
        suggestion.saveCount++;
        return suggestion;
      },

      createNew: () => Suggestion(
        active: true,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ??
            "unknown at ${DateTime.now().toLocal()}",
      ),

      //Optional title widget
      titleBuilder: (BuildContext context, Suggestion data) {
        return Text(
          data.name ?? "New Suggestion",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },

      query: (query) {
        // return query.where("active", isNull: true);
        switch (widget.listgridQueryState) {
          case ListGridQueryStates.active:
            return query.where("active", isEqualTo: true);

          case ListGridQueryStates.inactive:
            return query.where("active", isEqualTo: false);
        }
      },

      // Optional ListGrid widget
      viewType: ViewType.listgrid,
      listGrid: ListGridConfig<Suggestion>(
        searchHint: "search suggestion names",
        // widgetBackgroundColor: Colors.amber,
        // widgetColor: Colors.pink,
        // widgetTextColor: Colors.pink,
        // widgetTextSize: 20,
        // widgetAccentColor: Colors.cyan,
        // rowBorder: 1,
        // cellBorder: 1,
        // cellPadding: const EdgeInsets.all(16),
        // cellVerticalAlignment: TableCellVerticalAlignment.top,
        // cellBackgroundColor: Colors.amber,
        // // defaultTextStyle: const TextStyle(fontSize: 16, color: Colors.amber),
        // showHeader: false,
        // // showFooter: false,
        rowsSelectable: false,
        actionBar: listgridActionMenu<Suggestion>(),
        columnSettings: listGridColumns,
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: _document(context),
      // document: _document(),
    );
  }

  Document<Suggestion> _document(BuildContext context) {
    return Document<Suggestion>(
      scrollableHeader: false,
      showCloseButton: true,
      showEditToggleButton: true,
      showDeleteButton: true,
      showSaveButton: true,
      extraActionButtons: (context, suggestion, isReadOnly, isNew, user) {
        return [
          if (user != null &&
              user.roles != null &&
              user.roles!.contains("firestoreaccess"))
            IconButton(
              tooltip: "Open Firestore Document",
              onPressed: () {
                String domain = "https://console.cloud.google.com";
                String application = "firestore/databases/-default-/data/panel";
                String collection = "suggestions";
                String docId = suggestion.id ?? "";
                String gcpProject =
                    Fframe.of(context)!.firebaseOptions.projectId;
                Uri url = Uri.parse(
                    "$domain/$application/$collection/$docId?&project=$gcpProject");
                launchUrl(url);
              },
              icon: Icon(
                Icons.table_chart_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
        ];
      },
      documentTabsBuilder:
          (context, suggestion, isReadOnly, isNew, fFrameUser) {
        return [
          DocumentTab<Suggestion>(
            tabBuilder: (user) {
              return Tab(
                text: "${suggestion.name}",
                icon: const Icon(
                  Icons.pest_control,
                ),
              );
            },
            childBuilder: (suggestion, readOnly) {
              return DocTab(
                suggestion: suggestion,
                readOnly: readOnly,
                // user: user,
              );
            },
          ),
        ];
      },
    );
  }
}
