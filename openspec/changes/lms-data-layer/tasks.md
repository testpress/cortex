## 1. Package Setup

- [ ] 1.1 Create `packages/data/` Flutter package with `pubspec.yaml` (name: `data`, depends on `flutter`, `drift`, `sqlite3_flutter_libs`, `riverpod_annotation`, `flutter_riverpod`, `path_provider`)
- [ ] 1.2 Add `packages/data` to root `melos.yaml` workspaces and monorepo `pubspec.yaml`
- [ ] 1.3 Add `build_runner`, `drift_dev`, `riverpod_generator` to `dev_dependencies` in `packages/data`
- [ ] 1.4 Create `packages/data/lib/data.dart` barrel export file

## 2. AppConfig

- [ ] 2.1 Create `packages/data/lib/config/app_config.dart` with `useMockData` and `apiBaseUrl` constants using `bool.fromEnvironment` / `String.fromEnvironment`

## 3. Domain DTOs (Data Transfer Objects)

- [ ] 3.1 Create `packages/data/lib/models/course_dto.dart` with fields: `id`, `title`, `subjectColor`, `chapterCount`, `totalDuration`, `progress`, `completedLessons`, `totalLessons`
- [ ] 3.2 Create `packages/data/lib/models/chapter_dto.dart` with fields: `id`, `courseId`, `title`, `lessonCount`, `assessmentCount`
- [ ] 3.3 Create `packages/data/lib/models/lesson_dto.dart` with fields: `id`, `chapterId`, `title`, `type` (video/pdf/assessment/test), `duration`, `progressStatus`, `isLocked`
- [ ] 3.4 Create `packages/data/lib/models/live_class_dto.dart` with fields: `id`, `subject`, `topic`, `time`, `faculty`, `status` (completed/live/upcoming)
- [ ] 3.5 Create `packages/data/lib/models/forum_thread_dto.dart` with fields: `id`, `courseId`, `title`, `description`, `studentName`, `timeAgo`, `replyCount`, `status` (answered/unanswered)
- [ ] 3.6 Create `packages/data/lib/models/user_progress_dto.dart` with fields: `userId`, `lessonId`, `courseId`, `percentComplete`, `lastAccessedAt`

## 4. Drift Database Tables

- [ ] 4.1 Create `packages/data/lib/db/tables/courses_table.dart` (Drift table matching `CourseDto` fields)
- [ ] 4.2 Create `packages/data/lib/db/tables/chapters_table.dart`
- [ ] 4.3 Create `packages/data/lib/db/tables/lessons_table.dart`
- [ ] 4.4 Create `packages/data/lib/db/tables/live_classes_table.dart`
- [ ] 4.5 Create `packages/data/lib/db/tables/forum_threads_table.dart`
- [ ] 4.6 Create `packages/data/lib/db/tables/user_progress_table.dart`
- [ ] 4.7 Create `packages/data/lib/db/app_database.dart` — Drift `@DriftDatabase` class registering all tables with `NativeDatabase(file)` connection
- [ ] 4.8 Run `dart run build_runner build` in `packages/data` to generate `.g.dart` Drift files

## 5. DataSource Interface & Implementations

- [ ] 5.1 Create `packages/data/lib/sources/data_source.dart` — abstract class with methods: `getCourses()`, `getChapters(courseId)`, `getLessons(chapterId)`, `getLiveClasses()`, `getForumThreads(courseId)`, `getUserProgress(userId)`
- [ ] 5.2 Create `packages/data/lib/sources/mock_data_source.dart` — implements `DataSource` with hardcoded JEE/NEET data from the React reference design (min 3 courses, 5 chapters/course, 4+ lessons/chapter, 3 live classes, 5 forum threads)
- [ ] 5.3 Create `packages/data/lib/sources/http_data_source.dart` — stub implementation that throws `UnimplementedError` for all methods (placeholder for future Dio integration)

## 6. Repositories

- [ ] 6.1 Create `packages/data/lib/repositories/course_repository.dart` — `CourseRepository` with `watchCourses()` (Drift stream), `refreshCourses()` (DataSource → Drift write), `watchChapters(courseId)`, `refreshChapters(courseId)`, `watchLessons(chapterId)`, `refreshLessons(chapterId)`
- [ ] 6.2 Create `packages/data/lib/repositories/user_repository.dart` — `UserRepository` with `watchProgress(userId)`, `updateProgress(dto)`
- [ ] 6.3 Create `packages/data/lib/repositories/forum_repository.dart` — `ForumRepository` with `watchThreads(courseId)`, `refreshThreads(courseId)`
- [ ] 6.4 Create `packages/data/lib/repositories/exam_repository.dart` — `ExamRepository` stub (empty streams, returns empty lists — to be populated in `lms-assessment-detail` change)

## 7. Riverpod Providers

- [ ] 7.1 Create `packages/data/lib/providers/database_provider.dart` — `@riverpod` provider that initialises `AppDatabase` with correct file path via `path_provider`
- [ ] 7.2 Create `packages/data/lib/providers/data_source_provider.dart` — `@riverpod` that returns `MockDataSource()` if `AppConfig.useMockData`, else `HttpDataSource()`
- [ ] 7.3 Create `packages/data/lib/providers/repository_providers.dart` — `@riverpod` providers for `CourseRepository`, `UserRepository`, `ForumRepository`, `ExamRepository` each consuming the database and data source providers
- [ ] 7.4 Create `packages/data/lib/providers/course_list_provider.dart` — `@riverpod StreamProvider<List<CourseDto>>` triggering `refreshCourses()` on first watch then watching the Drift stream
- [ ] 7.5 Run `dart run build_runner build` to generate all provider `.g.dart` files

## 8. App Entry Point Wiring

- [ ] 8.1 Wrap `app/lib/main.dart` app root with `ProviderScope` (outermost widget, before `LocalizationProvider` and `DesignProvider`)
- [ ] 8.2 Add `flutter_riverpod` and `data` package dependency to `app/pubspec.yaml`

## 9. Refactor Existing Sample Screen

- [ ] 9.1 Remove hardcoded `MockCourse` data from `packages/courses/lib/screens/course_list_screen.dart`
- [ ] 9.2 Convert `CourseListScreen` to `ConsumerWidget`; read `ref.watch(courseListProvider)` and render with `AsyncValue.when(data:, loading:, error:)`
- [ ] 9.3 Update `CourseCard` to accept `CourseDto` instead of `MockCourse`; remove `MockCourse` model if no longer used
- [ ] 9.4 Add `data` package to `packages/courses/pubspec.yaml` dependencies

## 10. Verification

- [ ] 10.1 Run `flutter analyze` in all affected packages — zero errors
- [ ] 10.2 Run `flutter run` on the sample app — course list should display 3+ courses sourced from `MockDataSource` via Drift
- [ ] 10.3 Add `packages/data` to monorepo CI (run `dart run build_runner build --delete-conflicting-outputs` before test step)
- [ ] 10.4 Manually verify offline scenario: disable network, cold launch app — course list should still render from Drift cache
