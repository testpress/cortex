## 1. Setup and Dependencies

- [x] 1.1 Add `skeletonizer` dependency to `packages/core/pubspec.yaml`
- [x] 1.2 Add `skeletonizer` dependency to `packages/courses/pubspec.yaml`
- [x] 1.3 Add `skeletonizer` dependency to `packages/testpress/pubspec.yaml`
- [x] 1.4 Run `flutter pub get` in affected packages

## 2. Provider and Bootstrap Architecture

- [x] 2.1 Add `dashboardBootstrapProvider` to orchestrate initial refresh for hero, learners, and lesson feeds
- [x] 2.2 Update `DashboardRepository.watchHeroBanners()` to stream database values without implicit refresh side effects
- [x] 2.3 Update `DashboardRepository.watchLearners()` to stream database values without implicit refresh side effects
- [x] 2.4 Update lesson feed watchers to stream database values while refresh is orchestrated by bootstrap (`watchWhatsNewFeed`, `watchResumeLearningFeed`, `watchRecentlyCompletedFeed`)
- [x] 2.5 Expose explicit refresh APIs in repository (`refreshHeroBanners`, `refreshLearners`, and feed refresh methods) for bootstrap-driven loading

## 3. UI Skeleton Orchestration

- [x] 3.1 Update `PaidActiveHomeScreen` to drive skeleton visibility from bootstrap loading plus cache presence checks
- [x] 3.2 Update `HeroBannerCarousel` to preserve height and show skeleton when loading with empty data
- [x] 3.3 Update `LessonCardsSectionWidget` to render fixed-count skeleton placeholders during loading
- [x] 3.4 Update `TopLearnersSection` to render skeleton structure during loading
- [x] 3.5 Apply screen-level `SkeletonizerConfig` with `Design` token colors and motion-aware shimmer duration

## 4. Verification

- [x] 4.1 Verify skeletons remain visible on first launch while cache is empty and bootstrap is loading
- [x] 4.2 Verify cached-data path does not regress into full-page skeleton during background refresh
- [x] 4.3 Verify backend empty emissions resolve to stable empty sections after bootstrap completion (no stale skeleton lock)
- [x] 4.4 Verify content swap from skeletons to real data avoids layout pop-in
