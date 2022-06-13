import 'package:flutter/material.dart';

class SelectionState<T> {
  late T? data;
  late String? docId;

  SelectionState({
    this.docId,
    this.data,
  });
}

class SelectionStateNotifier with ChangeNotifier {
  late SelectionState _selectionState = SelectionState(docId: null);

  SelectionState get state => _selectionState;
  set state(SelectionState selectionState) {
    _selectionState = selectionState;
    notifyListeners();
  }
}
