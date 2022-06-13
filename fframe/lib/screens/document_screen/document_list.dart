part of fframe;

class DocumentListItem<T> extends ConsumerWidget {
  const DocumentListItem({
    Key? key,
    required this.queryDocumentSnapshot,
  }) : super(key: key);

  final QueryDocumentSnapshot<T> queryDocumentSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    DocumentConfig<T> documentConfig = inheritedDocument.documentConfig as DocumentConfig<T>;
    DocumentListItemBuilder<T> documentListItemBuilder = documentConfig.documentList!.builder;
    try {
      return Card(
        child: GestureDetector(
          onTap: () {
            inheritedDocument.selectionState.data = queryDocumentSnapshot.data();
            inheritedDocument.selectionState.docId = queryDocumentSnapshot.id;
            FRouter.of(context).updateQueryString<T>(queryParameters: {documentConfig.queryStringIdParam: queryDocumentSnapshot.id}, resetQueryString: true, context: queryDocumentSnapshot.data());
          },
          child: Consumer(builder: (context, ref, child) {
            String docId = ref.watch(selectionStateProvider).state.docId ?? '';
            try {
              return documentListItemBuilder(context, docId == queryDocumentSnapshot.id, queryDocumentSnapshot.data());
            } catch (e) {
              String _error = e.toString();
              String _path = queryDocumentSnapshot.reference.path;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.amberAccent),
                  subtitle: Text(
                    L10n.interpolated(
                      'errors_dataissue',
                      placeholder: "Data Issue: $_error in $_path",
                      replacers: [
                        L10nReplacer(
                          from: "{error}",
                          replace: _error,
                        ),
                        L10nReplacer(
                          from: "{path}",
                          replace: _path,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      );
    } catch (e) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.warning, color: Colors.amberAccent),
        ),
      );
    }
  }
}

class DocumentListBuilder<T> extends StatelessWidget {
  DocumentListBuilder({
    Key? key,
  }) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    debugPrint("Build DocumentList $runtimeType ${key.toString()}");
    // InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;

    Query<T> query = DatabaseService<T>().query(
      collection: documentConfig.collection,
      fromFirestore: documentConfig.fromFirestore,
    );

    if (documentConfig.documentList?.queryBuilder != null) {
      debugPrint("Apply query builder");
      query = documentConfig.documentList!.queryBuilder!(query);
    }

    return FirestoreListView<T>(
      controller: scrollController,
      query: query,
      itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
        // return documentListBuilder(context, queryDocumentSnapshot);
        return DocumentListItem(
          queryDocumentSnapshot: queryDocumentSnapshot,
        );
      },
      loadingBuilder: (context) => const WaitScreen(),
      errorBuilder: (context, error, stackTrace) => ErrorScreen(error: Exception(error)),
    );
  }
}
