# Cortex Data Flow & Core Runtime Concepts

This guide dives deep into the engineering mechanics of Cortex: how state management works, how memoization prevents redundant computations, why we use scoped singletons instead of global variables, how Drift reactive streams function under the hood, and the exact step-by-step lifecycle of data flowing from a remote API down to UI pixels.

---

## Table of Contents
1. [State Management & Dependency Injection with Riverpod](#1-state-management--dependency-injection-with-riverpod)
2. [Memoization & Caching Mechanics](#2-memoization--caching-mechanics)
3. [Controlled Singletons Without Global Variables](#3-controlled-singletons-without-global-variables)
4. [Reactive Streams in Drift (SQLite)](#4-reactive-streams-in-drift-sqlite)
5. [The End-to-End Data Flow: From API to UI](#5-the-end-to-end-data-flow-from-api-to-ui)
6. [Drift Table Companions Explained](#6-drift-table-companions-explained)
7. [Error Handling & Offline Graceful Degradation](#7-error-handling--offline-graceful-degradation)

---

## 1. State Management & Dependency Injection with Riverpod

In Cortex, **Riverpod** is not just an application state store—it is the central dependency injection (DI) engine and service registry.

### Core Problems Riverpod Solves
1. **Compile-Time Safety**: Traditional Flutter `Provider` or `InheritedWidget` fails at runtime with `ProviderNotFoundException` if an ancestor is missing. Riverpod providers are globally declared top-level variables, making dependency resolution compile-time verified.
2. **Decoupled Architecture**: Widgets do not instantiate repositories, create HTTP clients, or open databases. They simply consume interfaces via `WidgetRef`.
3. **Controlled Lifecycles**: Riverpod manages whether a service lives indefinitely or is destroyed when no longer in use.

### Lifecycles: Auto-Disposed vs. Kept Alive
Riverpod gives us two primary lifecycles:

* **Kept Alive (`keepAlive: true`)**:
  Used for infrastructure singletons that must survive navigation (e.g., SQLite database instance, authenticated user session, network client):
  ```dart
  @Riverpod(keepAlive: true)
  Future<AppDatabase> appDatabase(AppDatabaseRef ref) async {
    return AppDatabase();
  }
  ```
* **Auto-Disposed (Default in `@riverpod`)**:
  Used for feature-specific state (e.g., search filter queries, page pagination, form controllers). When the widget displaying this data unmounts, Riverpod cancels ongoing futures and frees the allocated memory automatically.

---

## 2. Memoization & Caching Mechanics

One of the most powerful features of Riverpod is **memoization**. 

### What is Memoization?
Memoization means caching the result of a function call based on its input parameters and dependencies. If the dependencies have not changed, the function does not re-execute; it immediately returns the cached value.

### How Riverpod Memoizes in Cortex
Consider a provider that computes or watches data:

```dart
@riverpod
Future<UserProfile> userProfile(UserProfileRef ref) async {
  final repo = await ref.watch(userRepositoryProvider.future);
  return repo.fetchProfile();
}
```

1. **First Read**: Widget A calls `ref.watch(userProfileProvider)`. Riverpod executes `fetchProfile()`, stores the resulting `UserProfile` instance in internal memory, and returns it.
2. **Subsequent Reads**: Widget B and Widget C on different parts of the screen also call `ref.watch(userProfileProvider)`. Riverpod does **not** call `fetchProfile()` again. It serves the memoized instance directly from memory.
3. **Dependency Invalidation**: If `userRepositoryProvider` changes, Riverpod marks `userProfileProvider` as dirty, re-runs it, and updates all subscribing widgets.

### Family Providers (Parameterized Memoization)
When data depends on an argument (e.g., fetching a lesson by ID), we use family providers:

```dart
@riverpod
Stream<LessonDto> lessonDetail(LessonDetailRef ref, int lessonId) {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.watchLesson(lessonId);
}
```

Riverpod caches each parameter uniquely:
- Calling `ref.watch(lessonDetailProvider(101))` creates and caches the stream for lesson 101.
- Calling `ref.watch(lessonDetailProvider(102))` creates a separate cache for lesson 102.
- Returning to lesson 101 reuses the existing cached state without re-creating listeners.

### Rebuild Optimization (Equality Checks)
Riverpod optimizes UI performance by checking equality before notifying listeners:
- When a provider yields a new object, Riverpod checks if `newState == oldState`.
- If the values are equal (e.g., identical strings, or immutable classes with overridden `==` / `hashCode`), Riverpod **suppresses the rebuild**, sparing Flutter from recalculating the render tree.

---

## 3. Controlled Singletons Without Global Variables

A common anti-pattern in Flutter applications is using static global singletons:

```dart
// Anti-pattern: Hard to test, prone to memory leaks, cannot be reset
class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
}
```

### Why Static Singletons Cause Bugs
1. **Testing Nightmare**: You cannot swap `AppDatabase.instance` with an in-memory mock during widget tests without hacky static setters.
2. **Logout Bleed**: When a user logs out and a new user logs in, static variables retain the previous user's cached tables unless manually cleared.
3. **Implicit Dependencies**: Classes hiding static calls cannot declare their dependencies transparently in constructors.

### The Cortex Singleton Pattern
In Cortex, singletons are managed by Riverpod providers configured with `keepAlive: true`:

```dart
@Riverpod(keepAlive: true)
Dio dioClient(DioClientRef ref) {
  return Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
}

@Riverpod(keepAlive: true)
Future<AppDatabase> appDatabase(AppDatabaseRef ref) async {
  return AppDatabase();
}
```

### Benefits of Scoped Singletons
1. **Lazy by Default**: The database or network client is not created until the first consumer actually requests it.
2. **Test Overridability**: In test files, any singleton can be replaced in one line:
   ```dart
   testWidgets('renders user profile', (tester) async {
     await tester.pumpWidget(
       ProviderScope(
         overrides: [
           appDatabaseProvider.overrideWithValue(mockDatabase),
         ],
         child: const CortexApp(),
       ),
     );
   });
   ```
3. **Clean Teardown**: Upon logout, calling `ref.invalidate(userStateProvider)` clears the exact branch of the state graph without restarting the app process.

---

## 4. Reactive Streams in Drift (SQLite)

Cortex uses [Drift](https://drift.simonbinder.eu/) as its local SQLite persistence engine. One of Drift's most critical capabilities is **reactive query streaming**.

### `get()` vs. `watch()`
In Drift, every database query can be executed in two ways:

| Method | Return Type | Behavior |
|---|---|---|
| `query.get()` | `Future<List<T>>` | Executes the SQL query once and returns the current snapshot. Does not react to future table changes. |
| `query.watch()` | `Stream<List<T>>` | Executes the SQL query once, then stays open. Emits a new list whenever relevant tables are modified. |

### How Drift Reactive Streams Work Internally

```
1. Repository calls _db.watchCourses()
   │
   ▼
2. Drift registers a Table Subscription for 'courses_table'
   │
   ▼
3. SQL query runs: SELECT * FROM courses_table; (Emits Row Set #1)
   │
   │ ... Later in the background ...
   │
4. Network sync completes -> _db.upsertCourses(...)
   │
   ▼
5. SQLite executes INSERT OR REPLACE INTO courses_table
   │
   ▼
6. Drift Table Update Tracker detects mutation on 'courses_table'
   │
   ▼
7. Drift re-runs the active SELECT query automatically
   │
   ▼
8. Stream emits Row Set #2 to all active UI listeners
```

Because Drift tracks table updates at the SQLite transaction boundary:
- You never need to write manual event buses or callbacks like `eventBus.fire(CourseUpdatedEvent())`.
- If an update occurs in a background isolate or repository method, every screen listening to that table updates automatically and concurrently.

---

## 5. The End-to-End Data Flow: From API to UI

To see all these pieces work together, consider how a screen (such as the Course Catalog or Dashboard) loads and renders data.

```text
User            UI (Screen)          Riverpod Provider      Repository            Drift (SQLite)          DataSource (Dio)
 │                   │                       │                   │                       │                       │
 ├─ 1. Open Screen ─►│                       │                   │                       │                       │
 │                   ├─ 2. watchStream ─────►│                   │                       │                       │
 │                   │                       ├─ 3. watchBanners ►│                       │                       │
 │                   │                       │                   ├─ 4. watchBanners ────►│                       │
 │                   │◄──────────────────────┴───────────────────┴── 5. Emit Cached Rows ┤ (Instant 0ms render)
 │                   │                                                                   │                       │
 │                   │ [Background Network Sync]                                         │                       │
 │                   ├─ 6. refreshDashboard ────────────────────►│                       │                       │
 │                   │                                           ├─ 7. fetchDashboard ──────────────────────────►│
 │                   │                                           │                       │                       │
 │                   │                                           │◄── 8. Return DTO JSON ────────────────────────┤
 │                   │                                           ├─ 9. Transaction: upsertBanners ──────────────►│
 │                   │                                           │                       │                       │
 │                   │                                           │                       ├─ 10. Table Change Detected
 │                   │◄──────────────────────────────────────────┴───────────────────────┴── 11. Auto Emit Fresh ┤
 │                   │ (Smooth UI re-render with fresh data)                                                     │
```

### Detailed Step-by-Step Breakdown

1. **Screen Mounting**: The user navigates to `DashboardScreen`.
2. **Subscribing to Stream**: In `build()`, the widget calls:
   ```dart
   final bannersAsync = ref.watch(heroBannersStreamProvider);
   ```
3. **Instant Cache Emission**: The stream queries local SQLite. If the user previously opened the app, cached rows are already present. The stream yields this list immediately. The UI renders content in **zero milliseconds** with no blank screens or blocking spinners.
4. **Triggering Background Refresh**: The screen calls `refreshDashboard()` in `initState()` or through pull-to-refresh:
   ```dart
   ref.read(dashboardRepositoryProvider).valueOrNull?.refreshDashboard();
   ```
5. **Remote Network Fetch**: The repository invokes `_dataSource.getDashboard()`, which sends an authorized HTTP request using `Dio`.
6. **DTO Deserialization**: The server responds with JSON. Dio and our deserializers parse it into immutable Data Transfer Objects (`DashboardDto`).
7. **Mapping to Companions**: The repository converts the DTOs into Drift table companions:
   ```dart
   final companions = freshDashboard.bannerAds.map((dto) {
     return DashboardBannersTableCompanion(
       id: Value(dto.id),
       title: Value(dto.title),
       imageUrl: Value(dto.imageUrl),
     );
   }).toList();
   ```
8. **Atomic Database Transaction**: The repository writes the companions into the database using a transaction:
   ```dart
   await _db.transaction(() async {
     await _db.upsertDashboardBanners(companions);
   });
   ```
9. **Automatic Stream Notification**: Drift's update manager detects that `dashboard_banners_table` has been modified. It re-evaluates the active `SELECT` query in SQLite and emits the fresh list down the stream.
10. **UI Re-render**: Riverpod's `ref.watch` receives the updated list, detects the change, and triggers a clean rebuild of the banner carousel with zero manual state manipulation.

---

## 6. Drift Table Companions Explained

When updating or inserting data in Drift, you will encounter classes ending in `Companion` (e.g. `CoursesTableCompanion`).

### Why Not Just Use Plain Dart Models?
In SQL, there is a fundamental difference between:
1. **Setting a column to `NULL`** (`UPDATE table SET title = NULL`)
2. **Leaving a column unchanged** (omit `title` from the update statement)
3. **Setting a column to a specific value** (`UPDATE table SET title = 'Physics'`)

A standard Dart object with nullable fields (`String? title`) cannot distinguish between "leave unchanged" and "set to null" because in both cases `title` could be `null`.

### How Companions Solve This with `Value<T>`
Drift companions wrap every field in a `Value<T>` object:
* `Value('Math')`: Update this column with `'Math'`.
* `Value(null)`: Explicitly write `NULL` to this column in SQLite.
* `Value.absent()`: Do not include this column in the SQL statement; keep whatever is currently stored in SQLite.

Example:
```dart
// Inserts a new course or updates only specified fields without wiping others
await _db.into(_db.coursesTable).insertOnConflictUpdate(
  CoursesTableCompanion(
    id: Value(dto.id),
    title: Value(dto.title),
    coverImage: dto.imageUrl != null ? Value(dto.imageUrl!) : const Value.absent(),
  ),
);
```

---

## 7. Error Handling & Offline Graceful Degradation

Because Cortex follows the **Single Source of Truth** pattern, network errors do not break the user experience:

```dart
Future<void> refreshDashboard() async {
  try {
    final freshDashboard = await _dataSource.getDashboard();
    await _db.transaction(() async {
      await _db.upsertDashboardBanners(...);
    });
  } catch (e, stackTrace) {
    // Log exception to Sentry for diagnostics
    SentryService.captureException(e, stackTrace: stackTrace);

    // The method completes without crashing.
    // The UI remains happily mounted, displaying the existing SQLite cache!
  }
}
```

### Key Takeaway for Freshers
- **Never display a blank error screen just because a network request failed.**
- If cached data exists in SQLite, show the cached data and optionally show a subtle toast or banner indicating that the device is offline.
- Only show an error screen if both the network failed AND the local database contains zero records for that view.
