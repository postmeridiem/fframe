import 'package:fframe/helpers/console_logger.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';
import 'swimlanes.dart';

enum SwimlaneQueryStates { active, inactive }

class SwimlaneScreen<Suggestion> extends StatefulWidget {
  const SwimlaneScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SwimlaneScreen> createState() => _SwimlaneScreenState();
}

class _SwimlaneScreenState extends State<SwimlaneScreen> {
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

      // Optional Swimlane widget
      viewType: ViewType.swimlanes,

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
