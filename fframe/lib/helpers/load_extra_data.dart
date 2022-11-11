part of fframe;

class ReadFromFireStoreByDocumentId<T> extends StatelessWidget {
  const ReadFromFireStoreByDocumentId({
    required this.builder,
    this.errorBuilder,
    this.waitBuilder,
    this.notFoundBuilder,
    required this.fromFirestore,
    required this.toFirestore,
    required this.documentId,
    required this.collection,
    Key? key,
  }) : super(key: key);

  final ResultBuilder<T> builder;
  final ErrorBuilder? errorBuilder;
  final WaitBuilder? waitBuilder;
  final NotFoundBuilder? notFoundBuilder;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final String documentId;
  final String collection;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<T>>(
      stream: DatabaseService<T>().documentStream(
        collection: collection,
        documentId: documentId,
        fromFirestore: fromFirestore,
        toFirestore: toFirestore,
      )!,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<T>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            if (waitBuilder == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return waitBuilder!(context);
          case ConnectionState.active:
            if (snapshot.hasError) {
              //Something has gone wrong
              if (errorBuilder == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    Text(snapshot.error.toString()),
                  ],
                );
              }
              return errorBuilder!(context, snapshot.error.toString());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              if (notFoundBuilder == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning),
                    Text("Not found"),
                  ],
                );
              }
              return notFoundBuilder!(context);
            }

            return builder(context, snapshot.data!.data() as T);
        }
      },
    );
  }
}

class QueryFromFireStore<T> extends StatelessWidget {
  const QueryFromFireStore({
    required this.builder,
    this.errorBuilder,
    this.waitBuilder,
    this.notFoundBuilder,
    required this.fromFirestore,
    required this.toFirestore,
    this.query,
    required this.collection,
    this.limit,
    Key? key,
  }) : super(key: key);

  final ResultsBuilder<T> builder;
  final ErrorBuilder? errorBuilder;
  final WaitBuilder? waitBuilder;
  final NotFoundBuilder? notFoundBuilder;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final Query<T> Function(Query<T>)? query;
  final String collection;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    Query<T> query = DatabaseService<T>().query(
      collection: collection,
      fromFirestore: fromFirestore,
      queryBuilder: this.query,
      limit: limit,
    );

    return FutureBuilder<QuerySnapshot<T>>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<T>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (waitBuilder == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return waitBuilder!(context);

          case ConnectionState.done:
            if (snapshot.hasError) {
              //Something has gone wrong
              if (errorBuilder == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    Text(snapshot.error.toString()),
                  ],
                );
              }
              return errorBuilder!(context, snapshot.error.toString());
            }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
              if (notFoundBuilder == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning),
                    Text("Not found"),
                  ],
                );
              }
              return notFoundBuilder!(context);
            }

            return builder(
              context,
              snapshot.data!.docs.map((QueryDocumentSnapshot<T> queryDocument) => FirestoreDocument<T>(queryDocument: queryDocument, fromFirestore: fromFirestore, toFirestore: toFirestore)).toList(),
            );
        }
      },
    );
  }
}

class QueryStreamFromFireStore<T> extends StatelessWidget {
  const QueryStreamFromFireStore({
    required this.builder,
    this.errorBuilder,
    this.waitBuilder,
    this.notFoundBuilder,
    required this.fromFirestore,
    required this.toFirestore,
    this.query,
    required this.collection,
    this.limit,
    Key? key,
  }) : super(key: key);

  final ResultsBuilder<T> builder;
  final ErrorBuilder? errorBuilder;
  final WaitBuilder? waitBuilder;
  final NotFoundBuilder? notFoundBuilder;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final Query<T> Function(Query<T>)? query;
  final String collection;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    Query<T> query = DatabaseService<T>().query(
      collection: collection,
      fromFirestore: fromFirestore,
      queryBuilder: this.query,
      limit: limit,
    );

    return StreamBuilder<QuerySnapshot<T>>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<T>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            if (waitBuilder == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return waitBuilder!(context);

          case ConnectionState.active:
            if (snapshot.hasError) {
              //Something has gone wrong
              if (errorBuilder == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    Text(snapshot.error.toString()),
                  ],
                );
              }
              return errorBuilder!(context, snapshot.error.toString());
            }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
              if (notFoundBuilder == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning),
                    Text("Not found"),
                  ],
                );
              }
              return notFoundBuilder!(context);
            }

            return builder(
              context,
              snapshot.data!.docs.map((QueryDocumentSnapshot<T> queryDocument) => FirestoreDocument<T>(queryDocument: queryDocument, fromFirestore: fromFirestore, toFirestore: toFirestore)).toList(),
            );
        }
      },
    );
  }
}

class FirestoreDocument<T> {
  FirestoreDocument({
    required this.fromFirestore,
    required this.toFirestore,
    required this.queryDocument,
  });

  final QueryDocumentSnapshot<T> queryDocument;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;

  T get data => queryDocument.data();

  Future<SaveState> save(T newData) async {
    debugPrint("Save document ${queryDocument.reference.parent.path} :: ${queryDocument.id}");
    return DatabaseService<T>().updateDocument(collection: queryDocument.reference.parent.path, documentId: queryDocument.id, data: newData, fromFirestore: fromFirestore, toFirestore: toFirestore);
    // return queryDocument.reference.set(queryDocument.data(), SetOptions(merge: true));
  }
}

typedef ResultBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);

typedef ResultsBuilder<T> = Widget Function(
  BuildContext context,
  List<FirestoreDocument<T>> firestoreDocuments,
);

typedef WaitBuilder<T> = Widget Function(
  BuildContext context,
);

typedef NotFoundBuilder<T> = Widget Function(
  BuildContext context,
);

typedef ErrorBuilder<T> = Widget Function(
  BuildContext context,
  String error,
);
