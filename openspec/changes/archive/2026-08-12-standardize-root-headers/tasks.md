## 1. Core Widget

- [x] 1.1 Create `SectionHeader` widget in `packages/core/lib/widgets/section_header.dart` with support for `leadingIcon`, `title`, `trailingAction`, and `secondaryContent`

## 2. Refactor Core usages

- [x] 2.1 Refactor `AiScreen` in `packages/core/lib/screens/ai_screen.dart` to use `SectionHeader`

## 3. Refactor Courses usages

- [x] 3.1 Refactor `StudyScreen` in `packages/courses/lib/screens/study_screen.dart` to use `SectionHeader` (passing search bar and filters to `secondaryContent`)
- [x] 3.2 Refactor `InfoPage` in `packages/courses/lib/screens/info/info_page.dart` to use `SectionHeader`
- [x] 3.3 Refactor `StorePage` in `packages/courses/lib/screens/store/store_page.dart` to use `SectionHeader`

## 4. Refactor Exams usages

- [x] 4.1 Refactor `ExamsScreen` in `packages/exams/lib/screens/exams_screen.dart` to use `SectionHeader`

## 5. Refactor Profile usages

- [x] 5.1 Refactor `PaidActiveProfileScreen` in `packages/profile/lib/screens/paid_active_profile_screen.dart` to use `SectionHeader`
- [x] 5.2 Refactor `NotificationsScreen` in `packages/profile/lib/screens/notifications_screen.dart` to use `AppHeader` (and removed subtitles since they are standard pages, not root headers)
- [x] 5.3 Refactor `CertificatesScreen` in `packages/profile/lib/screens/certificates_screen.dart` to use `AppHeader` (and removed subtitles since they are standard pages, not root headers)
