import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreQueryState<T> with ChangeNotifier {
  late Query<T> Function(Query<T>)? initialQuery;
  final Map<String, Query<T> Function(Query<T>)> _queryComponents = {};

  FireStoreQueryState();

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

  addQueryComponent({required String id, required Query<T> Function(Query<T>) queryComponent}) {
    _queryComponents[id] = queryComponent;
    notifyListeners();
  }

  queryComponents(List<Query<T>> queryComponents) {
    // _queryComponents = queryComponents;
    notifyListeners();
  }

  Query<T> currentQuery(Query<T> query) {
    if (initialQuery != null) {
      query = initialQuery!.call(query);
    }

    if (_queryComponents.isNotEmpty) {
      for (var queryComponent in _queryComponents.entries) {
        query = queryComponent.value.call(query);
      }
    }

    return query;
  }
}
