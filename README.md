# fframe

## FlutFrame

[![fframe](https://github.com/postmeridiem/fframe/actions/workflows/fframe.yaml/badge.svg?branch=main)](https://github.com/postmeridiem/fframe/actions/workflows/fframe.yaml)

**`fframe` is an opinionated Flutter framework designed to accelerate the development of data-driven applications on top of Firebase.**

It provides a complete, configurable application shell, handling routing, navigation, theming, authentication, and pre-built screens out of the box. This allows you to focus on your core application logic and data models instead of boilerplate infrastructure.

## Key Features

- **Configuration-Driven UI:** Define your entire app layout—navigation destinations, tabs, and pages—with a simple `NavigationConfig` object.
- **Firebase-centric:** Seamless integration with Firebase Authentication and Cloud Firestore. The framework handles initialization and listens for auth state changes automatically.
- **Ready-to-use Screens:** A rich set of pre-built, configurable screens for common use cases:
  - `DocumentScreen`: For CRUD operations on single Firestore documents.
    - `ListGridScreen`: Display Firestore collections in a paginated, filterable data grid.
    - `SwimlanesScreen`: A Kanban-style board for visualizing data stages.
- **Authentication Handled:** Manages the sign-in/sign-out lifecycle, automatically presenting a sign-in UI when needed.
- **Theming & Localization:** Easily configure light/dark themes and provide multi-language support through a simple configuration.
- **Developer-Friendly:** Includes a built-in console logger and a clear structure that promotes clean code separation.

## Getting Started

### Prerequisites

- An existing Flutter project.
- A Firebase project with Authentication and Firestore configured.

### Installation

For detailed installation instructions, please refer to the [installation.md](installation.md) file.

1. **Add the `fframe` package:**
    _Note: `fframe` is not yet on pub.dev. You will need to add it as a git dependency in your `pubspec.yaml`._

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      fframe:
        git:
          url: https://github.com/postmeridiem/fframe.git
          ref: main # or a specific tag/commit
    ```

2. **Initialize `fframe`:**
    Wrap your root `MaterialApp` with the `Fframe` widget in your `lib/main.dart` and provide it with the necessary configurations.

## Usage

Here is a minimal example of how to set up an `fframe` application.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:firebase_core/firebase_core.dart';
// Import your screen builders and configurations

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure to add your own firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Fframe(
      title: "My Awesome App",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      lightMode: ThemeData.light(),
      darkMode: ThemeData.dark(),
      l10nConfig: L10nConfig(
        // Your localization settings
      ),
      consoleLogger: Console(
        // Your logger settings
      ),
      // Define the navigation structure of your application
      navigationConfig: NavigationConfig(
        destinations: [
          // Example: A screen to view a list of customers
          FframeDestination(
            icon: Icons.people,
            label: "Customers",
            path: "customers",
            screenBuilder: (context) => ListGridScreen(
              collection: "customers",
              // ... other listgrid configurations
            ),
          ),
          // Example: A document screen to edit a single customer
          FframeDestination(
            icon: Icons.person,
            label: "Customer",
            path: "customers",
            documentIdKey: "id", // The parameter name in the route
            screenBuilder: (context, documentId) => DocumentScreen(
              collection: "customers",
              documentId: documentId,
              // ... other document screen configurations
            ),
          ),
        ],
      ),
    );
  }
}
```

For a complete, runnable example, please see the `/example` directory in this repository.

## Contributing

Contributions are welcome! If you'd like to contribute, please fork the repository and open a pull request. For major changes, please open an issue first to discuss what you would like to change.

## Filing Issues

If you encounter a bug or have a feature request, please file an issue on the [GitHub issue tracker](TBD_issues_link).

## License

This package is licensed under the [MIT License](LICENSE.md).
