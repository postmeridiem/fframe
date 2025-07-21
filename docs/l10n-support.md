# Localization (l10n) Support

The `fframe` package provides built-in support for localization (l10n), making it easy to build multilingual apps.

## Key Concepts
- **L10nConfig**: Central configuration for supported locales, default locale, and translation sources.
- **L10nSource**: Where translations are loaded from (e.g., assets).
- **Namespaces**: Organize translation keys by feature or domain.

## Basic Setup

### 1. Define L10nConfig
```dart
final L10nConfig l10nConfig = L10nConfig(
  locale: L10nConfig.urlReader(const Locale('en', 'US')),
  supportedLocales: [
    const Locale('en', 'US'),
    const Locale('nl', 'NL'),
  ],
  source: L10nSource.assets,
  namespaces: ['fframe', 'global'],
);
```

### 2. Pass L10nConfig to Fframe
```dart
Fframe(
  // ...
  l10nConfig: l10nConfig,
  // ...
)
```

### 3. Using Translations in Code
```dart
Text(L10n.string('welcome_message'));
```
You can also use interpolation and namespaces:
```dart
L10n.string('greeting', namespace: 'global', placeholder: 'Hello!');
```

## Best Practices
- Organize translations by namespace for clarity.
- Always provide a fallback/default locale.
- Keep translation files in `assets/translations/`.

## See Also
- `docs/fframe-filestructure.md` for file locations
- Flutter's [localization documentation](https://docs.flutter.dev/accessibility-and-localization/internationalization)
