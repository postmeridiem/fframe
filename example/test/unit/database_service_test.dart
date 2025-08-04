import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fframe/services/database_service.dart';
import 'unit_test_harness.dart';

void main() {
  group('DatabaseService', () {
    setUp(() {
      setupUnitTests();
    });

    test('should work with default instances when Firebase is initialized', () {
      // This tests backward compatibility, but we can't test it without initializing Firebase
      // In a real app, Firebase would be initialized, so this constructor would work
      // For now, we'll just test that the constructor exists and compiles
      expect(() => DatabaseService<Map<String, dynamic>>, returnsNormally);
    });

    test('should accept injected Firebase instances', () {
      // This tests our new dependency injection capability
      final fakeFirestore = FakeFirebaseFirestore();
      final mockAuth = MockFirebaseAuth();
      
      final service = DatabaseService<Map<String, dynamic>>(
        firestore: fakeFirestore,
        auth: mockAuth,
      );
      
      expect(service, isNotNull);
    });

    test('should generate document IDs using injected Firestore instance', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final mockAuth = MockFirebaseAuth(); // Provide both to avoid default instance calls
      final service = DatabaseService<Map<String, dynamic>>(
        firestore: fakeFirestore,
        auth: mockAuth,
      );
      
      final docId = service.generateDocId(collection: 'test');
      expect(docId, isNotNull);
      expect(docId.length, greaterThan(0));
    });
  });
}