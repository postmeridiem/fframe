// ignore_for_file: unnecessary_import

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../fframe.dart';
import 'package:fframe/helpers/l10n.dart';

class DatabaseService<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Query<T> query({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    Query<T> Function(Query<T> query)? queryBuilder,
    int? limit,
  }) {
    Query<T> query = FirebaseFirestore.instance.collection(collection).withConverter<T>(
          fromFirestore: fromFirestore,
          toFirestore: (_, __) => {},
        );

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query;
  }

  Future<int> queryCount({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    Query<T> Function(Query<T> query)? queryBuilder,
  }) async {
    Query<T> query = FirebaseFirestore.instance.collection(collection).withConverter(
          fromFirestore: fromFirestore,
          toFirestore: (_, __) => {},
        );

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    //Count the documents;
    AggregateQuerySnapshot aggregateQuerySnapshot = await query.count().get();
    return aggregateQuerySnapshot.count!;
  }

  Future<int> selecteDocumentCount({
    required DocumentConfig<T> documentConfig,
    Query<T>? query,
  }) async {
    AggregateQuerySnapshot aggregateQuerySnapshot = (query == null) ? (await FirebaseFirestore.instance.collection(documentConfig.collection).count().get()) : (await query.count().get());
    return aggregateQuerySnapshot.count!;
  }

  Stream<DocumentSnapshot<T>>? documentStream({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) {
    if (_auth.currentUser == null) return const Stream.empty();

    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collection);

    DocumentReference<T> documentReference = collectionReference.doc(documentId).withConverter<T>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
    return documentReference.snapshots();
  }

  Future<DocumentReference<T>?> documentReference({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) async {
    if (_auth.currentUser == null) return null;
    DocumentReference<T> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<T>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
    return documentReference;
  }

  String generateDocId({required String collection}) {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collection);
    return collectionReference.doc().id;
  }

  Future<DocumentSnapshot<T>?> documentSnapshot({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) async {
    if (_auth.currentUser == null) return null;
    DocumentReference<T>? documentReference = await this.documentReference(collection: collection, documentId: documentId, fromFirestore: fromFirestore, toFirestore: toFirestore);
    return documentReference?.get();
  }

  Stream<List<SelectedDocument<T>>> selectedDocumentStream({
    required DocumentConfig<T> documentConfig,
    Query<T>? query,
  }) {
    if (query == null) {
      return FirebaseFirestore.instance.collection(documentConfig.collection).withConverter(fromFirestore: documentConfig.fromFirestore, toFirestore: documentConfig.toFirestore).snapshots().map((querySnapshot) => querySnapshot.docs.map((documentSnapshot) {
            return SelectedDocument<T>(
              id: documentSnapshot.id,
              documentConfig: documentConfig,
              documentSnapshot: documentSnapshot,
            );
          }).toList());
    } else {
      return query.withConverter(fromFirestore: documentConfig.fromFirestore, toFirestore: documentConfig.toFirestore).snapshots().map((querySnapshot) => querySnapshot.docs.map((documentSnapshot) {
            return SelectedDocument<T>(
              id: documentSnapshot.id,
              documentConfig: documentConfig,
              documentSnapshot: documentSnapshot,
              data: documentSnapshot.data(),
            );
          }).toList());
    }
  }

  Future<SelectedDocument<T>?> selectedDocument({
    required DocumentConfig<T> documentConfig,
    required String documentId,
    // required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    // required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) async {
    if (_auth.currentUser == null) return null;
    DocumentReference<T>? documentReference = await this.documentReference(collection: documentConfig.collection, documentId: documentId, fromFirestore: documentConfig.fromFirestore, toFirestore: documentConfig.toFirestore);
    DocumentSnapshot<T> documentSnapshot = await documentReference!.get();
    if (documentSnapshot.exists) {
      return SelectedDocument<T>(
        id: documentId,
        documentConfig: documentConfig,
        data: documentSnapshot.data(),
      );
    }
    return null;
  }

  Future<SaveState> updateDocument({
    required String collection,
    required String documentId,
    required T data,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
    bool merge = true,
  }) async {
    if (_auth.currentUser == null) {
      return SaveState(
        result: false,
        errorMessage: L10n.string(
          'save_unauthorized',
          placeholder: "Authentication required.",
        ),
      );
    }
    DocumentReference<T>? documentReference = await this.documentReference(collection: collection, documentId: documentId, fromFirestore: fromFirestore, toFirestore: toFirestore);
    return documentReference!
        .set(data, SetOptions(merge: merge))
        .then(
          (value) => SaveState(result: true),
        )
        .catchError(
          (error) => SaveState(
            result: false,
            errorMessage: error.toString(),
          ),
        );
  }

  Future<SaveState> createDocument({
    required String collection,
    required String documentId,
    required T data,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
    bool merge = true,
  }) async {
    if (_auth.currentUser == null) {
      return SaveState(
        result: false,
        errorMessage: L10n.string(
          'save_unauthorized',
          placeholder: "Authentication required.",
        ),
      );
    }
    DocumentSnapshot<T>? documentSnapshot = await this.documentSnapshot(collection: collection, documentId: documentId, fromFirestore: fromFirestore, toFirestore: toFirestore);
    if (documentSnapshot != null && documentSnapshot.exists) {
      //"Don't overwrite existing documents on create
      return SaveState(
        result: false,
        errorMessage: L10n.string(
          'save_overwrite_existingdocument',
          placeholder: "Cannot overwrite an existing document with a new document.",
        ),
      );
    }

    DocumentReference<T>? documentReference = documentSnapshot!.reference;
    return documentReference
        .set(data)
        .then(
          (value) => SaveState(result: true),
        )
        .catchError(
          (error) => SaveState(
            result: false,
            errorMessage: error.toString(),
          ),
        );
  }

  Future<SaveState> deleteDocument({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) async {
    DocumentReference<T>? documentReference = await this.documentReference(collection: collection, documentId: documentId, fromFirestore: fromFirestore, toFirestore: toFirestore);
    return documentReference!
        .delete()
        .then(
          (value) => SaveState(result: true),
        )
        .catchError(
          (error) => SaveState(
            result: false,
            errorMessage: error.toString(),
          ),
        );
  }
}

class SaveState {
  final bool result;
  final String? errorMessage;

  SaveState({required this.result, this.errorMessage});
}
