## 1. Core Component Setup

- [x] 1.1 Implement core `AppWebView` widget to load pages and pass JWT token headers
- [x] 1.2 Add localizations for "My report" in English, Arabic, Malayalam, and Tamil arb files and run `flutter gen-l10n`

## 2. Screen and Navigation Implementation

- [x] 2.1 Add `MyReportScreen` to render reports via `AppWebView`
- [x] 2.2 Configure modern header layout with card-color background, surface soft shadow, and back button matching offline/custom exams
- [x] 2.3 Add `/my-report` route to immersive routes in global navigation

## 3. Dashboard Drawer Integration

- [x] 3.1 Integrate "My report" option into `DashboardDrawer`
- [x] 3.2 Add conditional check on drawer item visibility using `InstituteSettings.disableStudentReport`
