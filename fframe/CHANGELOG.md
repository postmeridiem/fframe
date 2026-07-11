## Unreleased

### Security & correctness sweep

Fixes for issues surfaced by an automated bug & vulnerability sweep (see
`BUG_AND_VULNERABILITY_REPORT.md`). Findings are addressed in remediation-priority
order across the framework (`fframe/lib`) and the example Firebase configuration
(`example/firebase`).

#### Security — example Firebase configuration

* **Firestore rules rewritten to default-deny.** Removed the `match /{document=**}`
  catch-all that granted every domain user read/write across the entire database
  (cross-user data tampering and framework-config poisoning). Access is now granted
  per collection with owner/admin scoping. Framework config under `fframe/*` is
  client read-only; the `invites` collection is admin-create only with a pinned
  creator and a shape-validated roles payload. Removed the hardcoded personal-email
  allowlist and the unanchored, unescaped email-domain regex — administrative
  access is now derived from server-managed custom claims, not the email string.

## 0.0.1

* TODO: Describe initial release.
