## 1. Preparation & Moving

- [x] 1.1 Create the target dashboard directory in `packages/testpress/lib/screens/dashboard/`.
- [x] 1.2 Relocate `PaidActiveHomeScreen` file from `packages/courses` to `packages/testpress`.
- [x] 1.3 Ensure the `courses` library no longer exports the home screen.

## 2. Integration & Cleaning

- [x] 2.1 Update the project-wide navigation (`app_router.dart`) to point to the new home screen location.
- [x] 2.2 Fix all imports in the relocated `PaidActiveHomeScreen` to use the `package:courses/` syntax.
- [x] 2.3 Verify the dashboard still correctly displays all content (banners, momentum, learners) without domain coupling.

## 3. Deployment Health

- [x] 3.1 Run `flutter analyze` on both the `courses` and `testpress` packages.
- [x] 3.2 Ensure every checkmark in the monorepo is resolution-ready and clean following the relocation.
