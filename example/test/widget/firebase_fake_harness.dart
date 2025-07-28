import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import '../unit/unit_test_harness.dart';

/// Mock Firebase options for fake Firebase services
const FirebaseOptions fakeFirebaseOptions = FirebaseOptions(
  apiKey: 'fake-api-key',
  appId: '1:fake-project:web:fake-app-id',
  messagingSenderId: 'fake-sender-id',
  projectId: 'fake-project-id',
);

/// FirebaseFakeHarness provides a test environment with fake Firebase services.
/// 
/// This harness is designed for widget tests that need to interact with Firebase
/// services but should run quickly without network dependencies. It uses:
/// - fake_cloud_firestore for Firestore operations
/// - firebase_auth_mocks for Authentication
/// 
/// Features:
/// - Fast execution (no network calls)
/// - Predictable fake data
/// - Full Firebase API compatibility
/// - Proper cleanup between tests
/// - Extends existing TestHarness functionality
/// 
/// Usage:
/// ```dart
/// testWidgets('test widget with Firebase dependency', (tester) async {
///   final harness = FirebaseFakeHarness(
///     child: MyFirebaseWidget(),
///     initialFirestoreData: {
///       'users/user1': {'name': 'Test User', 'email': 'test@example.com'}
///     },
///     mockUser: MockUser(
///       isAnonymous: false,
///       uid: 'user1',
///       email: 'test@example.com',
///       displayName: 'Test User',
///     ),
///   );
///   
///   await tester.pumpWidget(harness);
///   await tester.pumpAndSettle();
///   
///   // Your test assertions here
/// });
/// ```
class FirebaseFakeHarness extends StatefulWidget {
  const FirebaseFakeHarness({
    super.key,
    required this.child,
    this.l10nConfig,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.initialFirestoreData = const {},
    this.mockUser,
    this.enableAuth = true,
    this.enableFirestore = true,
  });

  final Widget child;
  final L10nConfig? l10nConfig;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  
  /// Initial data to populate in fake Firestore
  /// Format: {'collection/document': {'field': 'value'}}
  final Map<String, Map<String, dynamic>> initialFirestoreData;
  
  /// Mock user to be signed in (null = no user signed in)
  final MockUser? mockUser;
  
  /// Whether to initialize fake Auth service
  final bool enableAuth;
  
  /// Whether to initialize fake Firestore service
  final bool enableFirestore;

  @override
  State<FirebaseFakeHarness> createState() => _FirebaseFakeHarnessState();
  
  /// Access the fake Firebase instances for test setup/assertions
  static FakeFirebaseFirestore? get fakeFirestore => _fakeFirestore;
  static MockFirebaseAuth? get fakeAuth => _fakeAuth;
  
  /// Static references to fake services for test access
  static FakeFirebaseFirestore? _fakeFirestore;
  static MockFirebaseAuth? _fakeAuth;
}

class _FirebaseFakeHarnessState extends State<FirebaseFakeHarness> {
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    _initializeFakeFirebase();
  }

  /// Initialize fake Firebase services synchronously
  void _initializeFakeFirebase() {
    try {
      // Initialize fake Firestore if enabled
      if (widget.enableFirestore) {
        FirebaseFakeHarness._fakeFirestore = FakeFirebaseFirestore();
        
        // Populate initial data synchronously
        _populateInitialDataSync();
      }

      // Initialize fake Auth if enabled
      if (widget.enableAuth) {
        FirebaseFakeHarness._fakeAuth = MockFirebaseAuth(
          mockUser: widget.mockUser,
          signedIn: widget.mockUser != null,
        );
      }
    } catch (e) {
      _initializationError = e.toString();
    }
  }

  /// Populate fake Firestore with initial test data synchronously
  void _populateInitialDataSync() {
    if (FirebaseFakeHarness._fakeFirestore == null) return;
    
    final firestore = FirebaseFakeHarness._fakeFirestore!;
    
    for (final entry in widget.initialFirestoreData.entries) {
      final path = entry.key;
      final data = entry.value;
      
      // Parse collection/document path
      final pathParts = path.split('/');
      if (pathParts.length >= 2) {
        final collectionId = pathParts[0];
        final documentId = pathParts[1];
        
        // Use the synchronous fake firestore methods
        firestore
            .collection(collectionId)
            .doc(documentId)
            .set(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Firebase Fake Initialization Failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _initializationError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Initialize fframe singletons
    setupUnitTests();

    return MaterialApp(
      theme: widget.theme ?? ThemeData.light(),
      darkTheme: widget.darkTheme ?? ThemeData.dark(),
      themeMode: widget.themeMode,
      locale: L10n.getLocale(),
      supportedLocales: L10n.getLocales(),
      localizationsDelegates: L10n.getDelegates(),
      home: Scaffold(
        body: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up fake services
    FirebaseFakeHarness._fakeFirestore = null;
    FirebaseFakeHarness._fakeAuth = null;
    super.dispose();
  }
}

/// Utility functions for working with fake Firebase services

/// Create test data in fake Firestore
Future<void> addTestDocument({
  required String collection,
  required String documentId,
  required Map<String, dynamic> data,
}) async {
  final firestore = FirebaseFakeHarness.fakeFirestore;
  if (firestore != null) {
    await firestore.collection(collection).doc(documentId).set(data);
  }
}

/// Get document from fake Firestore
Future<Map<String, dynamic>?> getTestDocument({
  required String collection,
  required String documentId,
}) async {
  final firestore = FirebaseFakeHarness.fakeFirestore;
  if (firestore != null) {
    final doc = await firestore.collection(collection).doc(documentId).get();
    return doc.data();
  }
  return null;
}

/// Clear all data from fake Firestore
Future<void> clearFakeFirestore() async {
  final firestore = FirebaseFakeHarness.fakeFirestore;
  if (firestore != null) {
    // FakeFirebaseFirestore doesn't have a direct clear method,
    // but we can create a new instance
    FirebaseFakeHarness._fakeFirestore = FakeFirebaseFirestore();
  }
}

/// Sign in a user to fake Auth
Future<void> signInFakeUser(MockUser user) async {
  final auth = FirebaseFakeHarness.fakeAuth;
  if (auth != null) {
    await auth.signInWithEmailAndPassword(
      email: user.email ?? 'test@example.com',
      password: 'password',
    );
  }
}

/// Sign out current user from fake Auth
Future<void> signOutFakeUser() async {
  final auth = FirebaseFakeHarness.fakeAuth;
  if (auth != null) {
    await auth.signOut();
  }
}

/// Create a standard test user for consistent testing
MockUser createTestUser({
  String uid = 'test-user-id',
  String email = 'test@example.com',
  String displayName = 'Test User',
  bool isAnonymous = false,
}) {
  return MockUser(
    isAnonymous: isAnonymous,
    uid: uid,
    email: email,
    displayName: displayName,
    isEmailVerified: true,
  );
}