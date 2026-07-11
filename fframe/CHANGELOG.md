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

#### Framework — list grid (`fframe/lib/screens/listgrid_screen`)

* **Fixed crash when sorting a column after clearing the search box** — the range
  filter no longer force-unwraps a null `searchString`.
* **Bounded the `searchAsContains` prefetch** to a hard document limit so a large
  collection is no longer fully loaded into memory (cost/OOM), with a log when the
  cap is hit.
* **Surface prefetch failures** with an error widget instead of an indefinite
  loading spinner.
* **Disposed the notifier, its debounce `Timer`, and the scroll controller** on
  teardown, and guarded async callbacks so they no longer fire after dispose.
* **Reconciled selection on query change** — sorting/searching clears the prior
  selection so the count and bulk actions can't operate on off-screen documents.

#### Framework — swimlanes (`fframe/lib/screens/swimlanes_screen`)

* **Stopped leaking a `SwimlanesNotifier` on every rebuild.** The notifier and
  drag auto-scroll service are now owned by the screen `State` (created once,
  disposed on teardown) and injected into the per-build controller, instead of
  being allocated fresh inside the rebuilt `InheritedModel`.
* **Fixed cross-board state leak / crash.** Persisted scroll and filter state is
  keyed by collection *and* `trackerId`, and a restored filter the current board
  cannot satisfy is coerced to `unfiltered` — boards sharing a collection no
  longer inherit each other's filters or crash on restore.
* **Removed force-unwraps in the filter switch.** Each filter branch null-guards
  its backing config callback (`assignee`/`following`/`getPriority`/`customFilter`)
  instead of `!`, so a mismatched filter skips filtering rather than crashing.

#### Framework — document/selection lifecycle (`fframe/lib/controllers/selection_state_controller.dart`)

* **Fixed document-creation crash** when a `DocumentScreen` has no
  `createDocumentId`: `SelectedDocument.createNew()` no longer force-unwraps the
  optional callback.
* _(New-document stable-id / orphaning was independently fixed upstream via the
  `_savedDocumentId` design and is retained on merge; this branch keeps only the
  `createNew` crash guard above.)_

#### Framework — routing (`fframe/lib/services/target_state.dart`, `fframe/lib/models/router_config.dart`)

* **Bad subtab deep links route to the error page** instead of silently failing:
  the non-existent-tab fallback no longer casts `errorPage` to `NavigationTab`
  (which threw and was swallowed, leaving a stale screen).
* **Signed-out tab filtering un-inverted.** Role-restricted tabs are now hidden
  from unauthenticated users and public tabs are kept, fixing a UI authorization
  gap that exposed role-gated destinations to signed-out visitors.
* _(Naked-root / landing-page resolution was independently fixed upstream by the
  `defaultRoute` rewrite and is retained on merge; this branch's superseded
  one-liner was dropped during the merge.)_

#### Framework — data grid, helpers & input hardening

* **Data grid selection pruned** against each incoming snapshot, so
  `selectedRowCount` and bulk actions no longer reference deleted/filtered-out
  documents (`datagrid_firestore.dart`).
* **`L10n.string` no longer throws** when a key exists without a `translation`
  field — it falls back to the placeholder (`helpers/l10n.dart`).
* **`Query.startsWith` bound fixed for non-BMP characters** (emoji, supplementary
  CJK) by incrementing the full last rune instead of a single UTF-16 code unit,
  with surrogate/overflow guards (`extensions/query.dart`).
* **Slug regex corrected** so `[`, `]`, and quotes are actually stripped
  (`helpers/slug.dart`).
* **Sign-in deep link hardened**: the attacker-controllable `hash` param is
  decoded in a try/catch and a malformed link degrades to the sign-in page
  instead of throwing during build (`fframe_main.dart`).
* **Stopped logging recipient email (PII) at prod level** in the notification
  error path (`helpers/notifications.dart`).

## 0.0.1

* TODO: Describe initial release.
