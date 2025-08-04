import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/l10n.dart';

/// Firebase options specifically configured for emulator testing
const FirebaseOptions emulatorFirebaseOptions = FirebaseOptions(
  apiKey: 'test-api-key',
  appId: '1:test-project-id:web:emulator-app-id',
  messagingSenderId: 'test-sender-id',
  projectId: 'fframe-dev', // Use same project ID as emulator config
);

/// EmulatorTestHarness provides a full Fframe application setup connected to Firebase emulators.
/// 
/// This harness is designed for integration tests that need to test the complete async
/// initialization cascade and real Firebase operations through emulators.
/// 
/// Features:
/// - Connects to Firebase Auth emulator (port 9099)
/// - Connects to Firestore emulator (port 8080)
/// - Provides full Fframe widget tree with async initialization
/// - Includes cleanup methods for test isolation
/// - Handles async initialization cascade properly
/// 
/// Usage:
/// ```dart
/// testWidgets('test async widget with emulators', (tester) async {
///   final harness = EmulatorTestHarness(child: MyAsyncWidget());
///   await tester.pumpWidget(harness);
///   
///   // Wait for async initialization to complete
///   await tester.pumpAndSettle(Duration(seconds: 5));
///   
///   // Your test assertions here
///   
///   // Cleanup
///   await harness.cleanup();
/// });
/// ```
class EmulatorTestHarness extends StatefulWidget {
  const EmulatorTestHarness({
    super.key,
    required this.child,
    this.navigationTargets = const [],
    this.enableAuth = true,
    this.enableFirestore = true,
  });

  final Widget child;
  final List<NavigationTarget> navigationTargets;
  final bool enableAuth;
  final bool enableFirestore;

  @override
  State<EmulatorTestHarness> createState() => _EmulatorTestHarnessState();

  /// Public cleanup method that can be called from tests
  static Future<void> cleanup({
    bool enableAuth = true,
    bool enableFirestore = true,
  }) async {
    try {
      // Sign out any authenticated users
      if (enableAuth && FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }

      // Clear Firestore cache
      if (enableFirestore) {
        await FirebaseFirestore.instance.clearPersistence();
      }
    } catch (e) {
      // Log cleanup errors but don't fail the test
      debugPrint('EmulatorTestHarness cleanup error: $e');
    }
  }
}

class _EmulatorTestHarnessState extends State<EmulatorTestHarness> {
  bool _isInitialized = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    // Initialize synchronously to avoid async in initState
    _initializeEmulatorsSync();
  }

  /// Initialize Firebase and connect to emulators synchronously
  void _initializeEmulatorsSync() {
    try {
      // For emulator testing, we can set up connections without awaiting
      // since the emulators should already be running
      
      // Connect to Auth emulator if enabled
      if (widget.enableAuth) {
        try {
          FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        } catch (e) {
          // Already configured, ignore
        }
      }

      // Connect to Firestore emulator if enabled
      if (widget.enableFirestore) {
        try {
          FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        } catch (e) {
          // Already configured, ignore
        }
      }

      // Set initialized immediately for emulator testing
      _isInitialized = true;
    } catch (e) {
      _initializationError = e.toString();
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
                  'Emulator Initialization Failed',
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

    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing Firebase Emulators...'),
              ],
            ),
          ),
        ),
      );
    }

    return Fframe(
      title: "Emulator Test Harness",
      firebaseOptions: emulatorFirebaseOptions,
      navigationConfig: NavigationConfig(
        navigationTargets: widget.navigationTargets,
        signInConfig: SignInConfig(
          signInTarget: NavigationTarget(
            path: "/sign-in",
            title: "Sign In",
            contentPane: const SizedBox(),
            public: true,
          ),
        ),
        errorPage: NavigationTarget(
          path: "/error",
          title: "Error",
          contentPane: const SizedBox(),
          public: true,
        ),
        emptyPage: NavigationTarget(
          path: "/empty",
          title: "Empty",
          contentPane: const SizedBox(),
          public: true,
        ),
        waitPage: NavigationTarget(
          path: "/wait",
          title: "Wait",
          contentPane: widget.child,
          public: true,
        ),
      ),
      lightMode: ThemeData.light(),
      darkMode: ThemeData.dark(),
      themeMode: ThemeMode.system,
      l10nConfig: L10nConfig(
        locale: const Locale('en', 'US'),
        supportedLocales: [const Locale('en', 'US')],
        localizationsDelegates: const [],
        source: L10nSource.assets,
        namespaces: ['fframe', 'global'],
      ),
      consoleLogger: Console(logThreshold: LogLevel.dev),
      providerConfigs: const [],
      enableNotficationSystem: false,
      debugShowCheckedModeBanner: false,
      globalActions: const [],
      postLoad: (_) async {},
      postSignIn: (_) async {},
      postSignOut: (_) async {},
    );
  }

  /// Cleanup method for test isolation
  /// Call this method at the end of each test to ensure clean state
  Future<void> cleanup() async {
    try {
      // Sign out any authenticated users
      if (widget.enableAuth && FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }

      // Clear Firestore cache
      if (widget.enableFirestore) {
        await FirebaseFirestore.instance.clearPersistence();
      }
    } catch (e) {
      // Log cleanup errors but don't fail the test
      debugPrint('EmulatorTestHarness cleanup error: $e');
    }
  }
}

/// Utility functions for emulator testing

/// Create a test user in the Auth emulator for testing
Future<UserCredential> createTestUser({
  required String email,
  required String password,
  String? displayName,
}) async {
  final userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  
  if (displayName != null && userCredential.user != null) {
    await userCredential.user!.updateDisplayName(displayName);
  }
  
  return userCredential;
}

/// Sign in with test user credentials
Future<UserCredential> signInTestUser({
  required String email,
  required String password,
}) async {
  return await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

/// Clear all data from Firestore emulator
/// Warning: This will delete ALL data in the emulator instance
Future<void> clearFirestoreEmulator() async {
  final firestore = FirebaseFirestore.instance;
  
  // Get all collections (this is a simplified approach)
  // In a real implementation, you might want to maintain a list of test collections
  final collections = ['users', 'settings', 'documents', 'notifications'];
  
  for (final collectionName in collections) {
    final collection = firestore.collection(collectionName);
    final snapshot = await collection.get();
    
    final batch = firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

/// Reset Firebase Auth emulator to clean state
Future<void> resetAuthEmulator() async {
  if (FirebaseAuth.instance.currentUser != null) {
    await FirebaseAuth.instance.signOut();
  }
}