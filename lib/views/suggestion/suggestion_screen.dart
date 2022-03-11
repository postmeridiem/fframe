import 'package:fframe/models/suggestion.dart';
import 'package:fframe/screens/documentscreen.dart';
import 'package:fframe/services/suggestionService.dart';
import 'package:fframe/views/suggestion/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class suggestionScreen extends StatefulWidget {
  const suggestionScreen({Key? key}) : super(key: key);

  @override
  State<suggestionScreen> createState() => _suggestionScreenState();
}

class _suggestionScreenState extends State<suggestionScreen> {
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

        return suggestionDocument(
          documentReference: documentReference!,
          suggestion: suggestion,
          // allowEdit: roles.contains("suggestionEditor"),
        );
      },
    );
  }
}
