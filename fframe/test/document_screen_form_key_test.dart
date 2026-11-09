import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the form key of a DocumentScreen. Everything below the screen's form lives as long
/// as this key, so an app that keeps the key keeps the screen (its lists, its swimlanes and
/// their loaded pages) when it builds the screen again.
void main() {
  DocumentScreen<String> screen({GlobalKey<FormState>? formKey}) => DocumentScreen<String>(
        formKey: formKey,
        collection: 'cards',
        createNew: () => '',
        documentTitle: (BuildContext context, String data) => data,
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) => '',
        toFirestore: (String data, SetOptions? options) => {},
        document: Document<String>(documentTabsBuilder: (BuildContext context, String data, bool isReadOnly, bool isNew, FFrameUser? user) => []),
      );

  test('uses the form key from the app, so each build of the app gets the same form', () {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    expect(screen(formKey: formKey).formKey, same(formKey));
    expect(screen(formKey: formKey).formKey, same(formKey));
  });

  test('without a key from the app, each new screen gets its own form', () {
    expect(screen().formKey, isNot(same(screen().formKey)));
  });
}
