## 1. Package Preparation

- [x] 1.1 Update `packages/exams/pubspec.yaml` to include required dependencies (`core`, `data`, `flutter_bloc` if needed, etc.) previously utilized by the screens.
- [x] 1.2 Update `packages/exams/lib/exams.dart` to export the main screens and models that other packages need to consume (like router).

## 2. Models & Data Migration

- [x] 2.1 Move `assessment_model.dart` and `test_model.dart` from `packages/courses/lib/models/` to `packages/exams/lib/models/`.
- [x] 2.2 Move `mock_assessments.dart` and `mock_tests.dart` from `packages/courses/lib/data/` to `packages/exams/lib/data/`.
- [x] 2.3 Fix internal imports within the moved model and data files.

## 3. Widgets Migration

- [x] 3.1 Move the entire `assessment_detail/` directory from `packages/courses/lib/widgets/` to `packages/exams/lib/widgets/`.
- [x] 3.2 Move the entire `test_detail/` directory from `packages/courses/lib/widgets/` to `packages/exams/lib/widgets/`.
- [x] 3.3 Update relative and absolute imports (e.g., from `package:courses` to `package:exams`) within the migrated widgets.

## 4. Screens Migration

- [x] 4.1 Move `assessment_detail_screen.dart` and `test_detail_screen.dart` from `packages/courses/lib/screens/` to `packages/exams/lib/screens/`.
- [x] 4.2 Move the `review_answer/` directory from `packages/courses/lib/screens/` to `packages/exams/lib/screens/`.
- [x] 4.3 Update all imports inside the migrated screens to resolve paths correctly to the new `exams` package.

## 5. Course Package & App Integration Refactoring

- [x] 5.1 Navigate to `packages/testpress/lib/navigation/app_router.dart` and update imports for `test_detail_screen`, `assessment_detail_screen`, and `review_answer_screen` pointing to `package:exams/...`.
- [x] 5.2 Check `packages/testpress/lib/course_list.dart` or other router points and update imports respectively. 
- [x] 5.3 Clean up any remaining broken imports in the `courses` package that references the removed files.
- [x] 5.4 Run `flutter pub get` and fix all `flutter analyze` issues ensuring a successful build without any test logic remaining natively inside `courses`.
