## 1. Data Layer & Drift Persistence (packages/core)

- [x] 1.1 Add `externalContentLink` and `externalLinkLabel` to `CourseDto` with json serialization.
- [x] 1.2 Add `externalContentLink` and `externalLinkLabel` text columns to `CoursesTable` in Drift schema.
- [x] 1.3 Run `build_runner` to regenerate Drift database code.
- [x] 1.4 Update `AppDatabase` and `CourseRepository` mappers to map `externalContentLink` and `externalLinkLabel` between DTO, DB, and `Course` domain entity.

## 2. Domain Model & Business Helpers (packages/core & packages/courses)

- [x] 2.1 Add helper getters `requiresExternalRegistration` and `enrollmentTitle` to `CourseDto`.
- [x] 2.2 Add unit tests for `CourseDto` parsing and `Course` domain model helper logic.

## 3. Course Card UI & Action Button (packages/courses)

- [x] 3.1 Update `CourseCard` widget to render an action button displaying `externalLinkLabel` when `requiresExternalRegistration` is true.
- [x] 3.2 Hide course progress bar / lesson counts on `CourseCard` when registration is required.
- [x] 3.3 Add widget tests validating the course card rendering in "REQUEST PACKAGE", "Pending Approval", and normal states.

## 4. In-App Registration WebView & Navigation

- [x] 4.1 Create `CourseEnrollmentScreen` to open `externalContentLink` in an authenticated `AppWebView` with header and back button.
- [x] 4.2 Trigger course catalog refresh upon dismissing/exiting `CourseEnrollmentScreen`.
- [x] 4.3 Update `StudyContentList` and course card click handling to navigate to `CourseEnrollmentScreen` for locked courses.
- [x] 4.4 Guard course curriculum routes (`ChaptersListPage`) against unapproved access attempts, redirecting to `CourseEnrollmentScreen`.
- [x] 4.5 Add tests for `CourseEnrollmentScreen` and route guarding.
