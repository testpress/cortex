## 1. Localization and Data Model

- [x] 1.1 Add `storeFreePreview` localization string to `packages/core/lib/l10n/`
- [x] 1.2 Ensure `LessonDto` exposes preview availability (`isFreePreview` / `hasFreePreview`)

## 2. Store Curriculum UI Components

- [x] 2.1 Update `StoreContentTile` with `onPreviewTap` callback and dual badge rendering ("Free Preview" vs "Buy to Unlock")
- [x] 2.2 Ensure accessible touch targets (>= 48dp) and semantic labels on `StoreContentTile`
- [x] 2.3 Propagate `onPreviewTap` callback through `StoreChapterTile` and `ProductExpandableCourseCard`

## 3. Screen Integration and Navigation

- [x] 3.1 Handle `onPreviewTap` in `ProductDetailScreen` to launch preview lesson using `LessonRouter.navigateToLesson`
- [x] 3.2 Support `isPreview` parameter in `LessonRouter.navigateToLesson` forwarding `preview=true` query param
- [x] 3.3 Nullify `onNext` and `onPrevious` in `study_routes.dart` when `preview=true` query param is present
- [x] 3.4 Add capability flags (`enableBookmarks`, `enableCompletion`, `enableDownloads`, `enableHelpdesk`) to `LessonDetailOrchestrator`
- [x] 3.5 Pass disabled capability flags in `study_routes.dart` when `preview=true`

## 4. Verification and Tests

- [x] 4.1 Add or update unit tests for `LessonDto` preview logic
- [x] 4.2 Add widget tests for `StoreContentTile` verifying "Free Preview" rendering and tap behavior
- [x] 4.3 Add widget tests for `StoreChapterTile` verifying mixed locked and preview lesson states
- [x] 4.4 Update unit and route tests for `LessonRouter` and `study_routes` preview behavior
- [x] 4.5 Add test coverage in `LessonDetailOrchestrator` and `study_routes` for disabled capabilities in preview mode
