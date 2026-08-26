import 'package:fframe/fframe.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the configuration contract of [ListGridColumn].
///
/// These are pure-Dart assertions — no Firebase, no widget tree — so they run in this
/// package without pulling in a Firestore fake. They exist because the constructor's asserts
/// are the only thing standing between a misconfigured column and a grid that either renders
/// a sort the user cannot see or clear, or silently drops documents.
void main() {
  group('ListGridColumn — fieldName requirement', () {
    test('searchable or sortable without a fieldName is rejected', () {
      // Both need a field to order or filter on; without one the grid would build an
      // invalid query at runtime rather than failing where the mistake was made.
      expect(
        () => ListGridColumn(label: 'A', searchable: true),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => ListGridColumn(label: 'A', sortable: true),
        throwsA(isA<AssertionError>()),
      );
    });

    test('a plain display column needs no fieldName', () {
      // The common case: a cell rendered from a builder, never ordered or searched.
      expect(() => ListGridColumn(label: 'A'), returnsNormally);
    });
  });

  group('ListGridColumn — sortedColumn', () {
    test('defaults to false, so existing configs are unaffected', () {
      expect(ListGridColumn(label: 'A').sortedColumn, isFalse);
    });

    test('is accepted alongside sortable and a fieldName', () {
      expect(
        () => ListGridColumn(
          label: 'Detected',
          fieldName: 'createdAt',
          sortable: true,
          sortedColumn: true,
          descending: true,
        ),
        returnsNormally,
      );
    });

    test('requires sortable', () {
      // Without sortable no header arrow is rendered, so a grid would open sorted with the
      // user unable to see why or clear it.
      expect(
        () => ListGridColumn(
          label: 'Detected',
          fieldName: 'createdAt',
          sortedColumn: true,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
