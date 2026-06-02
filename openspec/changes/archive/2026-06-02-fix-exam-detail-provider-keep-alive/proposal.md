## Why

Each time a user opens the exam entry bottom sheet (`ExamPrescreen`), the `examDetailProvider` re-fetches exam metadata from the network and shows a shimmer — even if the data was already loaded moments ago. This is caused by Riverpod's `AutoDispose` disposing the provider when the sheet closes. Additionally, even after a cold start the user always sees a loading shimmer, since there is no persistent cache.

The fix implements **Stale-While-Revalidate (SWR)**: show the last-known data from the local Drift database instantly, while silently fetching fresh data in the background. If the server returns updated metadata, the UI refreshes automatically with no shimmer.

## What Changes

- Add an `examMetadataJson` column to the existing `LessonsTable` in the Drift database (`packages/core`) to persist exam metadata keyed by slug.
- Add `updateLessonExamMetadata` and `watchLessonExamMetadataBySlug` methods to `AppDatabase`.
- Increment the Drift `schemaVersion`.
- Rewrite `examDetailProvider` as a `keepAlive: true` `AsyncNotifier` that implements SWR: emit cached DB row first, then refetch from network and update the DB silently.
- Regenerate all affected `.g.dart` files.

## Capabilities

### New Capabilities

### Modified Capabilities
- `exam-attendance-flow`: The exam prescreen implements SWR — metadata is shown instantly from local cache after the first load, while a background refresh keeps the data up to date. No shimmer is shown on repeat opens within a session or after an app restart (once cached).

## Impact

- **`packages/core/lib/data/db/tables/lessons_table.dart`** — Added `examMetadataJson` column.
- **`packages/core/lib/data/db/app_database.dart`** — Add `updateLessonExamMetadata`, `watchLessonExamMetadataBySlug`, increment `schemaVersion`.
- **`packages/core/lib/data/db/app_database.g.dart`** — Regenerated.
- **`packages/exams/lib/providers/exam_providers.dart`** — `examDetailProvider` rewritten as `keepAlive: true` `AsyncNotifier` with SWR logic.
- **`packages/exams/lib/providers/exam_providers.g.dart`** — Regenerated.
- No API changes. No breaking changes to consumers — provider still exposes `AsyncValue<ExamDto>`.
