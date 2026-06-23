## Why

The Exam Prescreen UI suffered from deeply nested layout constraints (fighting `ColoredBox` and `LayoutBuilder` wrappers), making it inflexible and causing visual bugs. Additionally, the skeleton/loading state was broken—placeholder elements shrank to tiny dots instead of maintaining realistic text dimensions—and color themes were improperly hardcoded. Finally, launching tests from the dashboard incorrectly pushed the screen inside the bottom navigation shell instead of full-screen immersive mode.

## What Changes

- **Layout Simplification**: Stripped nested `LayoutBuilder` wrappers in favor of a clean `SingleChildScrollView` inside `LessonDetailShell`.
- **Component Extraction**: Broke the giant monolithic UI into modular, reusable components: `ExamPrescreenMetadata`, `ExamPrescreenTopStat`, `ExamPrescreenVerticalStat`, `ExamPrescreenMarkCard`, and `ExamPrescreenTimeline`.
- **API & Network Optimizations**: 
  - Bumped the Exam, Review, and Attempts API endpoints from `v2.2.1` to `v2.3`/`v2.4`.
  - Recovered technical debt in `http_data_source.dart` by simplifying JSON parsing.
  - Reduced duplicate API calls and updated the debounce logic.
  - Improved the handling of HATEOAS URLs (clearer routing/fetching).
  - Fixed a race condition in `ChaptersListPage` that caused redundant `contents/` API calls when navigating course folders.
- **Immersive Routing**: Replaced the buggy `CustomTransitionPage(opaque: false)` with standard builders and added `parentNavigatorKey: rootNavigatorKey` to ensure tests launch full-screen.
- **Skeleton Enhancements**: Injected realistic dummy strings (`'120'`, `'+1.0 Marks'`) during loading states so bones size correctly.
- **Theme Awareness**: Updated text and icon colors to neutralize to `textSecondary` whenever the `Skeletonizer` is active, and removed localized `SkeletonizerConfig` overrides to inherit the app's global shimmer theme.
- **Mode Selection Extraction**: Moved the "Regular vs Quiz Mode" selection out of the scrolling body and into an elegant on-demand `AppBottomSheet`.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `exam-prescreen-ui`: Refactoring the structural layout, skeleton loading behaviors, and routing configurations of the exam prescreen.

## Impact

- **UI/Layout**: `packages/exams/lib/screens/exam_prescreen.dart` and corresponding newly extracted widgets.
- **Routing**: `packages/testpress/lib/navigation/routes/exams_routes.dart` and `packages/testpress/lib/navigation/routes/study_routes.dart`.
- **Dependencies**: Relies heavily on `LessonDetailShell` and `AppBottomSheet` from the core app architecture.
