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
    SwimlanesFilterType targetFilter = SwimlanesFilterType.customFilter;
    SwimlanesFilterType currentFilter = swimlanesController.notifier.filter;
    // Dummy labels with the same functionality - to toggle the filter type on
    List<String> dummyLabels = ['label1', 'label2', 'label3'];
    return PopupMenuButton<String>(
      tooltip: "Filter by labels",
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            enabled: false, // Allow interaction with children without closing
            child: SizedBox(
              width: 100,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateInsidePopup) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dummyLabels.map((labelName) {
                      return CheckboxListTile(
                        title: Text(labelName),
                        value: swimlanesController.filter == targetFilter,
                        onChanged: (value) {
                          if (swimlanesController.filter != targetFilter) {
                            swimlanesController.notifier.setFilter(targetFilter);
                          } else {
                            swimlanesController.notifier.setFilter(SwimlanesFilterType.unfiltered);
                          }
                          setStateInsidePopup(() {});
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ];
      },
      child: Card(
        child: Container(
          height: swimlanesController.headerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: currentFilter == SwimlanesFilterType.customFilter ? Theme.of(context).colorScheme.onSecondary : null,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.filter_list_alt,
                color: Colors.white,
              ),
              Text(
                'Labels',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
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
        // getLanePosition: (suggestion) => suggestion.priority.toDouble(), // Dummy implementation as a suggestion doesn't have lanePosition
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
          // Only shown if myId is undefined, so if the default client-side filters are not shown.
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
