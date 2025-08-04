import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:fframe/services/database_service.dart';

/// Service factory types for different test environments
enum ServiceFactoryType {
  /// Use fake Firebase services (fast, no network, predictable)
  fake,
  /// Use Firebase emulator services (realistic, slower, network dependent)
  emulator,
  /// Use production Firebase services (for integration testing)
  production,
}

/// ServiceFactory provides a centralized way to create service instances
/// with appropriate backends for different test scenarios.
/// 
/// This factory enables:
/// - Consistent service creation across test types
/// - Easy switching between fake, emulator, and production backends
/// - Proper cleanup and test isolation
/// - Singleton reset mechanisms
/// 
/// Usage:
/// ```dart
/// // For fast widget tests
/// final factory = ServiceFactory(ServiceFactoryType.fake);
/// final databaseService = factory.createDatabaseService<Map<String, dynamic>>();
/// 
/// // For integration tests with emulators
/// final factory = ServiceFactory(ServiceFactoryType.emulator);
/// await factory.initialize();
/// final databaseService = factory.createDatabaseService<Map<String, dynamic>>();
/// 
/// // Cleanup after tests
/// await factory.cleanup();
/// ```
class ServiceFactory {
  final ServiceFactoryType type;
  
  // Singleton instances for reuse within test suites
  static final Map<ServiceFactoryType, ServiceFactory> _instances = {};
  
  // Service instances cache
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  
  // Configuration for fake services
  MockUser? _mockUser;
  Map<String, dynamic> _initialFirestoreData;
  
  /// Private constructor for singleton pattern
  ServiceFactory._(this.type, {
    MockUser? mockUser,
    Map<String, dynamic> initialFirestoreData = const {},
  }) : _mockUser = mockUser,
       _initialFirestoreData = initialFirestoreData;
  
  /// Factory method to get or create ServiceFactory instances
  factory ServiceFactory(
    ServiceFactoryType type, {
    MockUser? mockUser,
    Map<String, dynamic> initialFirestoreData = const {},
  }) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }
    
    final instance = ServiceFactory._(
      type,
      mockUser: mockUser,
      initialFirestoreData: initialFirestoreData,
    );
    _instances[type] = instance;
    return instance;
  }
  
  /// Initialize the service factory (required for emulator type)
  Future<void> initialize() async {
    switch (type) {
      case ServiceFactoryType.fake:
        await _initializeFake();
        break;
      case ServiceFactoryType.emulator:
        await _initializeEmulator();
        break;
      case ServiceFactoryType.production:
        await _initializeProduction();
        break;
    }
  }
  
  /// Initialize fake Firebase services
  Future<void> _initializeFake() async {
    // Initialize fake Firestore with initial data
    _firestore = FakeFirebaseFirestore();
    
    // Populate initial data if provided
    if (_initialFirestoreData.isNotEmpty) {
      await _populateFakeFirestore(_initialFirestoreData);
    }
    
    // Initialize mock Firebase Auth
    _auth = MockFirebaseAuth(
      mockUser: _mockUser,
      signedIn: _mockUser != null,
    );
  }
  
  /// Initialize Firebase emulator services
  Future<void> _initializeEmulator() async {
    // Use emulator instances (assumes emulators are running)
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    
    // Configure emulator endpoints if not already configured
    try {
      await _auth!.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // Already configured, ignore
    }
    
    try {
      _firestore!.useFirestoreEmulator('localhost', 8080);
    } catch (e) {
      // Already configured, ignore
    }
  }
  
  /// Initialize production Firebase services
  Future<void> _initializeProduction() async {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }
  
  /// Populate fake Firestore with initial data
  Future<void> _populateFakeFirestore(Map<String, dynamic> data) async {
    if (_firestore is! FakeFirebaseFirestore) return;
    
    final fakeFirestore = _firestore as FakeFirebaseFirestore;
    
    for (final entry in data.entries) {
      final path = entry.key;
      final documentData = entry.value as Map<String, dynamic>;
      
      // Parse collection/document path
      final pathParts = path.split('/');
      if (pathParts.length % 2 != 0) {
        throw ArgumentError('Invalid document path: $path. Must be collection/document format.');
      }
      
      // Build document reference
      DocumentReference docRef = fakeFirestore.collection(pathParts[0]).doc(pathParts[1]);
      for (int i = 2; i < pathParts.length; i += 2) {
        docRef = docRef.collection(pathParts[i]).doc(pathParts[i + 1]);
      }
      
      await docRef.set(documentData);
    }
  }
  
  /// Create a DatabaseService instance with appropriate backend
  DatabaseService<T> createDatabaseService<T>() {
    if (_auth == null || _firestore == null) {
      throw StateError('ServiceFactory not initialized. Call initialize() first.');
    }
    
    return DatabaseService<T>(
      auth: _auth,
      firestore: _firestore,
    );
  }
  
  /// Get the Firebase Auth instance
  FirebaseAuth getAuth() {
    if (_auth == null) {
      throw StateError('ServiceFactory not initialized. Call initialize() first.');
    }
    return _auth!;
  }
  
  /// Get the Firebase Firestore instance
  FirebaseFirestore getFirestore() {
    if (_firestore == null) {
      throw StateError('ServiceFactory not initialized. Call initialize() first.');
    }
    return _firestore!;
  }
  
  /// Update mock user for fake services
  void updateMockUser(MockUser? mockUser) {
    if (type != ServiceFactoryType.fake) {
      throw StateError('updateMockUser() only available for fake service factory');
    }
    
    _mockUser = mockUser;
    
    // Recreate auth instance with new user
    _auth = MockFirebaseAuth(
      mockUser: _mockUser,
      signedIn: _mockUser != null,
    );
  }
  
  /// Add data to fake Firestore
  Future<void> addFakeData(String path, Map<String, dynamic> data) async {
    if (type != ServiceFactoryType.fake) {
      throw StateError('addFakeData() only available for fake service factory');
    }
    
    await _populateFakeFirestore({path: data});
  }
  
  /// Clear all data (for test isolation)
  Future<void> clearData() async {
    switch (type) {
      case ServiceFactoryType.fake:
        await _clearFakeData();
        break;
      case ServiceFactoryType.emulator:
        await _clearEmulatorData();
        break;
      case ServiceFactoryType.production:
        // Don't clear production data for safety
        break;
    }
  }
  
  /// Clear fake service data
  Future<void> _clearFakeData() async {
    // Recreate fake instances to clear all data
    _firestore = FakeFirebaseFirestore();
    _auth = MockFirebaseAuth(
      mockUser: _mockUser,
      signedIn: _mockUser != null,
    );
  }
  
  /// Clear emulator data
  Future<void> _clearEmulatorData() async {
    try {
      // Sign out any authenticated users
      if (_auth?.currentUser != null) {
        await _auth!.signOut();
      }
      
      // Clear Firestore cache
      await _firestore!.clearPersistence();
    } catch (e) {
      // Log but don't fail on cleanup errors
      // Using debugPrint instead of print for production safety
      debugPrint('Warning: Error clearing emulator data: $e');
    }
  }
  
  /// Reset singleton instances (for complete test isolation)
  static void resetSingletons() {
    _instances.clear();
  }
  
  /// Cleanup all resources
  Future<void> cleanup() async {
    await clearData();
    
    // Reset internal state
    _auth = null;
    _firestore = null;
    _mockUser = null;
    _initialFirestoreData = {};
  }
  
  /// Cleanup all singleton instances
  static Future<void> cleanupAll() async {
    for (final factory in _instances.values) {
      await factory.cleanup();
    }
    resetSingletons();
  }
}

/// Utility class for common test service configurations
class TestServiceConfigurations {
  /// Create a service factory configured for basic widget tests
  static ServiceFactory forWidgetTests({
    MockUser? mockUser,
    Map<String, dynamic> initialData = const {},
  }) {
    return ServiceFactory(
      ServiceFactoryType.fake,
      mockUser: mockUser,
      initialFirestoreData: initialData,
    );
  }
  
  /// Create a service factory configured for integration tests
  static ServiceFactory forIntegrationTests() {
    return ServiceFactory(ServiceFactoryType.emulator);
  }
  
  /// Create a service factory with a signed-in test user
  static ServiceFactory withSignedInUser({
    String uid = 'test-user-id',
    String email = 'test@example.com',
    String displayName = 'Test User',
    Map<String, dynamic> initialData = const {},
  }) {
    final mockUser = MockUser(
      isAnonymous: false,
      uid: uid,
      email: email,
      displayName: displayName,
    );
    
    return ServiceFactory(
      ServiceFactoryType.fake,
      mockUser: mockUser,
      initialFirestoreData: initialData,
    );
  }
  
  /// Create a service factory with anonymous user
  static ServiceFactory withAnonymousUser({
    String uid = 'anonymous-user-id',
    Map<String, dynamic> initialData = const {},
  }) {
    final mockUser = MockUser(
      isAnonymous: true,
      uid: uid,
      email: null,
      displayName: null,
    );
    
    return ServiceFactory(
      ServiceFactoryType.fake,
      mockUser: mockUser,
      initialFirestoreData: initialData,
    );
  }
}