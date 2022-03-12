import 'package:fframe/models/suggestion.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/suggestionService.dart';
import 'package:fframe/views/suggestion/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild suggestionScreen ");
    return DocumentScreen<Suggestion>(
      query: SuggestionService().queryStream(),
      documentStream: (String? documentId) => SuggestionService().documentStream(documentId: documentId),
      autoSave: false,
      //Left hand (navigation/document selection pane)
      documentListBuilder: (context, bool selected, Suggestion suggestion) {
        //List Tile per suggestion
        return suggestionList(
          suggestion: suggestion,
          selected: selected,
        );
      },
      //Right hand (document) pane
      documentBuilder: (context, DocumentReference<Suggestion>? documentReference, Suggestion suggestion) {
        // var roles = ['', ''];

        // roles.contains("suggestionEditor")

        return SuggestionDocument(
          documentReference: documentReference!,
          suggestion: suggestion,
          // allowEdit: roles.contains("suggestionEditor"),
        );
      },
    );
  }
}
