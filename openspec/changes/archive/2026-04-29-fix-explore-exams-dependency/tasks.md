## 1. core — Add PopularTestDto model

- [x] 1.1 Add `PopularTestDto` and `PopularTestType` to `packages/core/lib/data/models/explore_models.dart`

## 2. core — Extend DataSource interface

- [x] 2.1 Add `getPopularTests()` to `DataSource` abstract class in `data_source.dart`
- [x] 2.2 Implement `getPopularTests()` in `MockDataSource` using inline mock data
- [x] 2.3 Add stub `getPopularTests()` to `HttpDataSource` (returns empty list until API is wired)

## 3. explore — Remove exams dependency

- [x] 3.1 Update `explore_providers.dart` to import `core` instead of `exams`, use `dataSourceProvider.getPopularTests()`
- [x] 3.2 Update `PopularTestDto` type references in explore widgets
- [x] 3.3 Remove `exams:` from `packages/explore/pubspec.yaml`
- [x] 3.4 Run `flutter pub get` in `packages/explore`

## 4. Dissolve Explore package into Courses

- [x] 4.1 Move all files from `packages/explore/lib/` to `packages/courses/lib/`
- [x] 4.2 Update imports in moved files to reflect new paths
- [x] 4.3 Export Explore features from `packages/courses/lib/courses.dart`
- [x] 4.4 Update `packages/testpress/lib/navigation/app_router.dart` to import from `courses`
- [x] 4.5 Remove `explore` dependency from `packages/testpress/pubspec.yaml`
- [x] 4.6 Delete `packages/explore` directory

## 5. Verify

- [x] 5.1 Run `flutter analyze` in `packages/courses` and `packages/testpress`
- [x] 5.2 Verify Explore page works with `USE_MOCK=false` (returns fallback mock data)

