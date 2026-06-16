## Why

After logout and re-login, courses and exams never load — leaving users staring at an empty screen until they clear the app cache.

**Root cause:** Keep-alive Riverpod list providers (`CourseList`, `ExamList`, `InfoList`) store their initialization status in private fields. Because they survive logout, these fields remain `true` across sessions, skipping data synchronization on subsequent logins.

## What Changes

- Change `CourseList`, `ExamList`, and `InfoList` to `autoDispose` providers. They will automatically be destroyed when their views are unmounted (e.g. on logout).
- Add simple, root-scoped providers to track the last sync timestamp. These watch `authProvider` so they automatically reset to `null` on logout.
- Check the sync timestamp in `initialize()` to prevent redundant API calls during the same session.

## Impact

- **`packages/courses/lib/providers/course_list_provider.dart`** — Convert `CourseList` to `autoDispose` and add `courseSyncMetadataProvider`.
- **`packages/courses/lib/providers/info_providers.dart`** — Convert `InfoList` to `autoDispose` and add `infoSyncMetadataProvider`.
- **`packages/exams/lib/providers/exam_providers.dart`** — Convert `ExamList` to `autoDispose` and add `examSyncMetadataProvider`.
