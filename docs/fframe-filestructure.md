# File Structure Overview

This document explains the file structure of the `fframe` package and the example app, highlighting the purpose of key directories and files.

## Root Directory
- `fframe/` — The main package source code.
- `example/` — A full-featured example app demonstrating how to use `fframe`.
- `docs/` — Documentation files for various features and concepts.
- `llm-scratchspace/` — Temporary and test output files (always use absolute paths here).

---

## fframe Package Structure (`fframe/`)

- `lib/` — Main Dart source code for the package.
  - `components/` — Reusable UI components (e.g., advanced data tables, auth decorations).
  - `constants/` — Shared constants.
  - `controllers/` — State management controllers (e.g., query, selection).
  - `extensions/` — Dart extension methods for common patterns.
  - `frouter/` — Routing logic and navigation helpers.
  - `helper_widgets/` — Widgets for initialization, dialogs, and localization.
  - `helpers/` — Utility classes (console logger, preferences, icons, etc.).
  - `material/` — Material design-specific widgets.
  - `models/` — Data models (configuration, user, navigation, etc.).
  - `providers/` — Provider setup for state management.
  - `routers/` — Navigation route definitions.
  - `screens/` — Main UI screens (datagrid, document, listgrid, swimlanes, etc.).
  - `services/` — Service classes (database, navigation, etc.).
  - `fframe.dart` — Library entry point, exports all main features.
  - `fframe_main.dart` — Main widget and app initialization logic.

- `assets/` — Fonts and images used by the package.
- `constants/` — Shared constants for the package.

---

## Example App Structure (`example/`)

- `lib/` — Main Dart source code for the example app.
  - `constants/` — App-specific constants (e.g., roles).
  - `helpers/` — Helper functions and widgets for the example app.
  - `models/` — Data models for the example app (e.g., user, settings, suggestions).
  - `pages/` — Simple page widgets (empty, error, wait pages).
  - `screens/` — Main feature screens, organized by feature (custom widgets, list grid, settings, sign-in, suggestions, swimlanes, tabloader, user, user list, user profile).
  - `themes/` — Theme configuration and color definitions.
  - `main.dart` — App entry point, sets up Fframe and navigation.

- `assets/` — Fonts, images, and translations for the example app.
- `test/` — Unit and widget tests for the example app.
- Platform folders (`android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`) — Platform-specific configuration and build files.

---

## Additional Notes
- All temporary files and test outputs should go in `llm-scratchspace/` (see `GEMINI.md`).
- See other docs files for details on routing, theming, localization, and logging.
