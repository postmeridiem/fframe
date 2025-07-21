# FRouter: Navigation and Routing

The FRouter is the navigation system used in the `fframe` package. It enables declarative, role-based, and tabbed navigation throughout your application.

## Key Concepts
- **NavigationTarget**: Represents a route/page in your app. Can be a single page or a tabbed group.
- **NavigationConfig**: Defines all navigation targets, sign-in, error, and wait pages.
- **FRouter**: The main router widget, used to navigate between targets and manage navigation state.

## Basic Usage

### 1. Define Navigation Targets
```dart
final NavigationTarget suggestionNavigationTarget = NavigationTarget(
  path: "/suggestions",
  title: "Suggestions",
  contentPane: SuggestionScreen(),
  public: false,
);
```

### 2. Configure Navigation
```dart
final NavigationConfig navigationConfig = NavigationConfig(
  navigationTargets: [
    suggestionNavigationTarget,
    // ... other targets
  ],
  signInConfig: SignInConfig(signInTarget: signInPageNavigationTarget),
  errorPage: NavigationTarget(
    path: "",
    title: "error",
    contentPane: const ErrorPage(),
    public: true,
  ),
  // ...
);
```

### 3. Initialize Fframe with Navigation
```dart
return Fframe(
  title: "My App",
  navigationConfig: navigationConfig,
  // ... other config
);
```

### 4. Navigating Programmatically
Use the FRouter to navigate to a target:
```dart
FRouter.of(context).navigateTo(navigationTarget: suggestionNavigationTarget);
```
You can also pass query parameters:
```dart
FRouter.of(context).navigateTo(
  navigationTarget: suggestionNavigationTarget,
  queryParameters: {"id": "123"},
);
```

## Tabs and Nested Navigation
If a `NavigationTarget` has `navigationTabs`, FRouter will render a tabbed interface. Each tab is a `NavigationTab` with its own content.

## Role-Based Access
You can restrict access to navigation targets by specifying `roles` in the `NavigationTarget`.

## Error and Wait Pages
Configure global error and wait pages in `NavigationConfig` for consistent fallback UI.

## See Also
- `docs/fframe-filestructure.md` for project structure
- `docs/console-logger.md` for logging navigation events
