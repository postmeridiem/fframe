# Fframe Testing Strategy

This document outlines the testing strategy for the `fframe` package. Since `fframe` is a UI package with deep dependencies on Firebase, all testing is performed through the `example` application, which acts as a comprehensive test harness.

## 1. Core Principles

- **Test Through the `example` App:** All unit, widget, and integration tests for the `fframe` package are located in and run from the `example/test/` directory. **You must run all test commands from the `example` directory (the root of the example app, where `pubspec.yaml` is present).**
- **Use High-Fidelity Fakes:** For unit and widget tests, always prefer high-fidelity fakes over manual mocks.
  - **`fake_cloud_firestore`:** For tests that interact with Firestore.
  - **`firebase_auth_mocks`:** For tests involving Authentication.
- **Use Emulators for Integration:** The full Firebase Emulator Suite is reserved for integration and end-to-end tests that require testing backend behavior like Security Rules and Cloud Functions.
- **Composability:** Reusable test harnesses are located in `widget/` and `unit/` to simplify test creation.
- **Automation:** All tests are automated and run as part of the CI/CD pipeline.

## 2. Testing Layers

### 2.1. Static Analysis (Linting)

- **Focus:** Catch code style, formatting, and potential errors.
- **Tool:** `flutter analyze`
- **Configuration:** `analysis_options.yaml` in both the `fframe` and `example` package roots.
- **Execution:** This is the first step in the CI pipeline.

### 2.2. Unit Tests

- **Focus:** Test individual classes and functions in isolation.
- **Location:** `example/test/fframe/unit/`
- **Execution Environment:** Due to web-specific dependencies, tests **must** be run in a browser environment. Use the `--platform chrome` flag.

### 2.3. Widget Tests

- **Focus:** Test individual widgets in isolation.
- **Location:** `example/test/fframe/widget/`
- **Execution Environment:** Must also be run in a browser environment using `--platform chrome`.

### 2.4. Integration Tests

- **Focus:** Test end-to-end user flows with the Firebase Emulator Suite.
- **Location:** `example/test/fframe/integration/`

## 3. Test Implementation

### 3.1. Test Dependencies

All test-related dependencies are declared in the `dev_dependencies` section of `pubspec.yaml` in the `example/` directory.

### 3.2. Test Harnesses

- **Unit Test Harness:** `example/test/fframe/unit_test_harness.dart` provides setup functions for tests that rely on `fframe` singletons like `L10n` and `Console`.
- **Widget Test Harness:** `example/test/fframe/widget_test_harness.dart` is a widget that wraps a given test widget with the necessary `Fframe` context and providers.

### 3.3. Running Tests

All tests should be run from the `example` directory (the root of the example app, where `pubspec.yaml` is present).

**Run all tests:**
```bash
flutter test test --platform chrome
```

**Run all widget tests:**
```bash
flutter test test/widget --platform chrome
```

**Run all unit tests:**
```bash
flutter test test/unit --platform chrome
```

**Run a specific test file:**
```bash
flutter test test/unit/validator_test.dart --platform chrome
```

### 3.4. Test Output Handling

To manage potentially large outputs, redirect test command output to a file within the `llm-scratchspace` directory (which should be at the same level as `example/`). Always use an absolute path from the project root.

```bash
flutter test --platform chrome > /absolute/path/to/llm-scratchspace/test_output.txt
``` 