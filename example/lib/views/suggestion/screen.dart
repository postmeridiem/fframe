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
    return InheritedDocument(
      documentConfig: DocumentConfig(
        //Indicate where the documents are located and how to convert them to and fromt their models.
        collection: "suggestions",
        fromFirestore: Suggestion.fromFirestore,
        toFirestore: (suggestion, options) {
          return suggestion!.toFirestore();
        },
        createDocumentId: (suggestion) {
          return "${suggestion.name}";
        },

        createNew: () => Suggestion(
            // name: "fietsbel",
            ),
        //Optional title widget
        titleBuilder: (context, data) {
          return Text(
            data.name ?? "New Suggestion",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          );
        },

        // Optional, override on the query string param which holds the document id
        queryStringIdParam: "fsadjfhjsad",

        // Optional Left hand (navigation/document selection pane)
        documentList: DocumentList(
          builder: (context, selected, data) {
            return SuggestionListItem(
              suggestion: data,
              selected: selected,
            );
          },
        ),

        // Center part, shows a fireatore doc. Tabs possible
        document: _document(),
      ),
      child: const DocumentScreen(),
    );
  }

  Document<Suggestion> _document() {
    return Document<Suggestion>(
      autoSave: false,
      tabs: [
        DocumentTab<Suggestion>(
          tabBuilder: () {
            return const Tab(
              text: "Suggestion",
              icon: Icon(
                Icons.pest_control,
              ),
            );
          },
          childBuilder: (suggestion) {
            return Tab01(
              suggestion: suggestion,
              // user: user,
            );
          },
        ),
        DocumentTab<Suggestion>(
          tabBuilder: () {
            return const Tab(
              text: "Placeholder",
              icon: Icon(
                Icons.settings_overscan,
              ),
            );
          },
          childBuilder: (suggestion) {
            return Tab02(
              suggestion: suggestion,
            );
          },
        ),
        DocumentTab<Suggestion>(
          tabBuilder: () {
            return const Tab(
              text: "Ok or Not?",
              icon: Icon(
                Icons.settings_overscan,
              ),
            );
          },
          childBuilder: (suggestion) {
            return Tab03(
              suggestion: suggestion,
            );
          },
        ),
      ],
      contextCards: [
        (suggestion) => ContextCard(
              suggestion: suggestion,
            ),
        (suggestion) => ContextCard(
              suggestion: suggestion,
            ),
        (suggestion) => ContextCard(
              suggestion: suggestion,
            ),
      ],
    );
  }
}
