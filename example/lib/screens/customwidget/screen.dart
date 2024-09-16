import 'package:example/screens/suggestion/suggestion.dart';
import 'package:fframe/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:example/models/suggestion.dart';

enum SuggestionQueryStates { active, done }

class SuggestionScreen<Suggestion> extends StatefulWidget {
  const SuggestionScreen({
    super.key,
    required this.suggestionQueryState,
  });
  final SuggestionQueryStates suggestionQueryState;

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

      preSave: (Suggestion suggestion) {
        //Here you can do presave stuff to the context document.
        suggestion.saveCount++;
        return suggestion;
      },

      preOpen: (Suggestion suggestion) {
        //Here you can do pre open stuff to the context document.
        return suggestion;
      },

      viewType: ViewType.custom,

      createNew: () => Suggestion(
        active: true,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ??
            "unknown at ${DateTime.now().toLocal()}",
      ),

      //Required title widget
      titleBuilder: (BuildContext context, Suggestion data) {
        return Text(
          data.name ?? "New Suggestion",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },

      query: (query) {
        // return query.where("active", isNull: true);
        switch (widget.suggestionQueryState) {
          case SuggestionQueryStates.active:
            return query.where("active", isEqualTo: true);

          case SuggestionQueryStates.done:
            return query.where("active", isEqualTo: false);
        }
      },

      customList: CustomList(
        contentPadding: const EdgeInsets.only(top: 80.0),
        builder: (context, query, documentConfig, user) {
          query = query.limit(1);
          return ContentSelector(
              context: context,
              query: query,
              documentConfig: documentConfig,
              user: user);
        },
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: suggestionDocument(),
    );
  }
}

class ContentSelector<Suggestion> extends StatefulWidget {
  const ContentSelector({
    super.key,
    required this.context,
    required this.query,
    required this.documentConfig,
    this.user,
  });
  final BuildContext context;
  final Query<Suggestion> query;
  final DocumentConfig<Suggestion> documentConfig;
  final FFrameUser? user;
  @override
  State<ContentSelector> createState() => _ContentSelectorState<Suggestion>();
}

class _ContentSelectorState<Suggestion>
    extends State<ContentSelector<Suggestion>> {
  SelectedDocument<Suggestion>? selectedDocument;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => postFrameCallback);
  }

  postFrameCallback() {
    selectedDocument?.open();
  }

  @override
  Widget build(BuildContext context) {
    DocumentConfig<Suggestion> documentConfig = widget.documentConfig;
    Query<Suggestion> query = widget.query;

    return Column(
      children: [
        FutureBuilder<int>(
          future: DatabaseService<Suggestion>().selecteDocumentCount(
            query: query,
            documentConfig: documentConfig,
          ),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) return Text("${snapshot.data}");
            return const SizedBox(
              width: 8,
              height: 8,
              child: CircularProgressIndicator(),
            );
          },
        ),
        StreamBuilder(
          stream: DatabaseService<Suggestion>().selectedDocumentStream(
            query: query.limit(1),
            documentConfig: documentConfig,
          ),
          builder: (BuildContext context,
              AsyncSnapshot<List<SelectedDocument<Suggestion>>>
                  selectedDocumentsSnaphot) {
            if (!selectedDocumentsSnaphot.hasData)
              return const CircularProgressIndicator();
            this.selectedDocument = selectedDocumentsSnaphot.data!.first;

            return IconButton(
                onPressed: () {
                  this.selectedDocument?.select();
                },
                icon: const Icon(Icons.open_in_new));
          },
        ),
      ],
    );
  }
}
