## Phase 1: Convert CourseList to autoDispose

- [x] 1.1 Change `@Riverpod(keepAlive: true)` to `@riverpod` on `CourseList` in `packages/courses/lib/providers/course_list_provider.dart`.
- [x] 1.2 Define `courseSyncMetadataProvider` inside `course_list_provider.dart` to track `lastSync` timestamp and watch `authProvider`.
- [x] 1.3 Modify `initialize()` inside `CourseList` to read and update `courseSyncMetadataProvider` instead of the boolean `_wasInitialSyncDone` state.
- [x] 1.4 Run `build_runner` to regenerate `course_list_provider.g.dart` in `packages/courses`.

## Phase 2: Convert ExamList and InfoList to autoDispose

- [x] 2.1 Change `ExamList` in `packages/exams/lib/providers/exam_providers.dart` to `@riverpod`, define `examSyncMetadataProvider`, and update `initialize()`.
- [x] 2.2 Change `InfoList` in `packages/courses/lib/providers/info_providers.dart` to `@riverpod`, define `infoSyncMetadataProvider`, and update `initialize()`.
- [x] 2.3 Run `build_runner` in `packages/exams` and `packages/courses` to generate code.

## Phase 3: Verification

- [x] 3.1 Verify that the application builds and runs successfully.
- [x] 3.2 Run unit tests in `packages/courses` and `packages/exams` to confirm provider behaviors.
- [x] 3.3 Verify manual logout/login flows:
