## Context

`explore_providers.dart` imports `package:exams` solely to call `examRepositoryProvider.getPopularTests()`. All other explore data (banners, study tips, short lessons, discovery courses) already flows through `core`'s shared `DataSource` abstraction. The `TestDto` model needed to display popular tests on the Explore page also lives in `exams`, forcing a cross-package dependency for what is a read-only display concern.

## Goals / Non-Goals

**Goals:**
- Remove `package:exams` from `explore`'s dependency graph
- Move `TestDto` and `TestType` to `core/data/models/explore_models.dart`
- Add `getPopularTests()` to `DataSource` interface
- **Dissolve the `explore` package into the `courses` package**

**Non-Goals:**
- Moving `Test`, `TestQuestion`, or any exam-engine models
- Changing the Explore page UI or behavior

## Decisions

**Consolidate Discovery Features into Courses**
Since Explore is primarily a discovery engine for Courses and Tests, and we want to reduce package overhead, the Explore feature is being moved into `packages/courses`. This follows the repo's pattern of having fewer, thicker domain packages.

**Move `TestDto` + `TestType` to `core`**
`TestDto` is a display DTO. It belongs alongside `ExploreBannerDto` in `core/data/models/explore_models.dart`.

## Risks / Trade-offs

- **Import Updates:** Moving a whole package requires careful updating of imports in the shell (`testpress`) and the moved files.
- **Backward Compatibility:** `exams` now uses `typedef` to point to the new `core` models to avoid breaking exam-engine logic while maintaining the name `TestDto`.

