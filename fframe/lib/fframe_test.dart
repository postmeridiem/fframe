// ignore_for_file: depend_on_referenced_packages, unused_import

/// Test-specific fframe library entry point.
/// Use this entry point for:
/// - Unit tests 
/// - Integration tests
/// - Test utilities and factories
/// 
/// This provides the core fframe functionality plus specific test utilities
/// without web-only dependencies that cause issues on VM platform.
library fframe_test;

// Core Firebase exports (platform-independent)
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';  
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';

// Export the core services and models
export 'services/database_service.dart';
export 'models/document_config_core.dart';

// Test-specific exports
export 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
export 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// Additional testing utilities
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

/// Utility function to create a configured FakeFirebaseFirestore for testing
FakeFirebaseFirestore createFakeFirestore({
  Map<String, dynamic> initialData = const {},
}) {
  final firestore = FakeFirebaseFirestore();
  
  // Populate with initial data if provided
  if (initialData.isNotEmpty) {
    // This would need to be implemented based on the data structure
    // For now, return the empty firestore
  }
  
  return firestore;
}

/// Utility function to create a MockFirebaseAuth for testing
MockFirebaseAuth createMockAuth({
  MockUser? mockUser,
  bool signedIn = false,
}) {
  return MockFirebaseAuth(
    mockUser: mockUser,
    signedIn: signedIn,
  );
}

/// Create a test user for mock authentication
MockUser createTestUser({
  String uid = 'test-user-id',
  String email = 'test@example.com',
  String? displayName = 'Test User',
  bool isAnonymous = false,
}) {
  return MockUser(
    isAnonymous: isAnonymous,
    uid: uid,
    email: email,
    displayName: displayName,
  );
}