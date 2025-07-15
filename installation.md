# Installation Guide

This guide will walk you through setting up a new Flutter project using the `fframe` framework.

## 1. Prerequisites

Before you begin, ensure you have the following installed and configured:

- **Flutter:** Make sure you can create and run a basic Flutter application.
- **Firebase Account:** You need a Firebase account with billing enabled (the Blaze plan is required for using Cloud Functions).
- **Firebase CLI:** Install the Firebase command-line tools.
  ```bash
  npm install -g firebase-tools
  ```
- **Node.js & npm:** Required for deploying Firebase Functions.

## 2. Project Setup

### Step 2.1: Create a New Flutter Project

Start by creating a fresh Flutter project.

```bash
flutter create my_awesome_app
cd my_awesome_app
```

### Step 2.2: Add `fframe` Dependency

Open your `pubspec.yaml` and add `fframe` as a git dependency. Since `fframe` is not yet published on `pub.dev`, you need to reference the GitHub repository directly.

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Add fframe from GitHub
  fframe:
    git:
      url: https://github.com/postmeridiem/fframe.git
      ref: main # Or a specific version tag

  # Add other necessary Firebase packages
  firebase_core: ^...
  firebase_auth: ^...
  cloud_firestore: ^...
```

Run `flutter pub get` to install the packages.

## 3. Firebase Configuration

### Step 3.1: Create a Firebase Project

1.  Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2.  Upgrade your project to the **Blaze (Pay-as-you-go)** plan. This is necessary for deploying the backend Cloud Functions that handle role management.

### Step 3.2: Configure Your Application

1.  Inside your Firebase project, go to **Project Settings** and click **Add app**.
2.  Select the **Flutter** icon and follow the on-screen instructions to connect your Flutter app to Firebase. This will generate a `firebase_options.dart` file in your `lib/` directory.

### Step 3.3: Enable Authentication

1.  In the Firebase Console, go to the **Authentication** section.
2.  Click **Get started** and enable the **Google** sign-in provider.

### Step 3.4: Set up Firestore Database

1.  In the Firebase Console, go to the **Cloud Firestore** section.
2.  Click **Create database** and start in **production mode**. Choose a location for your data.

## 4. Backend Setup (Role Management)

`fframe` comes with a pre-built role management system that runs on Firebase Functions.

### Step 4.1: Configure Backend Files

1.  Copy the `firebase` directory from the `fframe` `example/` project into the root of your own project.
2.  Open `firebase/.firebaserc` and change the `default` project ID to your Firebase project ID.
3.  Open `firebase/functions/src/fframe-auth/config.ts` and update the `authorizedDomains` array to include the domains you will be running your app from (e.g., `your-project-id.web.app`).

### Step 4.2: Deploy Firebase Functions

1.  Navigate to the functions directory and install the dependencies.
    ```bash
    cd firebase/functions
    npm install
    cd ../.. 
    ```
2.  Log in to Firebase using the CLI.
    ```bash
    firebase login
    ```
3.  Deploy all Firebase assets (Firestore rules, functions, and hosting).
    ```bash
    firebase deploy
    ```
    This command will set up the necessary Firestore security rules and deploy the Cloud Function responsible for assigning the initial "SuperUser" role.

## 5. First Run

Here is an example of a `main.dart` file that you can use as a starting point:

```dart
import 'package:example/firebase_options.dart';
import 'package:example/screens/customwidget/navigation.dart';
import 'package:example/screens/swimlanes/swimlanes.dart';

import 'package:flutter/material.dart';

import 'package:fframe/fframe.dart';
import 'package:example/themes/themes.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/pages/empty_page.dart';
import 'package:example/pages/error_page.dart';
import 'package:example/pages/wait_page.dart';

import 'package:example/screens/signInPage/signin_page.dart';
import 'package:example/screens/suggestion/suggestion.dart';
import 'package:example/screens/setting/setting.dart';
import 'package:example/screens/tabloader/tabloader.dart';
import 'package:example/screens/user/user.dart';
import 'package:example/screens/user_profile/user_profile.dart';
import 'package:example/screens/list_grid/list_grid.dart';
import 'package:example/screens/list_grid_single_column_widget/list_grid_single_colum.dart';

import 'package:example/helpers/header_buttons.dart';

void main() {
  // usePathUrlStrategy();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your FlutFrame application.
  @override
  Widget build(BuildContext context) {
    final NavigationConfig navigationConfig = NavigationConfig(
      navigationTargets: [
        suggestionNavigationTarget,
        tabloaderNavigationTarget,
        customNavigationTarget,
        listGridNavigationTarget,
        listGridSingleColumnNavigationTarget,
        swimlanesNavigationTarget,
        usersNavigationTarget,
        settingNavigationTarget,
        userProfileNavigationTarget,
      ],
      signInConfig: SignInConfig(signInTarget: signInPageNavigationTarget),
      errorPage: NavigationTarget(
        path: "",
        title: "error",
        contentPane: const ErrorPage(),
        public: true,
      ),
      emptyPage: NavigationTarget(
        path: "",
        title: "empty",
        contentPane: const EmptyPage(),
        public: true,
      ),
      waitPage: NavigationTarget(
        path: "",
        title: "wait",
        contentPane: const WaitPage(),
        public: true,
      ),
    );

    final L10nConfig l10nConfig = L10nConfig(
      // the default locale your App starts with
      // passed through url string reader here to enable url
      // deeplinking of an l10n locale.
      // You also pass the default Locale here.
      locale: L10nConfig.urlReader(const Locale('en', 'US')),

      // the list of locales that are supported by your app
      supportedLocales: [
        const Locale('en', 'US'), // English, US country code
        const Locale('nl', 'NL'), // Dutch, Netherlands country code
      ],

      // Pass the localizations for flutter and material level
      // widget localizations. Stuff you can't reach otherwise, basically.
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
      ],

      // set the source configuration
      source: L10nSource.assets,

      // define the namespaces that need to be loaded
      namespaces: ['fframe', 'global'],
    );

    return Fframe(
      title: "FlutFrame Demo",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      navigationConfig: navigationConfig,
      lightMode: appLightTheme,
      darkMode: appDarkTheme,
      themeMode: ThemeMode.system,
      l10nConfig: l10nConfig,
      consoleLogger: Console(logThreshold: LogLevel.fframe),
      providerConfigs: [
        // EmailProviderConfiguration(),
        GoogleProvider(
          clientId: "252859371693-n0lhonhub6tosste2ns0a0n4s923du2l.apps.googleusercontent.com",
        ),
      ],
      enableNotficationSystem: true,
      debugShowCheckedModeBanner: false,
      globalActions: const [
        BarButtonShare(),
        BarButtonDuplicate(),
        BarButtonFeedback(),
      ],
      postLoad: (context) async {
        // you can omit this optional event handler
        Console.log("Executing postLoad code from main.dart", scope: "exampleApp.postLoad", level: LogLevel.dev);
      },
      postSignOut: (context) async {
        // you can omit this optional event handler
        Console.log("Executing postSignOut code from main.dart", scope: "exampleApp.postSignOut", level: LogLevel.dev);
      },
      // postSignIn: (
      //   context,
      // ) async {
      //   // These console logs serve as a working example of how to include Console logging in
      //   // your own application. See <TODO add wiki> for more information.

      //   Console.log("Log example for quick usage. these will show up on prod level debug settings, so clean them up");

      //   Console.log(L10n.string("main_demo_l10n", placeholder: "this is a log from the L10n engine (placeholder)"));

      //   Console.log("Executing postSignIn code from main.dart", scope: "exampleApp.postSignIn");

      //   Console.log("Log example fframe level", scope: "exampleApp.postSignIn", level: LogLevel.fframe);

      //   Console.log("Log example dev level", scope: "exampleApp.postSignIn", level: LogLevel.dev);

      //   Console.log("Log example prod level", scope: "exampleApp.postSignIn", level: LogLevel.prod);
      // },
    );
  }
}
```

You are now ready to run the application.

1.  Use the minimal `main.dart` setup from the main `README.md` as a starting point.
2.  Run your app: `flutter run`
3.  Click the **Login** button and sign in with your Google account. The first user to sign in will automatically be granted the `SuperUser` role, which allows them to manage roles for other users within the application.

You should now have a fully functional `fframe` application shell. From here, you can start building out your `NavigationConfig` with your own screens and data.
