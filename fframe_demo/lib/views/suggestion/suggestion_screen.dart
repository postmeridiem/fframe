import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe_demo/services/suggestion_service.dart';
import 'package:fframe_demo/models/suggestion.dart';
import 'suggestion.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Suggestion>(
      //Optional title widget
      titleBuilder: (context, data) {
        return Text(data.name ?? "New Suggestion");
      },

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        builder: (context, selected, data) {
          return SuggestionListItem(
            suggestion: data,
            selected: selected,
          );
        },
        query: SuggestionService().queryStream(),
      ),

      // Center part, shows a fireatore doc. Tabs possible
      document: _document(),
    );
  }

  Document _document() {
    return Document(
      documentStream: (String? documentId) => SuggestionService().documentStream(documentId: documentId),
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
          childBuilder: (
            suggestion,
          ) {
            return Tab01(
              suggestion: suggestion,
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
            return const Tab02();
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
            return const Tab03();
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
