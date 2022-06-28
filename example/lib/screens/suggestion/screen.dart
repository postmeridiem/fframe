import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

// import 'package:example/services/suggestion_service.dart';
import 'package:example/models/suggestion.dart';
import 'suggestion.dart';

class SuggestionScreen<Suggestion> extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
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

      createNew: () => Suggestion(
        createdBy: FirebaseAuth.instance.currentUser?.displayName ?? "unknown at ${DateTime.now().toLocal()}",
      ),

      //Optional title widget
      titleBuilder: (BuildContext context, Suggestion data) {
        return Text(
          data.name ?? "New Suggestion",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },

      // Optional, override on the query string param which holds the document id
      // queryStringIdParam: "docId",

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        builder: (context, selected, data, user) {
          return SuggestionListItem(
            suggestion: data,
            selected: selected,
            user: user,
          );
        },
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: _document(),
      // document: _document(),
    );
  }

  Document<Suggestion> _document() {
    return Document<Suggestion>(
      tabs: [
        DocumentTab<Suggestion>(
          tabBuilder: (user) {
            return const Tab(
              text: "Suggestion",
              icon: Icon(
                Icons.pest_control,
              ),
            );
          },
          childBuilder: (suggestion, readOnly) {
            return Tab01(
              suggestion: suggestion,
              readOnly: readOnly,
              // user: user,
            );
          },
        ),
        DocumentTab<Suggestion>(
          tabBuilder: (user) {
            return const Tab(
              text: "Placeholder",
              icon: Icon(
                Icons.settings_overscan,
              ),
            );
          },
          childBuilder: (suggestion, readOnly) {
            return Tab02(
              suggestion: suggestion,
              readOnly: readOnly,
            );
          },
        ),
        DocumentTab<Suggestion>(
          tabBuilder: (user) {
            return const Tab(
              text: "Ok or Not?",
              icon: Icon(
                Icons.settings_overscan,
              ),
            );
          },
          childBuilder: (suggestion, readOnly) {
            return Tab03(
              suggestion: suggestion,
              readOnly: readOnly,
            );
          },
        ),
        // DocumentTab<Suggestion>(tabBuilder: () {
        //   return const Tab(
        //     text: "FormCeption?",
        //     icon: Icon(
        //       Icons.settings_overscan,
        //     ),
        //   );
        // }, childBuilder: (suggestion, readOnly) {
        //   return const FormCeptionWidget();
        // },),
      ],
      contextCards: [
        (suggestion) => ContextCard(
              suggestion: suggestion,
            ),
      ],
    );
  }
}

class FormCeptionWidget extends StatelessWidget {
  const FormCeptionWidget({
    Key? key,
  }) : super(key: key);

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
      createNew: () => Suggestion(),

      //Optional title widget
      titleBuilder: (BuildContext context, Suggestion data) {
        return Text(
          data.name ?? "New Suggestion",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },

      // Optional, override on the query string param which holds the document id
      // queryStringIdParam: "formception",

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        builder: (context, selected, data, user) {
          return SuggestionListItem(
            suggestion: data,
            selected: selected,
            user: user,
          );
        },
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: Document<Suggestion>(
        autoSave: false,
        tabs: [
          DocumentTab<Suggestion>(tabBuilder: (user) {
            return const Tab(
              text: "Suggestion",
              icon: Icon(
                Icons.pest_control,
              ),
            );
          }, childBuilder: (suggestion, readOnly) {
            return const Text("FormCeption");
          })
        ],
      ),
    );
  }
}
