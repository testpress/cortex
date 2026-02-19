## Why

The LMS app requires a production-grade data layer that works offline-first: local data is the single source of truth, the network populates it asynchronously, and the UI reacts automatically via streams. Without this foundation, every subsequent LMS screen would need its own ad-hoc data fetching strategy, making the codebase brittle and hard to swap from mock to real APIs.

## What Changes

- Introduce a new `packages/data` Flutter package containing all data-access logic.
- Define a `DataSource` interface with a `MockDataSource` implementation (all LMS domain data) and an `HttpDataSource` stub for future network integration.
- Integrate **Drift** (SQLite ORM) as the local database with tables for courses, chapters, lessons, live classes, forum threads, and user progress.
- Define a `Repository` base contract and concrete implementations for each domain (`CourseRepository`, `UserRepository`, `ForumRepository`, `ExamRepository`).
- Integrate **Riverpod** as the state management layer; repositories expose `Stream`s that Riverpod watches; UI widgets rebuild only on relevant data changes.
- Add a `AppConfig` singleton controlling `useMockData` flag and `baseApiUrl` for easy switching between mock and real backends.
- Refactor the existing sample `CourseListScreen` and `CourseCard` in `packages/courses` to consume data from `CourseRepository` instead of hardcoded mock objects.

## Capabilities

### New Capabilities

- `data-layer`: Offline-first data access pattern — local DB as single source of truth with async network sync and stream-based UI reactivity.
- `state-management`: Riverpod provider tree wiring repositories to UI; `AsyncValue` handling for loading / error / data states across all screens.
- `mock-data-source`: In-code `MockDataSource` containing all LMS domain data (courses, chapters, lessons, live classes, leaderboard, forum, assessments) ready to be replaced by HTTP calls without touching the UI or repositories.

### Modified Capabilities

- `localization`: No requirement changes. Existing ARB keys extended to cover new LMS domain string keys (course names, chapter labels, status strings) in `app_en.arb`, `app_ar.arb`, `app_ml.arb`.

## Impact

- **New package**: `packages/data/` — pure Dart + Drift + Riverpod; no Flutter UI dependency.
- **Modified packages**: `packages/courses/` — screen and widget data source changes from hardcoded → repository.
- **New dependencies**: `drift`, `sqlite3_flutter_libs`, `riverpod`, `flutter_riverpod`, `riverpod_annotation`, `path_provider`, `dio` (stub only for now).
- **App entry point**: `app/lib/main.dart` wraps root with `ProviderScope`.
- **No breaking changes** to existing design system or localization APIs.
