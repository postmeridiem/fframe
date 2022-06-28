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
            bool embeddedDocument = inheritedDocument.documentConfig.embeddedDocument;
            String tabIndexKey = embeddedDocument ? "childTabIndex" : "tabIndex";
            inheritedDocument.selectionState.setState(SelectionState<T>(docId: queryDocumentSnapshot.id, data: queryDocumentSnapshot.data()));
            if (documentConfig.document.tabs.length == 1) {
              FRouter.of(context).updateQueryString<T>(queryParameters: {documentConfig.queryStringIdParam: queryDocumentSnapshot.id}, resetQueryString: !embeddedDocument);
            } else {
              FRouter.of(context).updateQueryString<T>(queryParameters: {documentConfig.queryStringIdParam: queryDocumentSnapshot.id, tabIndexKey: "0"}, resetQueryString: !embeddedDocument);
            }
          },
          child: Consumer(builder: (context, ref, child) {
            String docId = inheritedDocument.selectionState.docId ?? '';
            try {
              return documentListItemBuilder(context, docId == queryDocumentSnapshot.id, queryDocumentSnapshot.data(), Fframe.of(context)!.user);
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

class DocumentListLoader<T> extends StatefulWidget {
  const DocumentListLoader({
    Key? key,
    required this.ref,
  }) : super(key: key);
  final WidgetRef ref;
  @override
  State<DocumentListLoader<T>> createState() => _DocumentListLoaderState<T>();
}

class _DocumentListLoaderState<T> extends State<DocumentListLoader<T>> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    debugPrint("Build DocumentList with key ${widget.key.toString()}");
    InheritedDocument inheritedDocument = InheritedDocument.of(context)!;
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;

    Query<T> query = DatabaseService<T>().query(
      collection: documentConfig.collection,
      fromFirestore: documentConfig.fromFirestore,
    );

    if (documentConfig.documentList?.queryBuilder != null) {
      debugPrint("Apply query builder");
      query = documentConfig.documentList!.queryBuilder!(query);
    }

    return DocumentListBody<T>(
      key: ValueKey("documentListBody_${widget.key.toString()}"),
      scrollController: scrollController,
      inheritedDocument: inheritedDocument,
      documentConfig: documentConfig,
      query: query,
      ref: widget.ref,
    );
  }
}

class DocumentListBody<T> extends StatelessWidget {
  const DocumentListBody({
    Key? key,
    required this.scrollController,
    required this.inheritedDocument,
    required this.documentConfig,
    required this.query,
    required this.ref,
  }) : super(key: key);
  final ScrollController scrollController;
  final InheritedDocument inheritedDocument;
  final DocumentConfig<T> documentConfig;
  final Query<T> query;
  final WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 400)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    debugPrint("Build documentListLoader with key: listScaffold_${key.toString()}");

    double listWidth = 250;
    if (ScreenSize.phone == screenSize) {
      listWidth = MediaQuery.of(context).size.width;
      Map<String, String>? queryParameters = ref.watch(queryStateProvider).queryParameters;
      if (queryParameters != null) {
        if (queryParameters.isNotEmpty) {
          //Some document is loaded
          listWidth = 0;
        }
      }
    }

    return SizedBox(
      width: listWidth,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          key: ValueKey("listScaffold_${key.toString()}"),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: const Icon(Icons.add),
              elevation: 0.2,
              onPressed: () {
                inheritedDocument.create(context: context);
              },
            ),
            primary: false,
            body: FirestoreListView<T>(
              controller: scrollController,
              query: query,
              itemBuilder: (context, QueryDocumentSnapshot<T> queryDocumentSnapshot) {
                return DocumentListItem<T>(
                  queryDocumentSnapshot: queryDocumentSnapshot,
                );
              },
              loadingBuilder: (context) => FRouter.of(context).waitPage(context: context, text: "Loading documents"),
              errorBuilder: (context, error, stackTrace) => FRouter.of(context).errorPage(context: context, errorText: error.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
