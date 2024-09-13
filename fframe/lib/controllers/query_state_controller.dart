import 'package:fframe/services/database_service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../fframe.dart';

class FireStoreQueryState<T> with ChangeNotifier {
  final Query<T> Function(Query<T>)? initialQuery;
  final Query<T> Function(Query<T>)? listQuery;
  late Query<T> baseQuery;
  late FirestoreQueryBuilderSnapshot<T> queryBuilderSnapshot;
  final Map<String, Query<T> Function(Query<T>)> _queryComponents = {};

  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;

  FireStoreQueryState({
    required this.collection,
    required this.fromFirestore,
    required this.initialQuery,
    required this.listQuery,
  }) {
    baseQuery = DatabaseService<T>().query(
      collection: collection,
      fromFirestore: fromFirestore,
    );

    if (initialQuery != null) {
      baseQuery = initialQuery!.call(baseQuery);
    }
  }

  reset() {
    _queryComponents.clear();
    notifyListeners();
  }

  removeQueryComponent({required String id}) {
    if (_queryComponents.containsKey(id)) {
      _queryComponents.remove(id);
      notifyListeners();
    }
  }

  addQueryComponent({
    required String id,
    required Query<T> Function(Query<T>) queryComponent,
    bool notify = true,
  }) {
    _queryComponents[id] = queryComponent;
    if (notify) notifyListeners();
  }

  Map<String, Query<T> Function(Query<T>)> get queryComponents => _queryComponents;

  Query<T> firstDocumentQuery() {
    Query<T> query = baseQuery;

    if (listQuery != null) {
      query = listQuery!.call(query);
    }

    query.limit(1);
    return query;
  }

  Query<T> currentQuery() {
    Query<T> query = baseQuery;

    if (listQuery != null) {
      query = listQuery!.call(query);
    }

    if (_queryComponents.isNotEmpty) {
      for (var queryComponent in _queryComponents.entries) {
        query = queryComponent.value.call(query);
      }
    }

    return query;
  }
}
