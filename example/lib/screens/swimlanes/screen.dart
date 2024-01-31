import 'package:example/models/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import '../suggestion/screen.dart';
import 'swimlanes.dart';

enum SwimlanesQueryStates { active, inactive }

class SwimlanesScreen extends StatefulWidget {
  const SwimlanesScreen({
    Key? key,
    required this.swimlanesQueryState,
  }) : super(key: key);
  final SwimlanesQueryStates swimlanesQueryState;

  @override
  State<SwimlanesScreen> createState() => _SwimlanesScreenState();
}

class _SwimlanesScreenState extends State<SwimlanesScreen> {
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

      createNew: () => Suggestion(
        active: true,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ?? "unknown at ${DateTime.now().toLocal()}",
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
      //   // return query.where("active", isNull: true);
      //   // switch (widget.swimlanesQueryState) {
      //   //   case SwimlanesQueryStates.active:
      //   //     return query.where("active", isEqualTo: true);

      //   //   case SwimlanesQueryStates.inactive:
      //   //     return query.where("active", isEqualTo: false);
      //   // }
      // },

      // Optional Swimlanes widget
      viewType: ViewType.swimlanes,
      swimlanes: SwimlanesConfig<Suggestion>(
        trackerId: "trackerId",
        swimlaneSettings: swimlanesSettings,
        getStatus: (suggestion) => suggestion.status ?? "",
        getName: (suggestion) => suggestion.name ?? "?",
        // getId: (suggestion) => suggestion.id ?? "?",
        // getLinkedId: (suggestion) => suggestion.linkedDocumentId ?? "",
        // getLinkedPath: (suggestion) => suggestion.linkedPath ?? "",
        // getAssignee: (suggestion) => suggestion.assignee ?? "",
        getDescription: (suggestion) => suggestion.description ?? "",
        getPriority: (suggestion) => suggestion.priority,
        // getFollowers: (suggestion) => suggestion.followers ?? [],
        // getPriority: (suggestion) => suggestion.priority,
        taskWidget: (selectedDocument, swimlanesConfig, fFrameUser) => SuggestionCard(
          selectedDocument: selectedDocument,
          swimlanesConfig: swimlanesConfig,
          fFrameUser: fFrameUser,
        ),
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: suggestionDocument(context),
    );
  }
}

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    Key? key,
    required this.selectedDocument,
    required this.swimlanesConfig,
    required this.fFrameUser,
  }) : super(key: key);
  final SelectedDocument<Suggestion> selectedDocument;
  final SwimlanesConfig<Suggestion> swimlanesConfig;
  final FFrameUser fFrameUser;

  @override
  Widget build(BuildContext context) {
    Suggestion suggestion = selectedDocument.data as Suggestion;
    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Placeholder(
          child: Center(
            child: Column(
              children: [
                SelectableText("${selectedDocument.id}"),
                Text("${suggestion.priority}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
