import 'package:flutter/material.dart';

class SelectionState<T> with ChangeNotifier {
  late T? data;
  late String? docId;

  SelectionState({
    this.docId,
    this.data,
  });

  set state(SelectionState selectionState) {
    data = selectionState.data;
    docId = selectionState.docId;
    notifyListeners();
  }
}
