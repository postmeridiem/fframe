import 'package:fframe_demo/models/suggestion.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe_demo/services/suggestion_service.dart';
import 'package:fframe_demo/views/suggestion/first_tab.dart';
import 'package:fframe_demo/views/suggestion/second_tab.dart';
import 'package:fframe_demo/views/suggestion/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fframe_demo/views/suggestion/third_tab.dart';
import 'package:flutter/material.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final List<DocumentTab> documentTabs = [
    DocumentTab(
      tab: const Tab(
        text: "A Long List",
        icon: Icon(
          Icons.view_list,
        ),
      ),
      child: const FirstTab(),
    ),
    DocumentTab(
      tab: const Tab(
        text: "Placeholder",
        icon: Icon(
          Icons.settings_overscan,
        ),
      ),
      child: const SecondTab(),
    ),
    DocumentTab(
      tab: const Tab(
        text: "Ok or Not?",
        icon: Icon(
          Icons.flaky,
        ),
      ),
      child: const ThirdTab(),
    ),
  ];

  final List<Widget> contextWidgets = const [
    ContextWidgetCard(title: "title 1 number"),
    ContextWidgetCard(title: "second"),
    ContextWidgetCard(title: "1 a 2 b 3 c 4 d"),
  ];

  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Suggestion>(
      query: SuggestionService().queryStream(),
      documentStream: (String? documentId) => SuggestionService().documentStream(documentId: documentId),
      autoSave: false,

      documentTabs: documentTabs,
      contextWidgets: contextWidgets,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Suggestion suggestion) {
        //List Tile per suggestion
        return SuggestionListItem(
          suggestion: suggestion,
          selected: selected,
        );
      },
      titleBuilder: (Suggestion suggestion) {
        return Text(suggestion.name ?? "New Suggestion");
      },
      documentBuilder: (
        BuildContext context,
        DocumentReference<Suggestion> documentReference,
        Suggestion suggestion,
      ) {
        print("return SuggestionDocument");
        return SuggestionDocument(
          documentReference: documentReference,
          suggestion: suggestion,
        );
      },
    );
  }
}
