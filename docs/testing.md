# Fframe Testing Strategy

This document outlines the comprehensive testing strategy for the `fframe` package. Since `fframe` is a UI package with deep Firebase dependencies, all testing is performed through the `example` application, which provides a multi-tier testing architecture with specialized harnesses for different testing scenarios.

## 1. Core Principles

- **Test Through the `example` App:** All unit, widget, and integration tests for the `fframe` package are located in and run from the `example/test/` directory. **You must run all test commands from the `example` directory (the root of the example app, where `pubspec.yaml` is present).**
- **Multi-Tier Testing Architecture:** Three distinct testing approaches for different scenarios:
  - **Fast Unit Tests:** Isolated testing with minimal dependencies
  - **Widget Tests with Fakes:** UI testing with high-fidelity fake Firebase services
  - **Integration Tests with Emulators:** End-to-end testing with realistic Firebase emulators
- **Service Abstraction:** Centralized service factory enables consistent testing across all tiers
- **Harness-Based Testing:** Specialized test harnesses provide appropriate context for each test type
- **Automation Ready:** All tests are designed for CI/CD pipeline integration

## Test File Organization

All test files for the example app must be placed under `example/test/` relative to the project root.

- **Unit tests:** `example/test/unit/` - Isolated testing of individual classes and functions
- **Widget tests:** `example/test/widget/` - UI component testing with fake Firebase services
- **Integration tests:** `example/test/integration/` - End-to-end testing with Firebase emulators
  - **Widget integration:** `example/test/integration/widget/` - Complex async widget testing
  - **Flow integration:** `example/test/integration/flows/` - Complete user flow testing  
  - **Helpers:** `example/test/integration/helpers/` - Shared integration test utilities

When creating, editing, or referencing test files, always use the full path from the project root (e.g., `example/test/widget/my_widget_test.dart`).

**Do not place any test files directly under the project root or outside the `example/test/` directory tree.**

| Test Type      | Correct Path Example                        | Incorrect Path Example         |
|---------------|---------------------------------------------|-------------------------------|
| Unit          | example/test/unit/my_unit_test.dart          | test/unit/my_unit_test.dart   |
| Widget        | example/test/widget/my_widget_test.dart      | test/widget/my_widget_test.dart |
| Widget Integration | example/test/integration/widget/async_widget_test.dart | test/integration/widget/async_widget_test.dart |
| Flow Integration | example/test/integration/flows/user_flow_test.dart | test/integration/flows/user_flow_test.dart |

## 2. Testing Layers

### 2.1. Static Analysis (Linting)

- **Focus:** Catch code style, formatting, and potential errors.
- **Tool:** `flutter analyze`
- **Configuration:** `analysis_options.yaml` in both the `fframe` and `example` package roots.
- **Execution:** This is the first step in the CI pipeline.

### 2.2. Unit Tests

- **Focus:** Test individual classes and functions in isolation with minimal dependencies
- **Location:** `example/test/unit/`
- **Harness:** `UnitTestHarness` - Sets up fframe singletons (L10n, Console) without Firebase
- **Coverage:** 81 tests covering utilities, extensions, services, and configuration models
- **Execution Environment:** Browser environment required (`--platform chrome`)

### 2.3. Widget Tests

- **Focus:** Test UI components in isolation with appropriate context
- **Location:** `example/test/widget/`
- **Harnesses Available:**
  - **`TestHarness`** (Preferred) - Lightweight MaterialApp with L10n/Console setup
  - **`FirebaseFakeHarness`** - Full fake Firebase services for Firebase-dependent widgets
- **Coverage:** 20 tests covering pages, dialogs, buttons, and UI components
- **Execution Environment:** Browser environment required (`--platform chrome`)

### 2.4. Integration Tests

- **Focus:** End-to-end testing with realistic Firebase backends
- **Location:** `example/test/integration/`
- **Structure:**
  - **Flow Integration:** `integration/flows/` - Complete user journeys with service-level testing
  - **Test Helpers:** `integration/helpers/` - Shared utilities (if any)
- **Approach:** Service-level testing using `fframe_test.dart` utilities
- **Note:** Complex widget-based integration tests have been removed due to architectural constraints

## 3. Test Implementation

### 3.1. Test Dependencies

All test-related dependencies are declared in the `dev_dependencies` section of `pubspec.yaml` in the `example/` directory.

### 3.2. Test Harnesses

The testing system provides specialized harnesses for different testing scenarios:

#### 3.2.1. UnitTestHarness (`example/test/unit/unit_test_harness.dart`)
- **Purpose:** Setup for isolated unit tests
- **Features:** Initializes fframe singletons (L10n, Console) without Firebase dependencies
- **Usage:** `setupUnitTests()` function called in unit test setup

#### 3.2.2. TestHarness (`example/test/widget/widget_test_harness.dart`)
- **Purpose:** Lightweight widget testing (Preferred for most widget tests)
- **Features:** MaterialApp with L10n/Console setup, optional Firebase injection
- **Usage:** `TestHarness(child: MyWidget())`
- **Best For:** UI components without Firebase dependencies

#### 3.2.3. FirebaseFakeHarness (`example/test/widget/firebase_fake_harness.dart`)
- **Purpose:** Widget testing with fake Firebase services
- **Features:** High-fidelity fake Firestore and Auth, predictable test data
- **Usage:** `FirebaseFakeHarness(child: MyWidget(), initialFirestoreData: {...})`
- **Best For:** Firebase-dependent widgets requiring controlled data

#### 3.2.4. Direct Firebase Testing with fframe_test.dart
- **Purpose:** Service-level Firebase testing without widget complexity
- **Features:** Uses `createFakeFirestore()`, `createMockAuth()`, `createTestUser()` utilities
- **Usage:** Direct service testing in regular `test()` blocks
- **Best For:** Firebase service operations, authentication flows, data persistence testing

### 3.3. Running Tests

All tests should be run from the `example` directory (the root of the example app, where `pubspec.yaml` is present).

**Run all tests:**
```bash
flutter test test --platform chrome
```

**Run unit tests (fast, 81 tests):**
```bash
flutter test test/unit --platform chrome
```

**Run widget tests (moderate speed, 20 tests):**
```bash
flutter test test/widget --platform chrome
```

**Run integration tests (requires Firebase emulators):**
```bash
# Start Firebase emulators first
firebase emulators:start

# Then run integration tests
flutter test test/integration --platform chrome
```

**Run a specific test file:**
```bash
flutter test test/unit/validator_test.dart --platform chrome
```

**Run tests with coverage:**
```bash
flutter test --coverage --platform chrome
genhtml coverage/lcov.info -o coverage/html
```

### 3.4. Test Output Handling

To manage potentially large outputs, redirect test command output to a file within the `llm-scratchspace` directory (which should be at the same level as `example/`). Always use an absolute path from the project root.

```bash
flutter test --platform chrome > /absolute/path/to/llm-scratchspace/test_output.txt
```

## 4. Testing Best Practices

### 4.1. Choosing the Right Test Harness

| Scenario | Recommended Approach | Reason |
|----------|---------------------|---------|
| Testing utility functions | `UnitTestHarness` | Fast, isolated, no UI needed |
| Testing UI components without Firebase | `TestHarness` | Lightweight, includes L10n/theming |
| Testing Firebase-dependent widgets | `FirebaseFakeHarness` | Controlled fake data, fast execution |
| Testing Firebase service operations | `fframe_test.dart` utilities | Direct service testing, reliable |
| Testing complete user flows | Manual testing or service-level tests | Avoid complex widget integration |

### 4.2. Test Development Workflow

1. **Start with Unit Tests:** Test business logic and utilities first
2. **Add Widget Tests:** Test UI components with appropriate harness
3. **Add Service Tests:** Test Firebase operations with `fframe_test.dart` utilities
4. **Run Linter:** Always run `flutter analyze` after changes
5. **Verify Coverage:** Ensure new features have appropriate test coverage

### 4.3. Async Testing Patterns

For testing async operations with Firebase:

```dart
// Use FirebaseFakeHarness for predictable async testing
testWidgets('should handle async data loading', (tester) async {
  final harness = FirebaseFakeHarness(
    initialFirestoreData: {
      'users/test-user': {'name': 'Test User', 'email': 'test@example.com'}
    },
    child: MyAsyncWidget(),
  );
  
  await tester.pumpWidget(harness);
  await tester.pumpAndSettle(); // Wait for async operations
  
  expect(find.text('Test User'), findsOneWidget);
});
```

### 4.4. Service Testing with fframe_test.dart

```dart
test('should test Firebase service operations', () async {
  final fakeFirestore = createFakeFirestore();
  final mockAuth = createMockAuth(
    signedIn: true,
    mockUser: createTestUser(uid: 'test-user', email: 'test@example.com'),
  );
  
  // Test Firebase operations directly
  await fakeFirestore.collection('test').doc('doc1').set({'field': 'value'});
  final doc = await fakeFirestore.collection('test').doc('doc1').get();
  expect(doc.data()!['field'], equals('value'));
});
```

## 5. Test Architecture Examples

### 5.1. Unit Test Example

```dart
// example/test/unit/my_utility_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'unit_test_harness.dart';

void main() {
  group('MyUtility', () {
    setUp(() {
      setupUnitTests(); // Initialize fframe singletons
    });
    
    test('should perform calculation correctly', () {
      expect(MyUtility.calculate(2, 3), equals(5));
    });
  });
}
```

### 5.2. Widget Test Example

```dart
// example/test/widget/my_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'widget_test_harness.dart';

void main() {
  testWidgets('should render correctly', (tester) async {
    await tester.pumpWidget(
      const TestHarness(child: MyWidget()),
    );
    
    expect(find.byType(MyWidget), findsOneWidget);
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

### 5.3. Service-Level Integration Test Example

```dart
// example/test/integration/flows/firebase_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe_test.dart';

void main() {
  group('Firebase Service Integration', () {
    test('should handle user authentication and data flow', () async {
      final fakeFirestore = createFakeFirestore();
      final mockAuth = createMockAuth(signedIn: false);
      
      // Test authentication flow
      final testUser = createTestUser(uid: 'user-123', email: 'test@example.com');
      await mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password');
      
      // Test data operations
      await fakeFirestore.collection('users').doc('user-123').set({
        'name': 'Test User',
        'email': 'test@example.com'
      });
      
      final userDoc = await fakeFirestore.collection('users').doc('user-123').get();
      expect(userDoc.exists, isTrue);
      expect(userDoc.data()!['name'], equals('Test User'));
    });
  });
}
```

## 6. Firebase Testing Limitations

⚠️ **Important**: Firebase testing has fundamental architectural constraints in this Flutter web setup. For detailed analysis of why Firebase integration testing is challenging and recommended alternatives, see **[Firebase Testing Constraints](testing-constraints.md)**.

**Key limitations:**
- Complex Firebase initialization doesn't work reliably in Flutter test framework
- Widget-based Firebase integration tests have persistent state and timing issues  
- Web platform constraints cause `pumpAndSettle()` timeouts
- Complex test harnesses and service factories were removed due to architectural constraints

**Recommended approach:** Use fake Firebase services for testing, avoid complex Firebase integration tests.

## 7. Troubleshooting

### 7.1. Common Issues

**Test Timeout:** If integration tests timeout, ensure Firebase emulators are running:
```bash
firebase emulators:start
```

**Import Conflicts:** Use prefixed imports for test utilities:
```dart
import '../../widget/firebase_fake_harness.dart' as fake_harness;
```

**Platform Issues:** All tests must run with `--platform chrome` due to web dependencies.

**Dependency Issues:** Use the appropriate fframe import for your test type:
- Use `fframe_test.dart` for Firebase testing with mocks and fakes
- Use `fframe.dart` (full) only when you need complete widget functionality

**Linting Errors:** Always run `flutter analyze` and fix issues before committing:
```bash
flutter analyze
```

### 6.2. Performance Tips

- Use `TestHarness` for simple widget tests (fastest)
- Use `FirebaseFakeHarness` for Firebase widgets (fast with controlled data)
- Reserve `EmulatorTestHarness` for integration tests (slower but realistic)
- Run unit tests frequently during development
- Run integration tests before commits/PRs

## 8. Specialized Fframe Import Libraries

The fframe package provides specialized entry points designed for different testing scenarios to avoid dependency conflicts and platform issues:

### 8.1. Core Libraries

#### `package:fframe/fframe_test.dart`

- **Purpose:** Test-specific utilities with fake Firebase services
- **Use Cases:**
  - Unit tests requiring Firebase mocks
  - Integration tests with controlled data
  - Service-level Firebase testing
- **Exports:**
  - Core Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
  - Core Services: `DatabaseService`, `DocumentConfigCore` 
  - Test utilities: `FakeFirebaseFirestore`, `MockFirebaseAuth`
  - Helper functions: `createFakeFirestore()`, `createMockAuth()`, `createTestUser()`
- **Benefits:** Provides reliable, fast Firebase testing without emulator setup

#### `package:fframe/fframe.dart` (Full Library)

- **Purpose:** Complete fframe functionality for production apps
- **Use Cases:** Production applications, full widget testing
- **Exports:** All fframe components including web-specific dependencies
- **Limitations:** Can cause timing issues in Chrome platform testing due to complex initialization

### 8.2. Import Strategy by Test Type

| Test Type | Recommended Import | Reason |
|-----------|-------------------|---------|
| Unit Tests (with mocks) | `fframe_test.dart` | Includes Firebase fakes and utilities |
| Widget Tests (simple) | `fframe.dart` via TestHarness | Full UI components needed |
| Widget Tests (Firebase) | `fframe_test.dart` | Controlled fake services |
| Integration Tests | `fframe_test.dart` | Service-level testing with controlled data |
| Service Tests | `fframe_test.dart` | Direct Firebase operations with mocks |

### 8.3. Usage Examples

#### Mock Firebase Testing with fframe_test.dart

```dart
import 'package:fframe/fframe_test.dart';

test('should test with fake Firebase services', () async {
  final fakeFirestore = createFakeFirestore();
  final mockAuth = createMockAuth(
    signedIn: true, 
    mockUser: createTestUser(email: 'test@example.com')
  );
  
  // Test with controlled fake data
});
```

## 9. Current Test Coverage

- **Unit Tests:** 101+ tests - utilities, extensions, services, models
- **Widget Tests:** 20 tests - pages, dialogs, buttons, components  
- **Integration Tests:** Infrastructure ready for complex async flows
- **Total:** 121+ tests with comprehensive coverage across all layers

The testing system is production-ready with excellent separation of concerns, specialized import libraries for different testing scenarios, and appropriate harnesses for all testing scenarios.
