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
  List<DocumentTab> documentTabs() {
    final List<DocumentTab<Suggestion>> _documentTabs = [
      DocumentTab<Suggestion>(
        documentTabBuilder: () {
          return const Tab(
            text: "Suggestion",
            icon: Icon(
              Icons.pest_control,
            ),
          );
        },
        documentTabChildBuilder: (
          suggestion,
        ) {
          return Tab01(
            suggestion: suggestion,
          );
        },
      ),
      DocumentTab<Suggestion>(
        documentTabBuilder: () {
          return const Tab(
            text: "Placeholder",
            icon: Icon(
              Icons.settings_overscan,
            ),
          );
        },
        documentTabChildBuilder: (suggestion) {
          return const Tab02();
        },
      ),
      DocumentTab<Suggestion>(
        documentTabBuilder: () {
          return const Tab(
            text: "Ok or Not?",
            icon: Icon(
              Icons.settings_overscan,
            ),
          );
        },
        documentTabChildBuilder: (suggestion) {
          return const Tab03();
        },
      ),
    ];
    return _documentTabs;
  }

  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Suggestion>(
      query: SuggestionService().queryStream(),
      documentStream: (String? documentId) => SuggestionService().documentStream(documentId: documentId),
      autoSave: false,
      titleBuilder: (Suggestion suggestion) {
        return Text(suggestion.name ?? "New Suggestion");
      },
      documentTabs: documentTabs(),
      // contextWidgets: contextWidgets,
      contextCardBuilders: [
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
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Suggestion suggestion) {
        //List Tile per suggestion
        return SuggestionListItem(
          suggestion: suggestion,
          selected: selected,
        );
      },
    );
  }
}
