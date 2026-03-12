## 1. Setup & Data Layer

- [x] 1.1 Create the new `explore` package structure at `packages/explore`.
- [x] 1.2 Define `ExploreBannerDto`, `StudyTipDto`, and `ShortLessonDto` in `packages/core/lib/data/models`.
- [x] 1.3 Add enhanced mock data for Explore features in `packages/core/lib/data/sources/mock_data.dart`.
- [x] 1.4 Implement discovery methods (e.g., `getBanners`, `getStudyTips`) in `DataSource` and `MockDataSource`.

## 2. Explore UI Foundation

- [x] 2.1 Implement the `ExplorePage` scaffold with a `CustomScrollView` and search bar.
- [x] 2.2 Create the `FeaturedCarousel` widget for hero banners.
- [x] 2.3 Implement the horizontal `QuickAccessFilter` bar.

## 3. Discovery Sections

- [x] 3.1 Implement the `CourseDiscoveryList` widget for Trending/Recommended courses.
- [x] 3.2 Implement the `ShortLessonsSection` widget for micro-learning content.
- [x] 3.3 Create the `PopularTestsSection` widget.

## 4. Educational Content

- [x] 4.1 Implement the `StudyTipsList` widget for the Explore feed.
- [x] 4.2 Create the `StudyTipCard` with categorized tags.
- [x] 4.3 (Removed) Navigation to Detail View (Content is now informational only per updated reqs).
- [x] 4.4 Disable clickability for Study Tip cards and remove the "View All" button.

## 5. Integration

- [x] 5.1 Update the main `AppRouter` to replace the Explore placeholder with the new `ExplorePage`.
- [x] 5.2 Implement search filtering logic within the `ExplorePage`.
- [x] 5.3 Verify scroll position persistence across dashboard sections.
