import 'package:flutter/material.dart';

class SelectionState<T> with ChangeNotifier {
  late T? data;
  late String? docId;
  late bool isNew;
  late bool readOnly;

  SelectionState({
    this.docId,
    this.data,
    this.isNew = false,
    this.readOnly = false,
  });

  setState(SelectionState<T> selectionState, {bool notify = false}) {
    data = selectionState.data;
    docId = selectionState.docId;
    isNew = selectionState.isNew;
    readOnly = selectionState.readOnly;

    if (notify) {
      notifyListeners();
    }
  }

  factory SelectionState.reset() {
    return SelectionState<T>(data: null, docId: null, isNew: false, readOnly: false);
  }
}
