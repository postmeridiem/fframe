# Fframe Testing Strategy

This document outlines a comprehensive testing strategy for the `fframe` package, addressing the challenges of a highly asynchronous, Firebase-dependent, and deeply nested widget architecture.

## 1. Core Principles

*   **Use High-Fidelity Fakes:** For unit and widget tests involving Firebase, always prefer high-fidelity fakes over manual mocks.
    *   **`fake_cloud_firestore`:** Use for any tests that interact with Firestore. This provides a reliable, in-memory database that behaves like the real thing.
    *   **`firebase_auth_mocks`:** Use for tests involving Authentication.
*   **Isolate Tests:** Unit and widget tests should be fast and isolated from external services. The use of fakes and mocks is crucial for this.
*   **Use Emulators for Integration:** The full Firebase Emulator Suite should be reserved for integration and end-to-end tests that require testing backend behavior like Security Rules and Cloud Functions.
*   **Composability:** Create reusable test harnesses to simplify test creation.
*   **Automation:** All tests should be automated and run as part of a CI/CD pipeline.

## 2. Testing Layers

We will adopt a multi-layered testing approach, executed in order from fastest to slowest.

### 2.1. Static Analysis (Linting)

*   **Focus:** Catch code style, formatting, and potential errors before any code is executed.
*   **Tool:** `flutter analyze`
*   **Configuration:** The analysis is configured by the `analysis_options.yaml` file in the `fframe` package root.
*   **Execution:** This will be the first step in our CI pipeline.

### 2.2. Unit Tests

*   **Focus:** Test individual classes and functions in isolation.
*   **Location:** `fframe/test/unit/`
*   **Tools:** `test`, `fake_cloud_firestore`, `firebase_auth_mocks`
*   **Execution Environment:** Due to web-specific dependencies within the `fframe` package (e.g., `dart:html`, `dart:js_interop`), unit tests **must** be run in a browser environment. Use the `--platform chrome` flag when running tests.
*   **Examples:**
    *   Test business logic in controllers and services.
    *   Verify data transformations in models.
    *   Test utility and helper functions.

### 2.2. Widget Tests

*   **Focus:** Test individual widgets in isolation from the full widget tree.
*   **Location:** `fframe/test/widget/`
*   **Tools:** `flutter_test`, `fake_cloud_firestore`, `firebase_auth_mocks`
*   **Execution Environment:** Like unit tests, widget tests must also be run in a browser environment using the `--platform chrome` flag to ensure access to necessary web libraries.
*   **Challenges:**
    *   Deeply nested widget structure.
    *   Dependencies on `Fframe` and other providers.
*   **Solution:** Create a `TestHarness` widget that provides the necessary context for widgets under test.

### 2.3. Integration Tests

*   **Focus:** Test end-to-end user flows, including interaction with a real Firebase backend (via emulators).
*   **Location:** `fframe/test/integration/`
*   **Tools:** `flutter_test`, `integration_test`, **Firebase Emulator Suite**.
*   **Web-specific tools:** `flutter_driver`, `webdriver`
*   **Examples:**
    *   Test the entire sign-in flow with the Auth Emulator.
    *   Verify data is correctly read from and written to the Firestore Emulator, respecting Security Rules.
    *   Test Cloud Function triggers using the Functions Emulator.

#### 2.3.1. Web Integration Tests

For web, we will use `flutter drive` to run integration tests on a real browser. This requires a separate test driver file.

**`fframe/test_driver/integration_test.dart`:**

```dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```

To run the tests:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=test/integration/signin_flow_test.dart -d chrome
```

## 3. Implementation Plan

### 3.1. Test Dependencies

Add the following development dependencies to `fframe/pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  test:
  mockito:
  build_runner:
  # For unit/widget tests
  firebase_auth_mocks:
  fake_cloud_firestore:
  # For integration tests
  integration_test:
  http: # Required to connect to emulators
```

### 3.2. Firebase Testing Approaches

#### 3.2.1. Mocking vs. Faking (for Unit/Widget Tests)

For fast, isolated tests of individual widgets or business logic, we will use high-fidelity fakes instead of manual mocks whenever possible.

*   **`fake_cloud_firestore`:** **This is the preferred method for all unit and widget tests that interact with Firestore.** It provides an in-memory database that accurately mimics the behavior of the real Firestore, making tests more reliable and easier to write.
*   **`firebase_auth_mocks`:** Use for mocking `FirebaseAuth`.
*   **`mockito`:** Use for mocking other dependencies that do not have high-fidelity fakes available.

#### 3.2.2. Firebase Emulator Suite (for Integration Tests)

For high-fidelity end-to-end tests, we will use the official Firebase Emulator Suite. This allows testing against a real, local Firebase backend.

**Setup:**

1.  **Install Firebase CLI:** `npm install -g firebase-tools`
2.  **Initialize Emulators:** In your project's root, run `firebase init emulators`. Select the Auth, Firestore, and Functions emulators.
3.  **Configure Emulators:** The `firebase.json` file will be created. You can configure ports here if needed.

**Connecting the App to Emulators:**

Create a helper file to configure the app to use the emulators during tests.

**`fframe/test/integration/firebase_emulators.dart`:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> connectToFirebaseEmulators() async {
  final host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';

  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  // Add other emulators (Functions, Storage) if needed
}
```

### 3.3. Unit Test Harness

For unit tests that have dependencies on `Fframe` singletons (like `L10n` or `Console`), a test harness is provided to simplify setup. This avoids having to manually initialize each singleton in every test file.

**`fframe/test/unit/test_harness.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

/// Initializes the necessary Fframe singletons for unit testing.
///
/// Call this function in the `setUp` block of your test files.
void setupUnitTests() {
  // L10n calls Console.log, so the Console must be initialized first.
  Console(logThreshold: LogLevel.prod);

  // Initialize L10n with mock data
  L10n(
    l10nConfig: L10nConfig(
      locale: const Locale('en', 'US'),
      supportedLocales: [const Locale('en', 'US')],
      localizationsDelegates: [],
      source: L10nSource.assets,
    ),
    localeData: {
      'global': {
        'greeting': {'translation': 'Hello, World!'},
      },
    },
  );
}
```

**Usage in a Unit Test:**

```dart
// fframe/test/unit/my_class_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';
import 'test_harness.dart'; // Import the harness

void main() {
  group('MyClass Tests', () {
    // Set up the test environment before each test
    setUp(() {
      setupUnitTests();
    });

    test('some test that uses L10n', () {
      // Now you can safely call methods that depend on L10n or Console
      final result = L10n.string('greeting', placeholder: 'Default');
      expect(result, 'Hello, World!');
    });
  });
}
```

### 3.4. Boilerplate Widget Runners

Create a `TestHarness` widget that wraps a given widget with all the necessary providers and context for it to render correctly.

**`fframe/test/widget/test_harness.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

class TestHarness extends StatelessWidget {
  final Widget child;
  final TestSettings? testSettings;

  const TestHarness({
    Key? key,
    required this.child,
    this.testSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Required for web-based tests
    usePathUrlStrategy();

    return Fframe(
      title: 'Test App',
      firebaseOptions: const FirebaseOptions(
        apiKey: 'fake-api-key',
        appId: 'fake-app-id',
        messagingSenderId: 'fake-messaging-sender-id',
        projectId: 'fake-project-id',
      ),
      navigationConfig: NavigationConfig(
        navigationTargets: [],
      ),
      l10nConfig: L10nConfig(
        locale: const Locale('en', 'US'),
        supportedLocales: [const Locale('en', 'US')],
      ),
      testSettings: testSettings,
      child: child,
    );
  }
}
```

### 3.4. Sample Data

Create a separate file for generating sample data to be used in tests.

**`fframe/test/sample_data.dart`:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final Map<String, dynamic> sampleUser = {
  'uid': 'test-uid',
  'email': 'test@example.com',
  'displayName': 'Test User',
};

final Map<String, dynamic> sampleDocument = {
  'id': 'test-doc-id',
  'title': 'Test Document',
  'content': 'This is a test document.',
  'createdAt': Timestamp.now(),
};
```

### 3.5. Application Changes: Introducing `TestSettings`

To facilitate testing and provide a clean API, we will introduce a single `TestSettings` class to encapsulate all testing-related overrides. This avoids cluttering the `Fframe` constructor with numerous parameters.

**`fframe/lib/models/test_settings.dart` (New File):**

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestSettings {
  final FirebaseAuth? firebaseAuth;
  final FirebaseFirestore? firebaseFirestore;

  const TestSettings({
    this.firebaseAuth,
    this.firebaseFirestore,
  });
}
```

**`fframe/lib/fframe_main.dart` (Modification):**

The `Fframe` widget will be modified to accept the new `TestSettings` object.

```dart
class Fframe extends StatelessWidget {
  // ... existing parameters

  final TestSettings? testSettings;

  const Fframe({
    // ... existing parameters
    this.testSettings,
  });

  @override
  Widget build(BuildContext context) {
    // ...
    // Use the provided instances or default to the real ones
    final auth = testSettings?.firebaseAuth ?? FirebaseAuth.instance;
    final firestore = testSettings?.firebaseFirestore ?? FirebaseFirestore.instance;
    // ...
  }
}
```

### 3.6. Test Output Handling

To maintain a clean workspace and manage potentially large outputs, all test commands must redirect their output to a file within the `llm-scratchspace` directory. This practice prevents token size issues and allows for easier analysis of test results.

After running a test, the resulting output file should be read to analyze the outcome.

**Example:**

```bash
flutter test --platform chrome test/unit/validator_test.dart > ../llm-scratchspace/validator_test_output.txt
```

## 4. Example Tests

### 4.1. Unit Test Example

**`fframe/test/unit/validator_test.dart`:**

```dart
import 'package:test/test.dart';
import 'package:fframe/helpers/validator.dart';

void main() {
  group('Validator', () {
    test('isValidEmail returns true for valid email', () {
      expect(Validator.isValidEmail('test@example.com'), isTrue);
    });

    test('isValidEmail returns false for invalid email', () {
      expect(Validator.isValidEmail('invalid-email'), isFalse);
    });
  });
}
```

### 4.2. Widget Test Example

**`fframe/test/widget/custom_button_test.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/components/custom_button.dart';
import 'package:fframe/fframe.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'test_harness.dart';

void main() {
  testWidgets('CustomButton displays text and responds to taps', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestHarness(
        testSettings: TestSettings(
          firebaseAuth: MockFirebaseAuth(),
        ),
        child: CustomButton(
          text: 'Click Me',
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
    await tester.tap(find.byType(CustomButton));
    await tester.pump();
  });
}
```

### 4.3. Integration Test Example (with Emulators)

**`fframe/test/integration/signin_flow_test.dart`:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fframe/fframe.dart';
import 'package:example/main.dart';
import 'firebase_emulators.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Connect to Firebase emulators before running tests.
    await connectToFirebaseEmulators();
  });

  testWidgets('Sign-in flow with emulators', (WidgetTester tester) async {
    // The app will now talk to the local Firebase emulators.
    await tester.pumpWidget(const MainApp());

    // You can now write tests that interact with the emulated backend.
    // Example: Create a user via the Auth emulator, then sign in.
    final auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: 'test@example.com', password: 'password');
    
    // ... continue with your test flow
  });
}
```

## 5. CI/CD Integration

All tests will be run on every push to the repository using GitHub Actions. A workflow will be created at `.github/workflows/test.yml` to automate this process.

### 5.1. GitHub Actions Workflow

```yaml
name: Test Fframe

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Analyze code
      run: flutter analyze

    - name: Run unit and widget tests
      run: flutter test

    - name: Install Firebase CLI
      run: npm install -g firebase-tools

    - name: Start Firebase Emulators
      # Starts emulators in the background
      # --import=./firebase-data loads pre-existing test data
      run: firebase emulators:start --import=./firebase-data --export-on-exit &

    - name: Wait for Emulators to be ready
      # Uses npx to run wait-on without a separate install step.
      # It polls the specified ports and only continues when they are active.
      run: npx wait-on http://127.0.0.1:8080 && npx wait-on http://127.0.0.1:9099

    - name: Run integration tests (web)
      run: |
        flutter drive \
          --driver=test_driver/integration_test.dart \
          --target=test/integration/signin_flow_test.dart \
          -d chrome --web-renderer html
```

```

# Part II: Testing Your Fframe Application

This guide provides instructions for developers on how to set up a robust testing environment for their own applications built using the `fframe` package.

## 1. Initial Setup

### 1.1. Add Test Dependencies

Add the following packages to the `dev_dependencies` section of your application's `pubspec.yaml` file:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  test:
  integration_test:
  mockito: 
  build_runner:
  # Choose your preferred Firebase testing approach
  firebase_auth_mocks: # For mocking
  fake_cloud_firestore: # For mocking
  http: # For emulators
```

### 1.2. Enable Dependency Injection in `main.dart`

To allow tests to provide mock or emulated Firebase instances, you need to make a small change to your `main.dart` file to accept a `TestSettings` object.

**Before:**

```dart
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Fframe(
      // ... your Fframe config
    );
  }
}
```

**After:**

```dart
import 'package:fframe/fframe.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  final TestSettings? testSettings;

  const MainApp({
    super.key,
    this.testSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Fframe(
      // ... your Fframe config
      testSettings: testSettings,
    );
  }
}
```

## 2. Writing Widget Tests (with Mocks)

Widget tests are ideal for testing individual screens or components in isolation. Using mocks is fast and avoids the need for the Firebase Emulator.

### 2.1. Create a Test Harness

Create a test harness widget in your `test/` directory. This will provide the necessary `Fframe` context to your widget under test.

**`test/harness.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class AppTestHarness extends StatelessWidget {
  final Widget child;
  final TestSettings? testSettings;

  const AppTestHarness({
    Key? key,
    required this.child,
    this.testSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Fframe(
      // Add your app's specific Fframe config here
      title: 'My Test App',
      navigationConfig: NavigationConfig(
        navigationTargets: [ /* your navigation targets */ ],
      ),
      // ... other config
      testSettings: testSettings,
      child: Material(child: child), // Use Material for directionality
    );
  }
}
```

### 2.2. Write a Widget Test

Now you can test your screens by wrapping them in the `AppTestHarness`.

**`test/screens/my_screen_test.dart`:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:fframe/fframe.dart';
import 'package:my_app/screens/my_screen.dart';
import '../harness.dart';

void main() {
  testWidgets('MyScreen shows a list of documents', (WidgetTester tester) async {
    // 1. Setup your mock data
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('my_data').add({'name': 'Test Item'});

    // 2. Pump your widget inside the harness
    await tester.pumpWidget(
      AppTestHarness(
        testSettings: TestSettings(
          firebaseFirestore: firestore,
        ),
        child: MyScreen(),
      ),
    );

    // 3. Verify the results
    await tester.pumpAndSettle(); // Wait for async operations
    expect(find.text('Test Item'), findsOneWidget);
  });
}
```

## 3. Writing Integration Tests (with Emulators)

Integration tests are for testing complete user flows against a high-fidelity Firebase backend.

### 3.1. Setup Firebase Emulators

Follow the instructions in the `fframe` documentation (Part I, Section 3.2.2) to install the Firebase CLI and initialize the emulators in your project's root directory.

### 3.2. Create an Emulator Connector

Create a helper file in your `test/` directory to connect your app to the running emulators.

**`test/firebase_emulators.dart`:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> connectToFirebaseEmulators() async {
  final host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
}
```

### 3.3. Write an Integration Test

Create your integration tests in the `integration_test/` directory.

**`integration_test/app_test.dart`:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart';
import '../test/firebase_emulators.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await connectToFirebaseEmulators();
  });

  testWidgets('Complete sign up and create document flow', (WidgetTester tester) async {
    // 1. Pump your main app widget
    await tester.pumpWidget(const MainApp());

    // 2. Write test steps to simulate user actions
    
    // 3. Verify the results against the emulated backend
  });
}
```

By following this guide, you can build a comprehensive and reliable test suite for your `fframe`-based application.