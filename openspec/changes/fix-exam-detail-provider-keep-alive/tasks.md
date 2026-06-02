## 1. Drift Table Update (core package)

- [x] 1.1 In `packages/core/lib/data/db/tables/lessons_table.dart`, add `TextColumn get examMetadataJson => text().nullable()();`
- [x] 1.2 In `app_database.dart`, add `updateLessonExamMetadata(String slug, String json)` method
- [x] 1.3 In `app_database.dart`, add `watchLessonExamMetadataBySlug(String slug)` method
- [x] 1.4 Increment `schemaVersion` in `AppDatabase` by 1
- [x] 1.5 Run `dart run build_runner build --delete-conflicting-outputs` in `packages/core` to regenerate `app_database.g.dart`

## 2. Provider Rewrite (exams package)

- [x] 2.1 Revert `examDetail` annotation back to `@riverpod` (remove the `keepAlive: true` added earlier — the notifier will own keepAlive)
- [x] 2.2 Replace the `examDetail` function-based provider with a `@Riverpod(keepAlive: true)` `AsyncNotifier` class `ExamDetail` that implements SWR:
  - In `build(String slug)`: read cached row from DB via `watchExamMetadata(slug)`; if found, set state immediately from `ExamDto.fromJson`
  - After emitting cache: trigger background network fetch (`unawaited`)
  - On network success: compare slug+fields; if changed, call `upsertExamMetadata` — the DB watch stream updates state automatically
  - On network failure with cache present: silently swallow error (keep showing cached data)
  - On network failure with no cache: set state to `AsyncError`
- [x] 2.3 Run `dart run build_runner build --delete-conflicting-outputs` in `packages/exams` to regenerate `exam_providers.g.dart`
- [x] 2.4 Verify `ExamDetailProvider` in the generated file extends `FutureProvider` (not `AutoDisposeFutureProvider`)

## 3. Verification

- [x] 3.1 Hot-restart the app, open an exam prescreen for the first time — confirm shimmer appears while loading
- [x] 3.2 Close and reopen the same exam — confirm no shimmer (in-session cache)
- [x] 3.3 Kill the app, reopen, navigate to the same exam — confirm no shimmer (DB cache)
- [x] 3.4 Confirm app compiles cleanly with no Drift or Riverpod errors
