import 'package:fframe/controllers/navigationStateController.dart';
import 'package:fframe/providers/globalProviders.dart';
import 'package:fframe/screens/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:go_router/go_router.dart';

class DocumentScreen<T> extends StatefulWidget {
  const DocumentScreen({
    Key? key,
    required this.query,
    required this.documentStream,
    required this.documentListBuilder,
    required this.documentBuilder,
    this.autoSave = true,
  }) : super(key: key);
  final Query<T> query;
  final DocumentStream documentStream;
  final DocumentListBuilder<T> documentListBuilder;
  final DocumentBuilder<T> documentBuilder;
  final bool autoSave;

  @override
  State<DocumentScreen<T>> createState() => _DocumentScreenState<T>();
}

class _DocumentScreenState<T> extends State<DocumentScreen<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: _DocumentList<T>(
              query: widget.query,
              documentListBuilder: widget.documentListBuilder,
            ),
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: _DocumentBody(
                documentBuilder: widget.documentBuilder,
                documentStream: widget.documentStream,
                autoSave: widget.autoSave,
              )),
        ),
      ],
    );
  }
}

class _DocumentBody<T> extends ConsumerWidget {
  const _DocumentBody({
    Key? key,
    required this.documentBuilder,
    required this.documentStream,
    required this.autoSave,
  }) : super(key: key);
  final DocumentBuilder<T> documentBuilder;
  final DocumentStream? documentStream;
  final bool autoSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NavigationStateNotifier navigationState = ref.watch(navigationStateProvider);

    DocumentSnapshot<T>? documentSnapshot = navigationState.selectionState.queryDocumentSnapshot as DocumentSnapshot<T>?;
    Map<String, String>? queryParams = navigationState.selectionState.queryParams;
    if (documentSnapshot != null && queryParams != null && documentStream != null) {
      Stream<DocumentSnapshot<T>> _documentStream = documentStream!(documentSnapshot.id) as Stream<DocumentSnapshot<T>>;

      return StreamBuilder<DocumentSnapshot<T>>(
        initialData: documentSnapshot,
        stream: _documentStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot<T>> asyncSnapshot) {
          print("Async builder ${asyncSnapshot.connectionState.toString()}");
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.none:
              return EmptyScreen();
            case ConnectionState.waiting:
              return WaitScreen();
            case ConnectionState.active:
            case ConnectionState.done:
              if (asyncSnapshot.hasError) return ErrorScreen(error: Exception(asyncSnapshot.error));
              if (!asyncSnapshot.hasData) return WaitScreen();
              return Scaffold(
                body: this.documentBuilder(context, asyncSnapshot.data!.reference, asyncSnapshot.data!.data()!),
                // bottomNavigationBar: Row(
                //   children: [
                //     IconButton(onPressed: () {}, icon: Icon(Icons.save)),
                //   ],
                // ),
              );
          }
        },
      );
    } else if (documentSnapshot == null && queryParams != null) {
      return WaitScreen();
    }
    return EmptyScreen();
  }
}

class _DocumentList<T> extends StatelessWidget {
  const _DocumentList({
    Key? key,
    required this.query,
    required this.documentListBuilder,
    // required this.notifier,
  }) : super(key: key);
  final Query<T> query;
  final DocumentListBuilder<T> documentListBuilder;
  // final ValueNotifier<QueryDocumentSnapshot<T>?> notifier;

  @override
  Widget build(BuildContext context) {
    print("Build DocumentList ${this.runtimeType} ${this.key.toString()}");
    return FirestoreListView<T>(
      query: query,
      itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
        // return documentListBuilder(context, queryDocumentSnapshot);
        return _CardList(
          document: queryDocumentSnapshot,
          // notifier: notifier,
          documentListBuilder: this.documentListBuilder,
        );
      },
      loadingBuilder: (context) => WaitScreen(),
      errorBuilder: (context, error, stackTrace) => ErrorScreen(error: Exception(error)),
    );
    // return Container(child: Text("_DocumentList: ${location}"));
  }
}

class _CardList<T> extends ConsumerWidget {
  _CardList({
    required this.document,
    // required this.notifier,
    required this.documentListBuilder,
  });

  final QueryDocumentSnapshot<T> document;
  // final ValueNotifier<QueryDocumentSnapshot<T>?> notifier;
  final DocumentListBuilder<T> documentListBuilder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: GestureDetector(
        onTap: () {
          String documentPath = GoRouter.of(context).location;
          print("Update document to ${document.reference.path}");
          NavigationStateNotifier navigationState = ref.read(navigationStateProvider.notifier);
          SelectionState<T> selectionState = SelectionState<T>(queryDocumentSnapshot: document, queryParams: {"id": document.id}, cardId: document.id);
          navigationState.selectionState = selectionState;
          documentPath = documentPath.split("?")[0];
          GoRouter.of(context).go('$documentPath?id=${document.id}', extra: selectionState);
        },
        child: Consumer(builder: (context, ref, child) {
          String activeCard = ref.watch(navigationStateProvider).selectionState.cardId;
          // print("Draw card ${document.id} active card: $activeCard");
          return this.documentListBuilder(context, activeCard == document.id, this.document.data());
        }),
      ),
    );
  }
}

typedef DocumentListBuilder<T> = Widget Function(
  BuildContext context,
  bool selected,
  T data,
);
typedef DocumentBuilder<T> = Widget Function(
  BuildContext context,
  DocumentReference<T> documentReference,
  T data,
);

typedef DocumentStream = Stream<DocumentSnapshot> Function(String? documentId);
