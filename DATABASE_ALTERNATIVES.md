# Database Alternatives Analysis for fframe

## Purpose

This document evaluates self-hostable database alternatives that could replace Firebase as fframe's backend infrastructure. It covers what would be lost, gained, and what remains stable for each option, along with a recommended abstraction strategy to enable backend flexibility.

---

## 1. Current Architecture Audit

fframe is built entirely on the Firebase ecosystem. The following services are integrated:

| Service | Package | Integration Depth |
|---------|---------|-------------------|
| Cloud Firestore | `cloud_firestore` | **Core** — every screen, model, and service depends on it |
| Firebase Auth | `firebase_auth` | **Core** — guards all DB operations, role-based access via custom claims |
| Firebase UI | `firebase_ui_firestore`, `firebase_ui_auth`, `firebase_ui_oauth_google` | **Core** — `FirestoreQueryBuilder` powers paginated lists |
| Google Sign-In | `google_sign_in` | **Core** — primary auth provider |
| Firebase Storage | `firebase_storage` | **Moderate** — `StorageImage` widget, file uploads |
| Cloud Functions | `cloud_functions` | **Moderate** — role management (`processSignUp`, `addUserRole`, etc.) |
| Firebase Analytics | `firebase_analytics` | **Light** — included in dependencies |

### Critical Firestore Coupling Points

These are the specific integration points that make Firebase deeply embedded in fframe:

#### 1.1 DatabaseService (`lib/services/database_service.dart`)

The generic `DatabaseService<T>` class is the central data access layer. Every method directly uses:
- `FirebaseFirestore.instance` for collection access
- `withConverter<T>()` for type-safe serialization
- `SetOptions(merge: true)` for partial updates
- `AggregateQuerySnapshot` for count queries
- `FirebaseAuth.instance` to guard all operations

Methods: `query()`, `queryCount()`, `documentStream()`, `selectedDocumentStream()`, `documentSnapshot()`, `updateDocument()`, `createDocument()`, `deleteDocument()`, `generateDocId()`, `documentReference()`

#### 1.2 DocumentConfig (`lib/screens/document_screen/models.dart`)

The `DocumentConfig<T>` class requires Firestore-specific function signatures:

```dart
T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
Map<String, Object?> Function(T, SetOptions?) toFirestore;
Query<T> Function(Query<T> query)? query;
```

These types (`DocumentSnapshot`, `SnapshotOptions`, `SetOptions`, `Query<T>`) are all from `cloud_firestore`.

#### 1.3 FirestoreQueryBuilder (`lib/screens/listgrid_screen/listgrid_firestore.dart`)

The `FirestoreListGrid` widget uses `FirestoreQueryBuilder<T>` from `firebase_ui_firestore` for paginated, real-time list rendering with infinite scroll. This widget has no generic equivalent in any alternative SDK.

#### 1.4 Real-time Streams

Throughout the codebase:
- `documentReference.snapshots()` for single-document real-time updates
- `query.snapshots()` for collection-level real-time streams
- Notification system uses `.snapshots()` on user subcollections

#### 1.5 WriteBatch (`lib/helpers/notifications.dart`)

Firestore-specific batch operations with 500-operation limit handling for sending notifications to multiple users.

#### 1.6 Query Type Propagation

Firestore's `Query<T>` class is used as a parameter type across `DocumentConfig`, `DatabaseService`, and all screen widgets (ListGrid, DataGrid, Swimlanes). It carries converter information and is deeply woven through the framework.

#### 1.7 Timestamp Type

Firestore's `Timestamp` type is used in models for notification times, creation dates, and TTL fields.

#### 1.8 Cloud Functions Auth Triggers (`firebase/functions/src/fframe-auth/`)

TypeScript Cloud Functions handle:
- `processSignUp` — auto-assigns roles on user creation via `functions.auth.user().onCreate()`
- `getUserRoles` / `addUserRole` / `removeUserRole` — role management via custom claims
- Domain-based email authorization

#### 1.9 Firestore Security Rules (`firebase/firestore.rules`)

Declarative access control with:
- `isSignedIn()` — auth check
- `matchingUUID()` — user can only access own data
- `isDomainUser()` — email domain-based authorization
- Collection-level read/write/delete rules

#### 1.10 Firebase Package Exports (`lib/fframe.dart`)

The main library file directly exports Firebase packages:
```dart
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';
```

Any consumer of fframe inherits these Firebase dependencies.

---

## 2. Alternative Evaluation

### 2.1 Supabase

**What it is:** Self-hostable BaaS built on PostgreSQL, with GoTrue (auth), Realtime (CDC), Storage (S3-compatible), and Edge Functions (Deno).

#### What you GAIN

- **Full SQL query power** — JOINs, aggregations, window functions, full-text search, CTEs
- **Self-hostable** via Docker (`supabase/supabase` stack)
- **No vendor lock-in** on the database layer — standard PostgreSQL
- **Row Level Security** is more powerful than Firestore rules (arbitrary SQL expressions)
- **PostgREST** auto-generates REST API from schema
- **Realtime subscriptions** via Postgres Change Data Capture
- **Schema migrations** tooling for version-controlled database changes
- **Postgres extensions** ecosystem (PostGIS for geo, pg_cron for scheduling, pgvector for AI embeddings)
- **Mature Flutter SDK** (`supabase_flutter`) with auth, realtime, storage support

#### What you LOSE

- **`FirestoreQueryBuilder` widget** — no Flutter equivalent exists; must build a custom paginated list widget
- **`withConverter<T>()` pattern** — must implement a custom serialization/deserialization layer
- **Offline-first capability** — Firestore has built-in offline persistence and sync; Supabase does not
- **`firebase_ui_firestore` and `firebase_ui_auth` widgets** — pre-built UI components need replacements
- **Document-model flexibility** — PostgreSQL requires schema definition upfront (though JSONB columns offer some flexibility)
- **Custom claims on auth tokens** — Supabase uses JWT with `app_metadata`/`user_metadata` instead
- **Auth triggers** (`onCreate`) — must use Postgres triggers, database webhooks, or Edge Functions instead
- **Schemaless data** — cannot store arbitrary nested documents without JSONB

#### What remains STABLE

- Flutter app shell, routing, navigation (`FRouter`, destinations, navigation config)
- UI layout components (document body, tabs, context cards, header/footer builders)
- State management patterns (`SelectionState`, `ChangeNotifier`, `ListenableBuilder`)
- Business logic in model classes (validation, dirty checking via MD5 fingerprints)
- `preSave`/`preOpen` hooks on `DocumentConfig`
- Swimlane, ListGrid, and DataGrid UI rendering (only the data source changes)
- Notification data model (structure remains, storage mechanism changes)

#### Migration effort: HIGH

Every file touching `Query<T>`, `DocumentSnapshot`, `fromFirestore`/`toFirestore` must be rewritten. The `DatabaseService`, `DocumentConfig`, all screen widgets, and model serialization all need new implementations. Cloud Functions must be ported to Edge Functions.

---

### 2.2 MongoDB

**What it is:** Document database (self-hostable community edition). Optionally with Atlas Device Sync (Realm) for mobile, but that requires Atlas cloud hosting.

#### What you GAIN

- **Same document-model paradigm** as Firestore — easiest conceptual migration
- **Rich query language** — aggregation pipeline, `$regex`, `$lookup` for joins
- **Self-hostable** community edition with no licensing fees
- **Schema-optional** like Firestore — documents can have varying structures
- **Change Streams** for real-time subscriptions on the server side
- **Horizontal scaling** via sharding for large datasets

#### What you LOSE

- **No integrated auth** — must bring your own (Keycloak, Auth0, custom JWT, etc.)
- **No integrated storage** — must add MinIO, S3, or another object store
- **No Cloud Functions equivalent** — must build and host a backend API (Express, Dart Shelf, Fastify, etc.)
- **No security rules** — access control must be implemented in the application/API layer
- **No `FirestoreQueryBuilder`** or any `firebase_ui_*` widget equivalents
- **No client-side real-time sync** — Realm Device Sync requires Atlas (cloud-hosted, not self-hostable); self-hosted MongoDB only has server-side Change Streams
- **No offline persistence** out of the box — requires custom implementation
- **Poor Flutter SDK** — `mongo_dart` requires direct DB connections (exposes credentials); production apps need a REST/GraphQL API layer in between

#### What remains STABLE

- Same as Supabase: Flutter shell, UI components, state management, business logic
- Document-model thinking — `fromFirestore`/`toFirestore` maps naturally to `fromJson`/`toJson`

#### Migration effort: VERY HIGH

Requires building an entire backend API layer, auth system, storage service, and real-time infrastructure that Firebase provides out of the box. The Flutter client would talk to your custom API rather than directly to the database.

---

### 2.3 Appwrite

**What it is:** Self-hosted BaaS with databases (document-based), auth, storage, functions, and realtime — the closest feature-for-feature Firebase alternative.

#### What you GAIN

- **Full BaaS replacement** — closest feature parity to Firebase
- **Self-hostable** via Docker with official docker-compose
- **Dart/Flutter-first SDK** (`appwrite` package) — official, well-maintained
- **Realtime subscriptions** via WebSockets
- **Built-in file storage** with server-side image transformations
- **Functions support Dart runtime** natively — can reuse existing Dart code
- **Team/membership-based permissions** model for access control
- **Document-based data model** — conceptually similar to Firestore collections/documents

#### What you LOSE

- **`FirestoreQueryBuilder`** — no equivalent widget; must build custom pagination
- **Less mature ecosystem** compared to Firebase or Supabase — fewer edge-case solutions
- **Smaller community** — less Stack Overflow coverage, fewer tutorials
- **Query capabilities are more limited** than both Firestore and PostgreSQL (no composite queries, limited operators)
- **No equivalent of Firestore's automatic indexing** — must manage manually
- **Custom claims pattern** — must use Appwrite's teams/labels for role-based access instead
- **No `firebase_ui_*` widgets** — pre-built auth and data UI components need replacements
- **No offline persistence** — no built-in client-side caching/sync

#### What remains STABLE

- Same as above: Flutter shell, UI, state management, business logic, hooks

#### Migration effort: HIGH

Similar scope to Supabase but Appwrite's document model is closer to Firestore's, which may simplify model serialization. Still requires rewriting `DatabaseService`, `DocumentConfig`, all screen widgets, and model serialization.

---

### 2.4 PocketBase

**What it is:** Single-binary Go-based BaaS backed by SQLite, with auth, collections, file storage, and real-time via SSE.

#### What you GAIN

- **Simplest self-hosting** — single binary, no Docker required, zero external dependencies
- **Real-time subscriptions** via Server-Sent Events (SSE)
- **SQLite-backed** — no database server to manage
- **Admin UI** out of the box for collection/schema management
- **API rules** per collection for access control
- **Minimal infrastructure** — can run on a $5/month VPS

#### What you LOSE

- **Not designed for high-scale** — SQLite has concurrent write limitations
- **Limited query capabilities** compared to Postgres/Firestore
- **Small community, primarily single maintainer** — bus factor risk
- **No equivalent of batch writes** with Firestore's transactional guarantees
- **No Dart-native functions runtime** — hooks are Go or JavaScript only
- **No `firebase_ui_*` widget equivalents**
- **No offline persistence**
- **Less polished Flutter SDK** — `pocketbase` is a community package

#### What remains STABLE

- Same as above: Flutter shell, UI, state management, business logic

#### Migration effort: HIGH

Same scope for the Flutter side. Backend deployment is simpler but the platform is more limited in capabilities, which may cause issues as the application scales.

---

## 3. Comparative Matrix

| Capability | Firebase (current) | Supabase | MongoDB | Appwrite | PocketBase |
|---|---|---|---|---|---|
| **Self-hostable** | No | Yes (Docker) | Yes | Yes (Docker) | Yes (single binary) |
| **Document DB model** | Yes | No (relational) | Yes | Yes | No (relational) |
| **Real-time subscriptions** | Native | Postgres CDC | Change Streams* | WebSockets | SSE |
| **Integrated Auth** | Yes | Yes | No | Yes | Yes |
| **Integrated Storage** | Yes | Yes | No | Yes | Yes |
| **Serverless Functions** | Yes | Yes (Deno) | No | Yes (Dart!) | Go/JS hooks |
| **Flutter SDK maturity** | Excellent | Good | Poor (client) | Good | Fair |
| **Offline persistence** | Built-in | No | Realm (cloud only) | No | No |
| **Security rules** | Declarative | RLS (SQL) | None built-in | Permissions | API rules |
| **Query power** | Limited | Full SQL | Aggregation pipeline | Limited | SQL (limited) |
| **Pagination widget** | `FirestoreQueryBuilder` | None | None | None | None |
| **Scale ceiling** | Google-scale | Postgres-scale | Horizontal sharding | Moderate | SQLite limits |
| **Migration effort** | N/A | High | Very High | High | High |

*MongoDB Change Streams are server-side only; client-side sync (Realm) requires Atlas cloud.

---

## 4. Recommended Migration Path: Abstraction Layer Strategy

Rather than a hard swap from Firebase to a single alternative, the recommended approach is to introduce a **database abstraction layer** that allows fframe to support multiple backends. This preserves Firebase as the default while enabling self-hosted alternatives.

### 4.1 Recommended First Alternative: Supabase

Supabase is recommended as the first alternative implementation because:
1. **Best balance** of features, maturity, and self-hostability
2. **Strongest Flutter SDK** among alternatives
3. **PostgreSQL foundation** means no vendor lock-in even on the alternative
4. **Active development** with strong community and corporate backing
5. **Full service coverage** — auth, realtime, storage, and functions in one stack

### 4.2 Abstraction Layer Design

Define abstract interfaces that capture fframe's actual requirements without leaking Firestore types:

#### Core Interfaces

```
FframeDatabase<T>
  - query(collection, fromMap, queryBuilder?, limit?) → FframeQuery<T>
  - queryCount(collection, fromMap, queryBuilder?) → Future<int>
  - documentStream(collection, documentId, fromMap, toMap) → Stream<T?>
  - documentSnapshot(collection, documentId, fromMap, toMap) → Future<T?>
  - updateDocument(collection, documentId, data, fromMap, toMap, merge?) → Future<SaveState>
  - createDocument(collection, documentId, data, fromMap, toMap) → Future<SaveState>
  - deleteDocument(collection, documentId) → Future<SaveState>
  - generateDocId(collection) → String
  - batch() → FframeBatch

FframeAuth
  - currentUser → FframeUser?
  - signIn(provider) → Future<FframeUser>
  - signOut() → Future<void>
  - userStream → Stream<FframeUser?>

FframeStorage
  - getFileUrl(bucket, path) → Future<String>
  - getFileData(bucket, path) → Future<Uint8List>
  - uploadFile(bucket, path, data) → Future<String>

FframeQuery<T>
  - snapshots() → Stream<List<FframeDocument<T>>>
  - get() → Future<List<FframeDocument<T>>>
  - count() → Future<int>
  - where(field, op, value) → FframeQuery<T>
  - orderBy(field, descending?) → FframeQuery<T>
  - limit(count) → FframeQuery<T>
```

#### Model Serialization Change

```dart
// Current (Firestore-coupled)
T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
Map<String, Object?> Function(T, SetOptions?) toFirestore;

// Proposed (generic)
T Function(Map<String, dynamic> data, String documentId) fromMap;
Map<String, Object?> Function(T value) toMap;
```

### 4.3 Files Requiring Modification

| File | Change Description |
|------|-------------------|
| `lib/services/database_service.dart` | Extract `FframeDatabase` interface; rename current impl to `FirestoreDatabaseService` |
| `lib/screens/document_screen/models.dart` | Change `DocumentConfig<T>` to use `fromMap`/`toMap` instead of `fromFirestore`/`toFirestore` |
| `lib/screens/listgrid_screen/listgrid_firestore.dart` | Replace `FirestoreQueryBuilder` with a generic `FframePaginatedQueryBuilder` |
| `lib/screens/datagrid_screen/datagrid_firestore.dart` | Abstract Firestore query usage |
| `lib/screens/swimlanes_screen/swimlanes_firestore.dart` | Abstract aggregate query usage |
| `lib/helpers/notifications.dart` | Abstract `WriteBatch` to `FframeBatch` |
| `lib/helpers/storage_image.dart` | Use `FframeStorage` instead of `FirebaseStorage` directly |
| `lib/helpers/load_extra_data.dart` | Abstract query stream usage |
| `lib/extensions/query.dart` | Move `startsWith` to be backend-specific or generic |
| `lib/fframe.dart` | Remove direct Firebase exports; export abstractions |
| `lib/controllers/selection_state_controller.dart` | Update `SelectedDocument` to use generic types |
| `pubspec.yaml` | Make Firebase packages optional/conditional |
| All model files (`models/*.dart`) | Change `fromFirestore`/`toFirestore` to `fromMap`/`toMap` |

### 4.4 Implementation Steps

1. **Define abstract interfaces** — `FframeDatabase`, `FframeAuth`, `FframeStorage`, `FframeQuery<T>`, `FframeBatch`
2. **Create Firestore implementation** of each interface, wrapping the current code (preserving existing behavior)
3. **Update `DocumentConfig`** to use generic `fromMap`/`toMap` signatures
4. **Update `DatabaseService`** to implement `FframeDatabase` interface
5. **Build generic `FframePaginatedQueryBuilder`** widget to replace `FirestoreQueryBuilder`
6. **Update screen widgets** (ListGrid, DataGrid, Swimlanes) to use abstractions
7. **Add provider/registry pattern** so apps can register their chosen backend at startup
8. **Create Supabase implementation** as the first alternative
9. **Update example app** to demonstrate configuration for both backends

### 4.5 Breaking Changes

This abstraction introduces breaking changes for existing fframe consumers:

- `fromFirestore` / `toFirestore` in model definitions become `fromMap` / `toMap`
- `DocumentConfig` constructor parameters change
- Direct imports of Firebase packages from fframe exports may break
- `Query<T>` parameters become `FframeQuery<T>`

A migration guide should accompany the release.

---

## 5. Conclusion

Firebase provides an excellent developer experience but lacks self-hosting capability. Among the alternatives:

- **Supabase** offers the best balance of features, maturity, and self-hostability
- **Appwrite** is the closest feature-for-feature replacement with native Dart support
- **MongoDB** requires too much custom infrastructure to be practical
- **PocketBase** is the simplest to deploy but has scale limitations

The recommended path is an **abstraction layer** that keeps Firebase as the default while enabling alternatives — starting with Supabase as the first supported self-hosted backend.
