## 1. Update Core Data Models

- [x] 1.1 Add `ExamDto? exam` field to `LessonDto` class in `packages/core/lib/data/models/lesson_dto.dart`.
- [x] 1.2 Update `LessonDto.fromJson` (specifically within `_parseExamLesson`) to parse `json['exam']` into the `exam` property using `ExamDto.fromJson`.
- [x] 1.3 Update `copyWith`, `mergeWith`, and `toJson` methods in `LessonDto` to appropriately handle the new `exam` field.

## 2. Refactor Exam Providers and UI

- [x] 2.1 Refactor `TestDetailScreen` in `packages/exams/lib/screens/test_detail_screen.dart` to rely on `lesson.exam` instead of invoking `examDetailProvider(slug)`.
- [x] 2.2 Refactor `ExamPrescreen` in `packages/exams/lib/screens/exam_prescreen.dart` to extract exam metadata directly from `lesson.exam`, entirely removing the dependency on `examDetailAsync`.
- [x] 2.3 Delete `examDetailProvider` completely from `packages/exams/lib/providers/exam_providers.dart`.

## 3. Clean Up Legacy API Routes

- [x] 3.1 Remove `getExamBySlug` from `ExamRepository` in `packages/exams/lib/repositories/exam_repository.dart`.
- [x] 3.2 Remove `getExamDetail` (or equivalent method) from `ExamRemoteDataSource` in `packages/exams/lib/data/data_sources/exam_remote_data_source.dart`.
- [x] 3.3 Remove `examDetail` endpoint string definition from `packages/core/lib/network/api_endpoints.dart`.

## 4. Integration Bug Fixes (Completed)

- [x] 4.1 Update `Lesson` domain model in `packages/courses/lib/models/course_content.dart` to include the `exam` field, preventing data loss during Riverpod provider mapping.
- [x] 4.2 Update `CourseRepository` in `packages/courses/lib/repositories/course_repository.dart` to properly serialize/deserialize `exam` using the `examMetadataJson` Drift column, including fixing `jsonDecode` type casting.
- [x] 4.3 Update `CourseRepository._applyContentStatuses` to correctly map the remote lesson's `hasAttempts` property instead of hardcoding `true`.
- [x] 4.4 Fix frozen UI state in `packages/exams/lib/screens/exam_prescreen.dart` by merging the initial `widget.lesson` with the fresh stream data from `lessonDetailProvider`.
- [x] 4.5 Improve duration string parsing in `ExamPrescreen` to support various fallback formats (e.g. "60 min").
