## 1. Network & API Layer

- [x] 1.1 Update `ApiEndpoints` to use v2.3/v2.4 URLs for exams, reviews, and attempts
- [x] 1.2 Update `http_data_source.dart` to use new schemas and clean up legacy parsing debt
- [x] 1.3 Add debounce logic to prevent duplicate HATEOAS calls in the data layer
- [x] 1.4 Fix redundant `contents/` API calls in `ChaptersListPage` by waiting for `chaptersAsync.isLoading` to complete

## 2. Models & State

- [x] 2.1 Update `ExamDto`, `ReviewDto`, `AttemptDto`, and `SectionDto` to match new backend schema
- [x] 2.2 Verify that Riverpod providers (`exam_providers.dart`) handle the new schema and debounce correctly

## 3. UI Component Extraction

- [x] 3.1 Extract `ExamPrescreenMetadata` out of the monolithic body
- [x] 3.2 Extract `ExamPrescreenTopStat`, `ExamPrescreenVerticalStat`, `ExamPrescreenMarkCard`, and `ExamPrescreenTimeline`
- [x] 3.3 Create `AppBottomSheet` for Regular vs Quiz mode selection

## 4. UI Layout & Skeleton Polish

- [x] 4.1 Replace nested `LayoutBuilder` wrappers with a clean `SingleChildScrollView` inside `LessonDetailShell`
- [x] 4.2 Inject realistic proxy strings (`'120'`, `'+1.0 Marks'`) into metadata when `isMetadataLoading` is true
- [x] 4.3 Implement `Skeletonizer.maybeOf(context)?.enabled` to neutralize primary colors during loading
- [x] 4.4 Remove `SkeletonizerConfig` local overrides to inherit global shimmer theme

## 5. Immersive Routing

- [x] 5.1 Remove `CustomTransitionPage(opaque: false)` from `exams_routes.dart`
- [x] 5.2 Remove `CustomTransitionPage(opaque: false)` from `study_routes.dart`
- [x] 5.3 Add `parentNavigatorKey: rootNavigatorKey` to the `testDetail` builder in `study_routes.dart`

## 6. V3 API & State Persistence Refactoring

- [x] 6.1 Remove aggressive timer syncing from `ExamRepository._startHeartbeat` to prevent V3 exams from auto-terminating
- [x] 6.2 Ensure `submitAnswer` in `ExamRepository` preserves the `review` and `result` flags locally across asynchronous network calls
- [x] 6.3 Verify V3 Section Heartbeat independence
- [x] 6.4 Update OpenSpec documentation with the latest architecture decisions
