import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Streams all documents in a collection with an optional query
  Stream<List<T>> collectionStream<T>({
    required String collection,
    required T Function(QueryDocumentSnapshot<Object?>) builder,
    Query Function(Query query)? queryBuilder,
    int? limit,
    int Function(T lhs, T rhs)? sort,
  }) {
    if (_auth.currentUser == null) return const Stream.empty();
    Query query;
    // debugPrint("Read from $collection");
    query = FirebaseFirestore.instance.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      // print("Found ${snapshot.docs.length} documents in $collection");
      final result = snapshot.docs.map((snapshot) => builder(snapshot)).where((value) => value != null).toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<List<T>> collectionFuture<T>({
    required String collection,
    required T Function(QueryDocumentSnapshot<Object?>) builder,
    String? parentDocumentPath,
    Query Function(Query query)? queryBuilder,
    int? limit,
    int Function(T lhs, T rhs)? sort,
  }) async {
    if (_auth.currentUser == null) return Completer<List<T>>().future;

    Query query;
    // debugPrint("Read from $collection");
    query = FirebaseFirestore.instance.collection(collection);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    try {
      QuerySnapshot snapshots = await query.get();

      // debugPrint("Found ${snapshots.size} documents in $collection");
      List<T> result = snapshots.docs.map((snapshot) => builder(snapshot)).where((value) => value != null).toList();

      if (sort != null) {
        result.toList().sort(sort);
      }
      return result;
    } catch (e) {
      // debugPrint("Non-Existent collection");
      return [];
    }
  }

  Stream<T> documentStream<T>({
    required String collection,
    required T Function(DocumentSnapshot<Object?>) builder,
  }) {
    if (_auth.currentUser == null) return const Stream.empty();
    final DocumentReference reference = FirebaseFirestore.instance.doc(collection);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot));
  }

  Future<T?> documentSnapshot<T>({
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