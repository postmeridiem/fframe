import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Query<T> query({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    Query<T> Function(Query query)? queryBuilder,
    int? limit,
  }) {
    Query<T> query = FirebaseFirestore.instance.collection(collection).withConverter<T>(
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

  Future<bool> updateData({
    required String collection,
    required String documentId,
    required T data,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
    bool merge = true,
  }) async {
    if (_auth.currentUser == null) return false;
    DocumentReference<T>? documentReference = await this.documentReference(collection: collection, documentId: documentId, fromFirestore: fromFirestore, toFirestore: toFirestore);
    return documentReference!
        .set(
          data,
          SetOptions(merge: merge),
        )
        .then((value) => true)
        .catchError((error) => throw Exception(error));
  }
}
