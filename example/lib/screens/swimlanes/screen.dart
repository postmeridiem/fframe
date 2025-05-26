import 'package:example/models/suggestion.dart';
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
  // Filter toggle showcasing a custom option
  Widget customFilterWidget(SwimlanesController swimlanesController) {
    SwimlanesFilterType currentFilter = swimlanesController.notifier.filter;
    SwimlanesFilterType targetFilter = SwimlanesFilterType.customFilter;
    return ElevatedButton.icon(
      onPressed: () {
        if (swimlanesController.filter != targetFilter) {
          swimlanesController.notifier.setFilter(targetFilter);
        } else {
          swimlanesController.notifier.setFilter(SwimlanesFilterType.unfiltered);
        }
      },
      icon: const Icon(
        Icons.auto_fix_normal_outlined,
        color: Colors.white,
      ),
      label: const Text(
        'Dolly filter',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: (currentFilter == targetFilter) ? Theme.of(context).indicatorColor : Theme.of(context).disabledColor,
      ),
    );
  }

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

      documentTitle: (BuildContext context, Suggestion data) {
        return data.name ?? "New Suggestion";
      },

      //Optional title widget
      headerBuilder: (BuildContext context, String documentTitle, Suggestion data) {
        return Text(
          documentTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
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
          isFollowing: (suggestion, user) => suggestion.followers != null && suggestion.followers!.contains(user.uid),
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
        customFilter: SwimlanesCustomFilter<Suggestion>(
          filterName: 'Card name',
          matchesCustomFilter: (suggestion) {
            // In this example the custom filter is to be named "dolly the sheep"
            String dummyFilterSelection = 'dolly the sheep';
            return suggestion.name == dummyFilterSelection;
          },
          customFilterWidget: customFilterWidget,
        ),
        // getDueDate: (suggestion) => suggestion.dueDate,
        taskWidgetHeader: (selectedDocument, swimlanesConfig, fFrameUser) => SuggestionHeader(
          selectedDocument: selectedDocument,
          swimlanesConfig: swimlanesConfig,
          fFrameUser: fFrameUser,
        ),
        taskWidgetBody: (selectedDocument, swimlanesConfig, fFrameUser) => SuggestionCard(
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
