import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Query<T> query({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
    Query<T> Function(Query query)? queryBuilder,
    int? limit,
  }) {
    Query<T> query = FirebaseFirestore.instance.collection(collection).withConverter<T>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
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

  // //Streams all documents in a collection with an optional query
  // Stream<List<T>> collectionStream({
  //   required String collection,
  //   required T Function(QueryDocumentSnapshot<Object?>) builder,
  //   Query Function(Query query)? queryBuilder,
  //   int? limit,
  // }) {
  //   if (_auth.currentUser == null) return const Stream.empty();
  //   Query query;
  //   // debugPrint("Read from $collection");
  //   query = FirebaseFirestore.instance.collection(collection);
  //   if (queryBuilder != null) {
  //     query = queryBuilder(query);
  //   }
  //   if (limit != null) {
  //     query = query.limit(limit);
  //   }

  //   final Stream<QuerySnapshot> snapshots = query.snapshots();
  //   return snapshots.map((snapshot) {
  //     // print("Found ${snapshot.docs.length} documents in $collection");
  //     final result = snapshot.docs.map((snapshot) => builder(snapshot)).where((value) => value != null).toList();
  //     return result;
  //   });
  // }

  // Future<List<T>> collectionFuture({
  //   required String collection,
  //   required T Function(QueryDocumentSnapshot<Object?>) builder,
  //   String? parentDocumentPath,
  //   Query Function(Query query)? queryBuilder,
  //   int? limit,
  //   int Function(T lhs, T rhs)? sort,
  // }) async {
  //   if (_auth.currentUser == null) return Completer<List<T>>().future;

  //   Query query;
  //   // debugPrint("Read from $collection");
  //   query = FirebaseFirestore.instance.collection(collection);

  //   if (queryBuilder != null) {
  //     query = queryBuilder(query);
  //   }
  //   if (limit != null) {
  //     query = query.limit(limit);
  //   }

  //   try {
  //     QuerySnapshot snapshots = await query.get();

  //     // debugPrint("Found ${snapshots.size} documents in $collection");
  //     List<T> result = snapshots.docs.map((snapshot) => builder(snapshot)).where((value) => value != null).toList();

  //     if (sort != null) {
  //       result.toList().sort(sort);
  //     }
  //     return result;
  //   } catch (e) {
  //     // debugPrint("Non-Existent collection");
  //     return [];
  //   }
  // }

  Future<T?> documentSnapshot({
    required String collection,
    required T Function(DocumentSnapshot<Object?>) builder,
  }) async {
    if (_auth.currentUser == null) return null;
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.doc(collection).get();
    return builder(documentSnapshot);
  }

  Future<void> updateData({
    required String collection,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    if (_auth.currentUser == null) return;
    final reference = FirebaseFirestore.instance.doc(collection);
    await reference.update(data);
  }

  Future<void> setData({
    required String collection,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    if (_auth.currentUser == null) return;
    final reference = FirebaseFirestore.instance.doc(collection);
    await reference.set(data, SetOptions(merge: merge));
  }
}


///portalIndex/bmw/modelFamily/i3/modelRange/i3/modelVariant/ha/modelYear/2018/powerTrain/fossil/transmission/0/size/5/trim/0