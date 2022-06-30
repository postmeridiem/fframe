import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/l10n.dart';

Map<Function, dynamic> firestore = {
// getCustomer(): async (documentId: string) =>
//         await getSingle<customerDataModel>(firestore()
//             .collection(`${collectionIds.customersCollectionId}`)
//             .doc(documentId)
//             .withConverter(customerConverter))
};

class DatabaseService<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Query<SampleModel> getSuggestion() {
  //   return query<SampleModel>(collection: "", SampleModel.fromFirestore, ))
  // }

  Query<T> query({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    Query<T> Function(Query query)? queryBuilder,
    int? limit,
  }) {
    Query<T> query = FirebaseFirestore.instance.collection(collection).withConverter(
          fromFirestore: fromFirestore,
          toFirestore: (T, _) => {},
        );

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query;
  }

  Stream<DocumentSnapshot<T>>? documentStream({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) {
    if (_auth.currentUser == null) return const Stream.empty();

    DocumentReference<T> documentReference = FirebaseFirestore.instance.collection(collection).doc(documentId).withConverter<T>(
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

  Future<DocumentSnapshot<T>?> documentSnapshot({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) async {
    if (_auth.currentUser == null) return null;
    DocumentReference<T>? documentReference = await this.documentReference(collection: collection, documentId: documentId, fromFirestore: fromFirestore, toFirestore: toFirestore);
    return documentReference!.get();
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
