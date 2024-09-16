// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/suggestion.dart';
import '../suggestion/screen.dart';
import 'list_grid.dart';

enum ListGridQueryStates { active, inactive }

class ListGridScreen<Suggestion> extends StatefulWidget {
  const ListGridScreen({
    super.key,
    required this.listgridQueryState,
  });
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
        rowsSelectable: true,
        actionBar: listgridActionMenu(),
        columnSettings: listGridColumns,
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: suggestionDocument(),
      // document: _document(),
    );
  }
}
