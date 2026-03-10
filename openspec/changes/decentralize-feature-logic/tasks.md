## 1. Relocate Profile & Settings Logic

- [x] 1.1 Move `settings_providers.dart` from `packages/data/lib/providers/` to `packages/profile/lib/providers/`
- [x] 1.2 Update `packages/profile/lib/profile.dart` to export the relocated providers
- [x] 1.3 Fix internal import paths in the `profile` package
- [x] 1.4 Update global references in the `testpress` aggregator and the `app` package

## 2. Relocate Courses Logic

- [x] 2.1 Move `course_list_provider.dart`, `lesson_providers.dart`, and `study_momentum_provider.dart` from `packages/data/lib/providers/` to `packages/courses/lib/providers/`
- [x] 2.2 Update `packages/courses/lib/courses.dart` to export the relocated providers and models
- [x] 2.3 Move any course-specific repository implementation from `data` package to the `courses` package
- [x] 2.4 Update global references in `testpress` and the `app` package

## 3. Relocate Exams Logic

- [x] 3.1 Move `test_dto.dart` (if internal only) or related repository logic from `data` to `exams` package
- [x] 3.2 Update `packages/exams/lib/exams.dart` to include new exports
- [x] 3.3 Verify no circular dependency between `exams` and `courses` after relocation

## 4. Final Data Package Cleanup

- [x] 4.1 Remove orphaned files from `packages/data/lib/providers/` and `packages/data/lib/repositories/`
- [x] 4.2 Run `flutter pub get` and `build_runner build` in all packages to verify build status
- [x] 4.3 Verify that the app still launches and functionality is intact
