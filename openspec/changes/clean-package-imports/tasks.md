## 1. Top-Level Cleanup (App)

- [x] 1.1 Remove unused import `package:courses/providers/dashboard_providers.dart` in `app/lib/main.dart`

## 2. Package Cleanup (Courses, Exams, Profile)

- [x] 2.1 Remove unused imports in `packages/courses/lib/providers/dashboard_providers.dart`
- [x] 2.2 Resolve redundant `shown` list and imports in `packages/exams/lib/widgets/test_detail/test_question_card.dart`
- [x] 2.3 Cleanup unused and redundant imports in `packages/profile/lib/providers/profile_providers.dart` and `packages/profile/lib/data/profile_mock_data.dart`

## 3. Redundant Widget Imports Cleanup

- [x] 3.1 Resolve unnecessary `material.dart` vs `widgets.dart` imports in `packages/exams` widgets
- [x] 3.2 Resolve unnecessary `material.dart` vs `widgets.dart` imports in `packages/profile/test` files

## 4. Navigation & Router Cleanup

- [x] 4.1 Remove redundant `package:data/data.dart` import and underscore fixes in `packages/testpress/lib/navigation/app_router.dart`

## 5. Final Verification

- [x] 5.1 Run project-wide `dart analyze` to ensure zero import warnings
