import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/suggestion.dart';
import 'list_grid.dart';

enum ListGridQueryStates { active, done }

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
      toFirestore: (suggestion, options) {
        return suggestion.toFirestore();
      },
      createDocumentId: (suggestion) {
        return "${suggestion.name}";
      },

      preSave: (Suggestion suggestion) {
        //Here you can do presave stuff to the context document.
        suggestion.saveCount++;
        return suggestion;
      },

      viewType: widget.listgridQueryState == ListGridQueryStates.active
          ? ViewType.auto
          : ViewType.grid,

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

      // query: (query) {
      //   return query;
      //   // switch (widget.listgridQueryState) {
      //   //   case ListGridQueryStates.active:
      //   //     return query
      //   //         .where("active", isEqualTo: true)
      //   //         .orderBy("__name__", descending: true)
      //   //         .limit(5);

      //   //   case ListGridQueryStates.done:
      //   //     return query
      //   //         .where("active", isEqualTo: false)
      //   //         .orderBy("__name__", descending: true)
      //   //         .limit(5);
      //   // }
      // },

      // Optional ListGrid widget
      listGrid: ListGridConfig<Suggestion>(
        // widgetBackgroundColor: Theme.of(context).colorScheme.primary,
        // widgetTextStyle:
        //     TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        // widgetColor: Colors.cyan,
        rowBorder: 1,
        cellBorder: 1,
        // cellPadding: const EdgeInsets.all(16),
        // cellVerticalAlignment: TableCellVerticalAlignment.top,
        // cellBackgroundColor: Colors.amber,
        // defaultTextStyle: const TextStyle(fontSize: 16, color: Colors.amber),
        showHeader: true,
        showFooter: true,
        dataMode: const ListGridDataModeConfig(
          mode: ListGridDatarMode.lazy,
          limit: 20,
        ),

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
      showCopyButton: true,
      showEditToggleButton: true,
      showCreateButton: true,
      showDeleteButton: true,
      showSaveButton: true,
      showValidateButton: true,
      extraActionButtons: (context, suggestion, isReadOnly, isNew, user) {
        return [
          if (suggestion.active == false)
            TextButton.icon(
              onPressed: () {
                suggestion.active = true;
                DocumentScreenConfig.of(context)!
                    .save<Suggestion>(context: context, closeAfterSave: false);
              },
              icon: const Icon(Icons.check, color: Colors.redAccent),
              label: const Text("Mark as Active"),
            ),
          if (suggestion.active == true)
            TextButton.icon(
              onPressed: () {
                suggestion.active = false;
                DocumentScreenConfig.of(context)!
                    .save<Suggestion>(context: context, closeAfterSave: false);
              },
              icon: const Icon(Icons.close, color: Colors.greenAccent),
              label: const Text("Mark as Done"),
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
