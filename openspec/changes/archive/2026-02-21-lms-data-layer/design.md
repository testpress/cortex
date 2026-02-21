## Context

The Cortex SDK currently has no data persistence layer. The `packages/courses` package uses in-memory hardcoded `MockCourse` objects directly in widgets — approach that won't scale to 30+ LMS screens. The app needs a clean, swappable data layer that works offline and responds automatically when data refreshes from the network.

## Goals / Non-Goals

**Goals:**
- Single source of truth: UI always reads from local DB, never directly from network.
- Stream-based reactivity: Drift tables emit streams; Riverpod watches them; widgets rebuild only when data changes.
- Mock-first: all screens work fully with `MockDataSource` from day 1; switching to HTTP requires changing one flag.
- Offline resilience: when the network is unavailable, cached data serves the last known state without crashing.
- Repository isolation: UI layer never knows or cares whether data comes from mock, HTTP, or cache.

**Non-Goals:**
- Real-time sync (Websockets, Firebase, etc.) — that's a separate concern for Live Class.
- Authentication / token management — deferred to a future `lms-auth` change.
- Background sync scheduling (WorkManager etc.) — manual pull-to-refresh is sufficient for now.

## Decisions

### 1. Local Database: Drift (sqlite_async)

**Decision**: Use **Drift** (formerly Moor) over Hive, Isar, or SharedPreferences.

**Rationale**:
- Drift generates type-safe Dart from SQL table definitions — same mental model as the Dart class definitions already in the project.
- Built-in `Stream<List<T>>` from query watchers — perfect for Riverpod's `StreamProvider`.
- SQLite is the most battle-tested embedded DB on both Android and iOS.
- Drift supports transactions, joins, and migrations cleanly.

**Alternatives considered**:
- **Isar**: faster, but in-memory indexes make offline query patterns harder; API still evolving.
- **Hive**: key-value only, not suitable for relational LMS data (course → chapter → lesson hierarchy).

### 2. State Management: Riverpod (flutter_riverpod + riverpod_annotation)

**Decision**: Use **Riverpod** with code generation (`@riverpod` annotations).

**Rationale**:
- `StreamProvider` composes directly with Drift's query streams — zero boilerplate to bridge DB → UI.
- `AsyncValue` gives a standard loading / error / data pattern for every screen.
- Providers are lazy and ref-counted — no explicit lifecycle management.
- Easy to mock in tests: just override providers in `ProviderScope`.

**Alternatives considered**:
- **BLoC**: more explicit events/states, but considerable boilerplate for a pure reactive data scenario.
- **Provider (v5)**: predecessor of Riverpod, lacks `AsyncValue`, compile-time safety.

### 3. DataSource Strategy: Interface + Injectable Implementations

```
abstract class DataSource {
  Future<List<CourseDto>> getCourses();
  Future<List<ChapterDto>> getChapters(String courseId);
  Stream<UserProgressDto> watchProgress(String userId);
  // ...
}

class MockDataSource implements DataSource { ... }   // all data in-proc
class HttpDataSource implements DataSource { ... }   // Dio → REST API
```

The `Repository` layer composes a `DataSource` with the local Drift DB:
1. On startup / data request: fetch from `DataSource` → write to Drift.
2. UI always watches the Drift `Stream` — gets updated automatically.
3. If `DataSource.fetch` throws (offline), Drift still streams last-persisted data.

**Config flag**:
```dart
// packages/core/lib/config/app_config.dart
class AppConfig {
  static const bool useMockData = bool.fromEnvironment('USE_MOCK', defaultValue: true);
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
}
```

### 4. Package Structure

```
packages/data/
  lib/
    data.dart                     # barrel export
    config/
      app_config.dart
    db/
      app_database.dart           # Drift DB class
      tables/                     # Table definitions
        courses_table.dart
        chapters_table.dart
        lessons_table.dart
        live_classes_table.dart
        forum_threads_table.dart
        user_progress_table.dart
    models/
      course_dto.dart
      chapter_dto.dart
      lesson_dto.dart
      live_class_dto.dart
      forum_thread_dto.dart
      user_progress_dto.dart
    sources/
      data_source.dart            # abstract interface
      mock_data_source.dart       # in-proc mock
      http_data_source.dart       # stub (Dio, empty impls)
    repositories/
      course_repository.dart
      user_repository.dart
      forum_repository.dart
      exam_repository.dart
    providers/
      database_provider.dart
      repository_providers.dart
```

### 5. Existing `packages/courses` Refactor

Replace `MockCourse` data in `CourseListScreen` and `CourseCard` with:
```dart
// Before
final courses = MockCourses.all;

// After (Riverpod consumer)
final coursesAsync = ref.watch(courseListProvider);
```
`CourseListScreen` becomes a `ConsumerWidget`. This validates the full pipeline end-to-end: MockDataSource → Drift → Riverpod → Widget.

## Risks / Trade-offs

- **Drift codegen overhead**: running `dart run build_runner build` is required after schema changes. Mitigation: document in README, add to CI.
- **ProviderScope at root**: wrapping the app in `ProviderScope` means all existing tests must also wrap with it. Mitigation: lightweight; existing tests don't test data layer, so no regression risk.
- **SQLite on desktop/web**: Drift needs `sqlite3_flutter_libs` on mobile and `drift_dev` web support. Mitigation: app targets iOS/Android only for now; skip web.

## Open Questions

- Should `UserProgressDto` track per-lesson progress or per-chapter progress as the primary unit? (Suggest: per-lesson, aggregate at chapter level in repository.)
- Should the `HttpDataSource` stub fail fast (throw `UnimplementedError`) or silently return empty data? (Suggest: throw, so tests catch accidental usage.)
