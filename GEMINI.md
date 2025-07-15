# Gemini Code Assistant Guidelines

This document outlines the best practices for Git, changelogs, and commit messages to ensure a clean, understandable, and maintainable project history.

## Git Branching Strategy

We follow a simple feature-branching workflow, often referred to as GitHub Flow.

1.  **`main` Branch:**
    *   The `main` branch is the definitive source of truth. It must always be stable and deployable.
    *   Direct commits to `main` are strictly forbidden. All changes must come through a Pull Request.

2.  **Feature Branches:**
    *   Create a new branch from `main` for every new feature, bug fix, or experiment.
    *   Name branches descriptively, using a prefix like `feat/`, `fix/`, or `chore/`.
        *   **Example:** `feat/add-user-authentication`
        *   **Example:** `fix/resolve-login-button-bug`
    *   Branches should be short-lived and focused on a single, atomic change.

3.  **Pull Requests (PRs):**
    *   When your feature or fix is complete, open a Pull Request to merge your branch into `main`.
    *   The PR description should clearly explain the "what" and "why" of the changes.
    *   Ensure all automated checks (CI, tests, linting) pass before requesting a review.
    *   Once the PR is approved and passes all checks, it can be merged into `main`. Delete the feature branch after merging.

## Keeping a Changelog

We adhere to the principles of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

*   The changelog is maintained in a file named `CHANGELOG.md`.
*   Entries are grouped by version, with the most recent version at the top under an `[Unreleased]` section.
*   Changes are categorized under the following headings:
    *   `Added` for new features.
    *   `Changed` for changes in existing functionality.
    *   `Deprecated` for soon-to-be-removed features.
    *   `Removed` for now-removed features.
    *   `Fixed` for any bug fixes.
    *   `Security` in case of vulnerabilities.

## Commit Message Format

We use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. This format creates an explicit and machine-readable commit history.

### Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types

The most common types are:

*   **feat**: A new feature for the user.
*   **fix**: A bug fix for the user.
*   **chore**: Routine tasks, maintenance, or dependency updates. No production code changes.
*   **docs**: Changes to documentation only.
*   **style**: Code style changes that do not affect meaning (whitespace, formatting, etc.).
*   **refactor**: A code change that neither fixes a bug nor adds a feature.
*   **perf**: A code change that improves performance.
*   **test**: Adding missing tests or correcting existing tests.
*   **build**: Changes that affect the build system or external dependencies.
*   **ci**: Changes to our CI configuration files and scripts.

### Examples

**Commit with description and body:**
```
feat(auth): implement social login via Google

Adds an OAuth 2.0 flow for Google authentication. Users can now sign
up and log in using their Google accounts, which streamlines the
onboarding process.
```

**Commit with a breaking change:**
```
refactor(api)!: rename user ID field from 'userId' to 'id'

BREAKING CHANGE: The `userId` field in the `/api/users` endpoint response
has been renamed to `id`. API consumers will need to update their
clients to reflect this change.
```

**Simple fix commit:**
```
fix(ui): correct typo on the settings page
```
