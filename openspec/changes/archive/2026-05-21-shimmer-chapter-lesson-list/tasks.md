## 1. Foundation & Mock Data Setup

- [x] 1.1 Define static mock list `_skeletonChapters` of `ChapterDto` in `chapters_list_page.dart` with realistic titles and content counts.
- [x] 1.2 Define static mock list `_skeletonLessons` of `LessonDto` in `chapters_list_page.dart` for the filtered lists tab loader.
- [x] 1.3 Define static mock list `_skeletonLessons` of `Lesson` in `chapter_detail_page.dart` for the chapter detail loader.

## 2. Chapter List Loading Refactoring

- [x] 2.1 Refactor `ChaptersListPage` initial loading to use `Skeletonizer` wrapping `_skeletonChapters` instead of the centered circular `AppLoadingIndicator`.
- [x] 2.2 Refactor `ChaptersListPage` filtered list loading to use `Skeletonizer` wrapping `_skeletonLessons` instead of the centered circular `AppLoadingIndicator`.
- [x] 2.3 Refactor `ChapterCurriculumItem` to support skeleton behavior, set `onTap` to null when loading, and use the default `Skeletonizer` effect config.
- [x] 2.4 Refactor `LessonListItem` to support skeleton behavior, hide badges or duration when skeletonized, and set `onTap` to null when loading.

## 3. Chapter Detail Loading Refactoring

- [x] 3.1 Refactor `ChapterDetailPage` initial loading to use `Skeletonizer` wrapping `_skeletonLessons` instead of the centered `AppLoadingIndicator`.
- [x] 3.2 Refactor `ChapterContentItem` to support skeleton behavior, set `onTap` to null when loading, and use standard automatic skeletonization without manual bones or skeletons.
- [x] 3.3 Adjust `ChapterContentItem` and `ChapterDetailPage` loading layouts to preserve the white card background and drop shadow of the lesson item cards during skeleton states.
- [x] 3.4 Replace hardcoded `isSkeleton: true` and `enabled: true` flags with dynamic, reactive state variables (`chapterAsync.isLoading`, `_isSyncing`, etc.) across `ChapterDetailPage` and `ChaptersListPage`.
- [x] 3.5 Format chapter metadata to hide assessments count when it is 0, displaying only the lesson count in chapter curriculum lists and detail pages.
- [x] 3.6 Refactor `ChapterCurriculumItem`, `LessonListItem`, and `ChapterContentItem` to use `Skeleton.replace` with a full-size (40x40) replacement bone for the icon/image boxes.
- [x] 3.7 Centralize the icon size constant (40.0) inside `ChapterCurriculumItem`, `LessonListItem`, and `ChapterContentItem` to avoid hardcoding in multiple places.

## 4. Verification & Polish

- [x] 4.1 Build the packages and monorepo to ensure compilation is clean without any type or linter issues.
- [x] 4.2 Validate that the shimmer effect respects light and dark modes and uses correct design token colors.
