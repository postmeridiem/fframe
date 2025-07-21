# Theming and Light/Dark Mode

The `fframe` package supports flexible theming, including light and dark modes, and custom theme configuration.

## Theme Setup

### 1. Define Your Themes
Create `ThemeData` objects for light and dark modes:
```dart
final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  // ... your color and style settings
);

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  // ... your color and style settings
);
```

### 2. Pass Themes to Fframe
```dart
Fframe(
  // ...
  lightMode: appLightTheme,
  darkMode: appDarkTheme,
  themeMode: ThemeMode.system, // or .light / .dark
  // ...
)
```

### 3. Toggling Theme Mode
You can programmatically change the theme mode:
```dart
Fframe.of(context)?.setThemeMode(newThemeMode: ThemeMode.dark);
```

### 4. Persisting User Preference
Use `FframePrefs` to save and load the user's theme preference:
```dart
FframePrefs.setThemeMode(themeMode: ThemeMode.dark);
final mode = await FframePrefs.getThemeMode();
```

## Customizing Themes
Edit your `ThemeData` objects to match your brand and UI needs. You can also extend the theme with custom colors and fonts.

## Best Practices
- Use `ThemeMode.system` for automatic light/dark switching.
- Store user preferences for a consistent experience.

## See Also
- `docs/fframe-filestructure.md` for where to define themes
- Flutter's [ThemeData documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
