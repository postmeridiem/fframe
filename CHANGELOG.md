## [0.1.301] - Unreleased

### Added
- Unit tests for string helpers, auth decorations, prefs, field validators, prompts, icons, and more.
- Widget tests for prompts, profile buttons, and the Fframe widget.
- Widget testing harness and unit test harness for easier test development.
- Local emulator settings for development/testing.
- Project test strategy and manual documentation.
- Linter instructions for post-change code quality.
- Dev dependencies for improved testing and mocking (e.g., mockito, http, web, fake_cloud_firestore).

### Changed
- Moved all tests into the `example` directory to allow full integration and widget testing through the example app.
- Adjusted test strategy to run tests through the example app.
- Improved path and directory finding logic for better test and output handling.
- Changed console log level to better support testing.
- Updated llm instructions and documentation for clarity.

### Fixed
- Fixed linter errors (slug, readme, top-level inference).
- Fixed build context and deprecated code issues.
- Fixed unreachable switch cases and obsolete imports.
- Fixed Apple mobile HTML header and deprecated color usage.

### Removed
- Removed obsolete and unused package imports.

### Other
- Added a placeholder unit test for navigatorNotifier (integration complexity).
- Improved temp file and output handling for LLM workflows.
