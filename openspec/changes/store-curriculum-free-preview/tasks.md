## 1. Localization and Data Model

- [x] 1.1 Add `storeFreePreview` localization string to `packages/core/lib/l10n/`
- [x] 1.2 Unify preview availability in `LessonDto` to a single field `isFreePreview`
- [x] 1.3 Retain `isFreePreview` in `LessonDto.mergeWith` when merging with cached DTO (`isDetailFetched` guard allowing revocation)

## 2. Store Curriculum UI Components

- [x] 2.1 Update `StoreContentTile` with `onPreviewTap` callback and dual badge rendering ("Free Preview" vs "Buy to Unlock")
- [x] 2.2 Ensure accessible touch targets (>= 48dp) and semantic labels on `StoreContentTile`
- [x] 2.3 Propagate `onPreviewTap` callback through `StoreChapterTile` and `ProductExpandableCourseCard`
- [x] 2.4 Adjust padding on `Free Preview` badge in `StoreContentTile` to match the size of `Buy to Unlock`

## 3. Screen Integration and Navigation

- [x] 3.1 Handle `onPreviewTap` in `ProductDetailScreen` to launch preview lesson using `LessonRouter.navigateToLesson`
- [x] 3.2 Support `isPreview` parameter in `LessonRouter.navigateToLesson` forwarding `preview=true` query param
- [x] 3.3 Nullify `onNext` and `onPrevious` in `study_routes.dart` when `preview=true` and `activeLesson.isFreePreview`
- [x] 3.4 Add capability flags (`enableBookmarks`, `enableCompletion`, `enableDownloads`, `enableHelpdesk`) to `LessonDetailOrchestrator`
- [x] 3.5 Pass disabled capability flags in `study_routes.dart` only when `preview=true` and lesson is a free preview
- [x] 3.6 Update `LessonDetailOrchestrator` to bypass locked screen evaluation when `lesson.isFreePreview` is true
- [x] 3.7 Preserve `extraLesson.isFreePreview` in `study_routes.dart` when `lessonDetailProvider` resolves
- [x] 3.8 Forward `enableHelpdesk` to `VideoLessonViewer` and suppress Ask Doubt tab when disabled

## 4. Verification and Tests

- [x] 4.1 Add or update unit tests for `LessonDto` preview logic
- [x] 4.2 Add widget tests for `StoreContentTile` verifying "Free Preview" rendering and tap behavior
- [x] 4.3 Add widget tests for `StoreChapterTile` verifying mixed locked and preview lesson states
- [x] 4.4 Update unit and route tests for `LessonRouter` and `study_routes` preview behavior
- [x] 4.5 Add test coverage in `LessonDetailOrchestrator` and `study_routes` for disabled capabilities in preview mode
- [x] 4.6 Add widget test in `LessonDetailOrchestrator` verifying content viewer renders when `isLocked: true` and `hasFreePreview: true`
- [x] 4.7 Add tests verifying detail DTO without preview flag retains preview state in `mergeWith` and `study_routes.dart`
- [x] 4.8 Add test verifying Ask Doubt tab is hidden in `VideoLessonViewer` when `enableHelpdesk` is false
