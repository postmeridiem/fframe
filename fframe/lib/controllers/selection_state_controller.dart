// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectionState<T> {
  // final QueryDocumentSnapshot<T>? queryDocumentSnapshot;
  final Map<String, String>? queryParams;
  final T? data;
  final String? docId;
  final GlobalKey<NavigatorState> globalKey;
  SelectionState({
    required this.docId,
    this.data,
    this.queryParams,
  }) : globalKey = GlobalKey<NavigatorState>();
}

class SelectionStateNotifier with ChangeNotifier {
  late SelectionState _selectionState = SelectionState(docId: null);
  // Map<String, String>? _queryParams;
  ValueKey<String>? _pageKey;

  // Map<String, String>? get queryParams => _queryParams;
  // updateQueryParams(Map<String, String>? queryParams) async {
  //   _selectionState.queryParams = queryParams;
  //   _queryParams = queryParams;
  //   notifyListeners();
  // }

  // ignore: unnecessary_getters_setters
  ValueKey<String>? get pageKey => _pageKey;
  set pageKey(ValueKey<String>? pageKey) {
    _pageKey = pageKey;
  }

  SelectionState get state => _selectionState;
  set state(SelectionState selectionState) {
    debugPrint("NavigationStateNotifier: new selectionState: ${selectionState.queryParams}");
    _selectionState = selectionState;
    notifyListeners();
  }
}
