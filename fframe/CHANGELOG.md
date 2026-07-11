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

#### Security — production Cloud Functions (`functions/src/fframe-auth/auth.ts`)

* **Blocked SuperAdmin privilege escalation.** `addUserRole`/`removeUserRole` now
  only allow a superadmin to grant or revoke privileged/management roles; a
  delegated `useradmin`/`rolemanager` can no longer mint a superadmin they control.
* **Fixed IDOR in `getUserRoles`.** Non-managers are pinned to their own uid;
  only managers may read another user's roles (previously any authenticated user
  could read anyone's roles via a caller-supplied uid).
* **Stopped internal error-detail disclosure.** Callables no longer echo raw
  exception text (a user-existence oracle); errors are logged server-side and a
  generic message is returned, and genuine `permission-denied` errors are no
  longer masked as `invalid-argument`.
* **Awaited the Firestore mirror writes** so role changes no longer silently
  diverge between custom claims and the `users/{uid}` document.
* **Validated `uid`/`role` inputs** (non-empty strings) before any lookup or write.
* **Deterministic first-admin bootstrap** via a Firestore transaction, replacing
  the racy `listUsers(2).length == 1` check that could mint two SuperAdmins (or
  none).

#### Security — dev Cloud Functions (`dev/functions/src/auth/*`)

* **`createUser` invite trigger hardened.** Requested roles are now validated as
  a string array, privileged/management roles are stripped unless the invite's
  (rules-pinned) creator is a superadmin, and the function no longer deletes an
  existing auth account for the invited email — closing a privilege-escalation
  and account-takeover path where any invite writer could provision a SuperAdmin
  or wipe a victim's account.
* **`addUserRole`/`removeUserRole`** now restrict privileged-role grant/revoke to
  superadmins, validate inputs, await the mirror write, and return generic errors.
* **`getUserRoles`** pins non-managers to their own uid (fixes IDOR) and returns
  a generic error on failure.

## 0.0.1

* TODO: Describe initial release.
