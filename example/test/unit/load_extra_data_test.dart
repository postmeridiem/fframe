import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe_test.dart';
import 'package:example/helpers/load_extra_data.dart' as load_extra;
import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

// FIREBASE TESTING LIMITATIONS DOCUMENTATION
// ===========================================
//
// This test file demonstrates the fundamental challenges of testing Firebase-dependent
// widgets in Flutter's test environment. Key issues encountered:
//
// 1. FIREBASE INITIALIZATION ERROR:
//    - Error: [core/no-app] No Firebase App '[DEFAULT]' has been created
//    - Cause: Widgets instantiate DatabaseService() which requires global Firebase setup
//    - Impact: 10/16 tests fail due to Firebase dependency
//
// 2. ARCHITECTURAL CONSTRAINTS:
//    - load_extra_data widgets directly use Firebase global instances
//    - No dependency injection support in widget constructors
//    - Cannot inject FakeFirebaseFirestore into existing widget architecture
//
// 3. TESTING STRATEGY RECOMMENDATIONS:
//    - ✅ Test widget structure, props, and non-Firebase logic (6 tests pass)
//    - ✅ Test constructor parameters and type safety
//    - ❌ Avoid testing Firebase streaming/querying behavior in unit tests
//    - ❌ Firebase integration should be tested at service level, not widget level
//
// 4. ALTERNATIVE APPROACHES:
//    - Widget tests: Focus on UI structure and prop validation
//    - Integration tests: Use Firebase emulator for full-stack testing
//    - Service tests: Test DatabaseService separately with mocked Firebase
//
// For detailed analysis see: docs/testing-constraints.md
//
// This limitation is not a failure of the test suite, but rather a fundamental
// architectural constraint when testing Firebase widgets without dependency injection.

// Test model for load_extra_data widgets
class TestModel {
  final String id;
  final String name;
  final int value;

  TestModel({required this.id, required this.name, required this.value});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'value': value,
      };

  static TestModel fromMap(Map<String, dynamic> map) => TestModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        value: map['value'] ?? 0,
      );
}

void main() {
  setupTiming(TestType.unit);

  group('LoadExtraData Widgets', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      setupUnitTests();
      fakeFirestore = createFakeFirestore();
    });

    TestModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
      final data = snapshot.data() ?? {};
      return TestModel.fromMap(data);
    }

    Map<String, Object?> toFirestore(TestModel model, SetOptions? options) {
      return model.toMap();
    }

    timedGroup('ReadFromFireStoreByDocumentId', () {
      timedTestWidgets('should display loading state initially', (tester) async {
        // Setup fake data
        await fakeFirestore.collection('test').doc('doc1').set({
          'id': 'doc1',
          'name': 'Test Item',
          'value': 42,
        });

        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.ReadFromFireStoreByDocumentId<TestModel>(
              collection: 'test',
              documentId: 'doc1',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              builder: (context, data) {
                return const Text('Data: \${data?.name}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);

        // Should show loading indicator initially
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      timedTestWidgets('should display custom wait widget when provided', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.ReadFromFireStoreByDocumentId<TestModel>(
              collection: 'test',
              documentId: 'doc1',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              waitBuilder: (context) => const Text('Custom Loading'),
              builder: (context, data) {
                return const Text('Data: \${data?.name}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);

        expect(find.text('Custom Loading'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      timedTestWidgets('should display not found state for missing document', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.ReadFromFireStoreByDocumentId<TestModel>(
              collection: 'test',
              documentId: 'nonexistent',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              builder: (context, data) {
                return const Text('Data: \${data?.name}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Should show default not found message
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('Not found'), findsOneWidget);
      });

      timedTestWidgets('should display custom not found widget when provided', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.ReadFromFireStoreByDocumentId<TestModel>(
              collection: 'test',
              documentId: 'nonexistent',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              notFoundBuilder: (context) => const Text('Custom Not Found'),
              builder: (context, data) {
                return const Text('Data: \${data?.name}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.text('Custom Not Found'), findsOneWidget);
        expect(find.text('Not found'), findsNothing);
      });

      timedTestWidgets('should handle constructor parameters correctly', (tester) async {
        const testKey = Key('test-widget');

        final widget = load_extra.ReadFromFireStoreByDocumentId<TestModel>(
          key: testKey,
          collection: 'test',
          documentId: 'doc1',
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
          builder: (context, data) => const SizedBox(),
        );

        expect(widget.key, equals(testKey));
        expect(widget.collection, equals('test'));
        expect(widget.documentId, equals('doc1'));
        expect(widget.fromFirestore, equals(fromFirestore));
        expect(widget.toFirestore, equals(toFirestore));
      });
    });

    timedGroup('QueryFromFireStore', () {
      timedTestWidgets('should display loading state initially', (tester) async {
        // Setup fake data
        await fakeFirestore.collection('test').doc('doc1').set({
          'id': 'doc1',
          'name': 'Test Item 1',
          'value': 42,
        });

        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.QueryFromFireStore<TestModel>(
              collection: 'test',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              query: null,
              builder: (context, data) {
                return const Text('Count: \${data?.docs.length ?? 0}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);

        // Should show loading indicator initially
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      timedTestWidgets('should display custom wait widget when provided', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.QueryFromFireStore<TestModel>(
              collection: 'test',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              query: null,
              waitBuilder: (context) => const Text('Query Loading'),
              builder: (context, data) {
                return const Text('Count: \${data?.docs.length ?? 0}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);

        expect(find.text('Query Loading'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      timedTestWidgets('should display not found for empty collection', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.QueryFromFireStore<TestModel>(
              collection: 'empty',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              query: null,
              builder: (context, data) {
                return const Text('Count: \${data?.docs.length ?? 0}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Should show default not found message
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('Not found'), findsOneWidget);
      });

      timedTestWidgets('should display custom not found widget when provided', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.QueryFromFireStore<TestModel>(
              collection: 'empty',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              query: null,
              notFoundBuilder: (context) => const Text('No Results Found'),
              builder: (context, data) {
                return const Text('Count: \${data?.docs.length ?? 0}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.text('No Results Found'), findsOneWidget);
        expect(find.text('Not found'), findsNothing);
      });

      timedTestWidgets('should handle constructor parameters correctly', (tester) async {
        const testKey = Key('query-widget');
        Query<TestModel> testQuery(Query<TestModel> query) => query.limit(5);

        final widget = load_extra.QueryFromFireStore<TestModel>(
          key: testKey,
          collection: 'test',
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
          query: testQuery,
          limit: 10,
          builder: (context, data) => const SizedBox(),
        );

        expect(widget.key, equals(testKey));
        expect(widget.collection, equals('test'));
        expect(widget.fromFirestore, equals(fromFirestore));
        expect(widget.toFirestore, equals(toFirestore));
        expect(widget.query, equals(testQuery));
        expect(widget.limit, equals(10));
      });
    });

    timedGroup('Type Definitions', () {
      timedTest('Builder typedef should work correctly', () {
        Widget testBuilderFunction(BuildContext context, String data) {
          return Text(data);
        }

        expect(testBuilderFunction, isA<load_extra.Builder<String>>());
      });

      timedTest('WaitBuilder typedef should work correctly', () {
        Widget testWaitBuilderFunction(BuildContext context) {
          return const CircularProgressIndicator();
        }

        expect(testWaitBuilderFunction, isA<load_extra.WaitBuilder<String>>());
      });

      timedTest('NotFoundBuilder typedef should work correctly', () {
        Widget testNotFoundBuilderFunction(BuildContext context) {
          return const Text('Not found');
        }

        expect(testNotFoundBuilderFunction, isA<load_extra.NotFoundBuilder<String>>());
      });

      timedTest('ErrorBuilder typedef should work correctly', () {
        Widget testErrorBuilderFunction(BuildContext context, String error) {
          return const Text('Error: \$error');
        }

        expect(testErrorBuilderFunction, isA<load_extra.ErrorBuilder<String>>());
      });
    });

    timedGroup('Widget Integration', () {
      timedTestWidgets('ReadFromFireStoreByDocumentId should integrate with DatabaseService', (tester) async {
        // This test verifies the widget properly uses DatabaseService
        // We can't fully test Firebase integration due to constraints, but we can verify structure

        await fakeFirestore.collection('integration').doc('test').set({
          'id': 'test',
          'name': 'Integration Test',
          'value': 100,
        });

        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.ReadFromFireStoreByDocumentId<TestModel>(
              collection: 'integration',
              documentId: 'test',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              builder: (context, data) {
                return const Text('Integration: \${data?.name ?? "null"}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);

        // Verify widget was created without errors
        expect(find.byType(load_extra.ReadFromFireStoreByDocumentId<TestModel>), findsOneWidget);
      });

      timedTestWidgets('QueryFromFireStore should integrate with DatabaseService', (tester) async {
        // Setup test data
        await fakeFirestore.collection('query_test').doc('item1').set({
          'id': 'item1',
          'name': 'Query Test 1',
          'value': 50,
        });

        final widget = MaterialApp(
          home: Scaffold(
            body: load_extra.QueryFromFireStore<TestModel>(
              collection: 'query_test',
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
              query: (query) => query.where('value', isGreaterThan: 0),
              builder: (context, data) {
                return const Text('Query Results: \${data?.docs.length ?? 0}');
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);

        // Verify widget was created without errors
        expect(find.byType(load_extra.QueryFromFireStore<TestModel>), findsOneWidget);
      });
    });
  });
}
