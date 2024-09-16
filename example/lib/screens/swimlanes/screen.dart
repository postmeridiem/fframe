import 'package:example/models/suggestion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import '../suggestion/screen.dart';
import 'swimlanes.dart';

enum SwimlanesQueryStates { active, inactive }

class SwimlanesScreen extends StatefulWidget {
  const SwimlanesScreen({
    super.key,
    required this.swimlanesQueryState,
  });
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
        getTitle: (suggestion) => suggestion.name ?? "?",
        getDescription: (suggestion) => suggestion.description ?? "",
        getPriority: (suggestion) => suggestion.priority,
        myId: (user) => user.uid!,
        following: SwimlanesFollowing<Suggestion>(
          isFollowing: (suggestion, user) =>
              suggestion.followers != null &&
              suggestion.followers!.contains(user.uid),
          startFollowing: (suggestion, user) {
            suggestion.followers ??= [];
            suggestion.followers!.add(user.uid!);
            return suggestion;
          },
          stopFollowing: (suggestion, user) {
            suggestion.followers ??= [];
            suggestion.followers!.remove(user.uid!);
            return suggestion;
          },
        ),
        assignee: SwimlanesAssignee<Suggestion>(
          unsetAssignee: (suggestion) {
            //TODO: User picker dialog
            suggestion.assignee = null;
            return suggestion;
          },
          setAssignee: (suggestion, user) {
            //TODO: User picker dialog
            suggestion.assignee = user.uid;
            return suggestion;
          },
          isAssignee: (suggestion, user) {
            return suggestion.assignee == user.uid;
          },
        ),
        // getDueDate: (suggestion) => suggestion.dueDate,
        taskWidgetHeader: (selectedDocument, swimlanesConfig, fFrameUser) =>
            SuggestionHeader(
          selectedDocument: selectedDocument,
          swimlanesConfig: swimlanesConfig,
          fFrameUser: fFrameUser,
        ),
        taskWidgetBody: (selectedDocument, swimlanesConfig, fFrameUser) =>
            SuggestionCard(
          selectedDocument: selectedDocument,
          swimlanesConfig: swimlanesConfig,
          fFrameUser: fFrameUser,
        ),
        // getAssignee: (Suggestion ) {  },
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: suggestionDocument(),
    );
  }
}

class SuggestionHeader extends StatelessWidget {
  SuggestionHeader({
    super.key,
    required this.selectedDocument,
    required this.swimlanesConfig,
    required this.fFrameUser,
  }) : suggestion = selectedDocument.data;
  final SelectedDocument<Suggestion> selectedDocument;
  final SwimlanesConfig<Suggestion> swimlanesConfig;
  final FFrameUser fFrameUser;
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Text(suggestion.name ?? "?");
  }
}

class SuggestionCard extends StatelessWidget {
  SuggestionCard({
    super.key,
    required this.selectedDocument,
    required this.swimlanesConfig,
    required this.fFrameUser,
  }) : suggestion = selectedDocument.data;
  final SelectedDocument<Suggestion> selectedDocument;
  final SwimlanesConfig<Suggestion> swimlanesConfig;
  final FFrameUser fFrameUser;
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return SelectableText("${suggestion.priority}");
  }
}
