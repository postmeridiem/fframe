import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'swimlanes.dart';

enum SwimlanesQueryStates { active, inactive }

class SwimlanesScreen<SwimlanesTask> extends StatefulWidget {
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
    String trackerId = 'development-tracker';
    return DocumentScreen<SwimlanesTask>(
      //Indicate where the documents are located and how to convert them to and fromt their models.
      // formKey: GlobalKey<FormState>(),
      collection: "fframe/tasks/trackers/$trackerId/tasks",
      fromFirestore: SwimlanesTask.fromFirestore,
      toFirestore: (SwimlanesTask swimlaneTask, SetOptions? options) {
        return swimlaneTask.toFirestore();
      },
      createDocumentId: (SwimlanesTask swimlaneTask) {
        return "${swimlaneTask.name}";
      },

      preSave: (SwimlanesTask swimlaneTask) {
        //Here you can do presave stuff to the context document.
        swimlaneTask.saveCount++;
        return swimlaneTask;
      },

      createNew: () => SwimlanesTask(
        active: true,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ??
            "unknown at ${DateTime.now().toLocal()}",
      ),

      //Optional title widget
      titleBuilder: (BuildContext context, SwimlanesTask data) {
        return Text(
          data.name ?? "New SwimlanesTask",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },

      query: (query) {
        // return query.where("active", isNull: true);
        switch (widget.swimlanesQueryState) {
          case SwimlanesQueryStates.active:
            return query.where("active", isEqualTo: true);

          case SwimlanesQueryStates.inactive:
            return query.where("active", isEqualTo: false);
        }
      },

      // Optional Swimlanes widget
      viewType: ViewType.swimlanes,
      swimlanes: SwimlanesConfig<SwimlanesTask>(
        trackerId: trackerId,
        swimlaneSettings: swimlanesSettings,
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: _document(context),
      // document: _document(),
    );
  }

  Document<SwimlanesTask> _document(BuildContext context) {
    return Document<SwimlanesTask>(
      scrollableHeader: false,
      showCloseButton: true,
      showCopyButton: true,
      showEditToggleButton: true,
      showCreateButton: true,
      showDeleteButton: true,
      showSaveButton: true,
      showValidateButton: true,
      extraActionButtons: (context, swimlaneTask, isReadOnly, isNew, user) {
        return [
          if (swimlaneTask.active == false)
            TextButton.icon(
              onPressed: () {
                swimlaneTask.active = true;
                DocumentScreenConfig.of(context)!.save<SwimlanesTask>(
                    context: context, closeAfterSave: false);
              },
              icon: const Icon(Icons.check, color: Colors.redAccent),
              label: const Text("Mark as Active"),
            ),
          if (swimlaneTask.active == true)
            TextButton.icon(
              onPressed: () {
                swimlaneTask.active = false;
                DocumentScreenConfig.of(context)!.save<SwimlanesTask>(
                    context: context, closeAfterSave: false);
              },
              icon: const Icon(Icons.close, color: Colors.greenAccent),
              label: const Text("Mark as Done"),
            ),
        ];
      },
      documentTabsBuilder:
          (context, swimlaneTask, isReadOnly, isNew, fFrameUser) {
        return [
          DocumentTab<SwimlanesTask>(
            tabBuilder: (user) {
              return Tab(
                text: "${swimlaneTask.name}",
                icon: const Icon(
                  Icons.pest_control,
                ),
              );
            },
            childBuilder: (swimlaneTask, readOnly) {
              return DocTab(
                swimlanesTask: swimlaneTask,
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
