import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'firebase_fake_harness.dart';

void main() {
  group('FirebaseFakeHarness', () {
    testWidgets('should initialize with fake Firebase services', (tester) async {
      final testWidget = Container(
        child: const Text('Test Widget'),
      );

      await tester.pumpWidget(
        FirebaseFakeHarness(
          child: testWidget,
          initialFirestoreData: {
            'users/test1': {'name': 'Test User', 'email': 'test@example.com'}
          },
          mockUser: createTestUser(),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Verify the test widget is displayed
      expect(find.text('Test Widget'), findsOneWidget);

      // Verify fake services are initialized
      expect(FirebaseFakeHarness.fakeFirestore, isNotNull);
      expect(FirebaseFakeHarness.fakeAuth, isNotNull);
    });

    testWidgets('should populate initial Firestore data', (tester) async {
      final testData = {
        'users/user1': {'name': 'John Doe', 'email': 'john@test.com'},
        'posts/post1': {'title': 'Test Post', 'content': 'Test content'},
      };

      await tester.pumpWidget(
        FirebaseFakeHarness(
          child: const Text('Test'),
          initialFirestoreData: testData,
        ),
      );

      await tester.pumpAndSettle();

      // Verify data was populated
      final userData = await getTestDocument(
        collection: 'users',
        documentId: 'user1',
      );
      expect(userData, equals({'name': 'John Doe', 'email': 'john@test.com'}));

      final postData = await getTestDocument(
        collection: 'posts',
        documentId: 'post1',
      );
      expect(postData, equals({'title': 'Test Post', 'content': 'Test content'}));
    });

    testWidgets('should handle mock user authentication', (tester) async {
      final mockUser = createTestUser(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      await tester.pumpWidget(
        FirebaseFakeHarness(
          child: const Text('Test'),
          mockUser: mockUser,
        ),
      );

      await tester.pumpAndSettle();

      // Verify auth service is initialized with the mock user
      final auth = FirebaseFakeHarness.fakeAuth;
      expect(auth, isNotNull);
      expect(auth!.currentUser, isNotNull);
      expect(auth.currentUser!.uid, equals('test-uid'));
      expect(auth.currentUser!.email, equals('test@example.com'));
    });

    testWidgets('should work without Firebase services when disabled', (tester) async {
      await tester.pumpWidget(
        const FirebaseFakeHarness(
          child: Text('Test Without Firebase'),
          enableAuth: false,
          enableFirestore: false,
        ),
      );

      await tester.pumpAndSettle();

      // Verify the widget still works
      expect(find.text('Test Without Firebase'), findsOneWidget);
    });

    testWidgets('should clean up services on dispose', (tester) async {
      await tester.pumpWidget(
        FirebaseFakeHarness(
          child: const Text('Test'),
          mockUser: createTestUser(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify services are initialized
      expect(FirebaseFakeHarness.fakeFirestore, isNotNull);
      expect(FirebaseFakeHarness.fakeAuth, isNotNull);

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());

      // Services should be cleaned up
      expect(FirebaseFakeHarness.fakeFirestore, isNull);
      expect(FirebaseFakeHarness.fakeAuth, isNull);
    });
  });

  group('Firebase Fake Utility Functions', () {
    setUp(() async {
      // This test group requires a harness to be initialized first
      // We'll create a minimal one for testing utilities
    });

    testWidgets('addTestDocument should add data to fake Firestore', (tester) async {
      await tester.pumpWidget(
        const FirebaseFakeHarness(child: Text('Test')),
      );
      await tester.pumpAndSettle();

      await addTestDocument(
        collection: 'test',
        documentId: 'doc1',
        data: {'field1': 'value1', 'field2': 42},
      );

      final retrievedData = await getTestDocument(
        collection: 'test',
        documentId: 'doc1',
      );

      expect(retrievedData, equals({'field1': 'value1', 'field2': 42}));
    });

    testWidgets('clearFakeFirestore should reset Firestore data', (tester) async {
      await tester.pumpWidget(
        FirebaseFakeHarness(
          child: const Text('Test'),
          initialFirestoreData: {
            'test/doc1': {'data': 'should be cleared'}
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial data exists
      var data = await getTestDocument(collection: 'test', documentId: 'doc1');
      expect(data, isNotNull);

      // Clear the data
      await clearFakeFirestore();

      // Verify data is cleared
      data = await getTestDocument(collection: 'test', documentId: 'doc1');
      expect(data, isNull);
    });
  });
}