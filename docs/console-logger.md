# Console Logger

The `fframe` package includes a flexible console logger for debugging and monitoring application events.

## Features
- Log messages with different levels: `fframe`, `dev`, `prod`, etc.
- Scope logs to specific features or components.
- Control log verbosity via the `logThreshold`.

## Basic Usage

### 1. Initialize the Logger
Pass a `Console` instance to your `Fframe` app:
```dart
Fframe(
  // ...
  consoleLogger: Console(logThreshold: LogLevel.fframe),
  // ...
)
```

### 2. Logging Messages
```dart
Console.log("A message", scope: "MyFeature", level: LogLevel.dev);
```
- `scope`: (optional) String to categorize the log (e.g., "Auth", "Navigation").
- `level`: (optional) LogLevel to control visibility.

### 3. Log Levels
- `LogLevel.fframe`: Core framework events
- `LogLevel.dev`: Development/debugging
- `LogLevel.prod`: Production-level events

## Best Practices
- Use descriptive scopes for easier filtering.
- Set `logThreshold` to control which messages are shown.
- Remove or lower verbosity of logs before production release.

## Example
```dart
Console.log("User signed in", scope: "Auth", level: LogLevel.prod);
```

## See Also
- `docs/fframe-filestructure.md` for project structure
- `docs/frouter.md` for navigation logging
