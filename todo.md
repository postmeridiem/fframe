# FFrame Project Tasks

## Subject: Model Refactoring
- [ ] (P1) Refactor all models in `example/lib/models` to decouple them from Firestore. #task-1
  - [ ] Sub-task: Go through all models in `example/lib/models`.
  - [ ] Sub-task: Remove all `import 'package:cloud_firestore/cloud_firestore.dart';`.
  - [ ] Sub-task: Replace Firestore types like `Timestamp` with standard Dart types (e.g., `DateTime`).
  - [ ] Sub-task: Update `fromJson` and `toJson` methods to handle the conversion.

## Subject: Testing
- [ ] (P1) Create a reusable test harness in `example/test` (e.g., `test_harness.dart`). #task-2
  - [ ] Sub-task: Harness should initialize a `FakeCloudFirestore` instance.
  - [ ] Sub-task: Harness should set up `Fframe.config` with the fake Firestore instance.
  - [ ] Sub-task: Harness should mock user authentication using `firebase_auth_mocks`.
  - [ ] Sub-task: Harness should provide helper methods to pre-seed the database with test data.
- [ ] (P2) Write integration tests for CRUD operations and queries. #task-3
  - [ ] Sub-task: Create a new test file, such as `example/test/firestore_integration_test.dart`.
  - [ ] Sub-task: Test fetching a list of documents.
  - [ ] Sub-task: Test creating a new document.
  - [ ] Sub-task: Test updating an existing document.
  - [ ] Sub-task: Test deleting a document.
  - [ ] Sub-task: Test querying and filtering data.

## Subject: Documentation
- [ ] (P3) Update `testing.md` to document the new testing strategy. #task-4
  - [ ] Sub-task: Remove outdated recommendations.
  - [ ] Sub-task: Add a new section explaining testing within the `example` app.
  - [ ] Sub-task: Include a code example of the new test harness.
