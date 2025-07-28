import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'emulator_test_harness.dart';

void main() {
  group('EmulatorTestHarness', () {
    testWidgets('should initialize Firebase emulators successfully', (tester) async {
      const harness = EmulatorTestHarness(
        child: Text('Test Content'),
      );

      await tester.pumpWidget(harness);
      
      // Wait for emulator initialization
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should not show error state
      expect(find.byIcon(Icons.error), findsNothing);
      
      // Should not show loading state
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // Should show the test content
      expect(find.text('Test Content'), findsOneWidget);
      
      // Cleanup
      await EmulatorTestHarness.cleanup();
    });

    testWidgets('should connect to Auth emulator', (tester) async {
      const harness = EmulatorTestHarness(
        enableAuth: true,
        enableFirestore: false,
        child: Text('Auth Test'),
      );

      await tester.pumpWidget(harness);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Create a test user through the emulator
      final userCredential = await createTestUser(
        email: 'test@example.com',
        password: 'testpassword123',
        displayName: 'Test User',
      );

      expect(userCredential.user, isNotNull);
      expect(userCredential.user!.email, equals('test@example.com'));
      expect(userCredential.user!.displayName, equals('Test User'));

      // Cleanup
      await EmulatorTestHarness.cleanup(enableAuth: true, enableFirestore: false);
    });

    testWidgets('should connect to Firestore emulator', (tester) async {
      const harness = EmulatorTestHarness(
        enableAuth: false,
        enableFirestore: true,
        child: Text('Firestore Test'),
      );

      await tester.pumpWidget(harness);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test Firestore operations
      final firestore = FirebaseFirestore.instance;
      final testDoc = firestore.collection('test').doc('testDoc');
      
      await testDoc.set({'message': 'Hello from emulator!'});
      
      final snapshot = await testDoc.get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()?['message'], equals('Hello from emulator!'));

      // Cleanup
      await clearFirestoreEmulator();
      await EmulatorTestHarness.cleanup(enableAuth: false, enableFirestore: true);
    });

    testWidgets('should handle both Auth and Firestore together', (tester) async {
      const harness = EmulatorTestHarness(
        enableAuth: true,
        enableFirestore: true,
        child: Text('Full Integration Test'),
      );

      await tester.pumpWidget(harness);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Create user and document
      await createTestUser(
        email: 'fulltest@example.com',
        password: 'password123',
      );

      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc('testUser').set({
        'email': 'fulltest@example.com',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final userDoc = await firestore.collection('users').doc('testUser').get();
      expect(userDoc.exists, isTrue);
      expect(userDoc.data()?['email'], equals('fulltest@example.com'));

      // Cleanup
      await resetAuthEmulator();
      await clearFirestoreEmulator();
      await EmulatorTestHarness.cleanup();
    });
  });
}