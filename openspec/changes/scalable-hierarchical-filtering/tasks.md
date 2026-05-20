## 1. Database Schema (Core)

- [x] 1.1 Add `courseId` column to `LessonsTable` in `packages/core/lib/data/db/tables/lessons_table.dart`.
- [x] 1.2 Add `ancestorChapterIds` (Text) column to `LessonsTable`.
- [x] 1.3 Update `AppDatabase` (Version 19) to add the new columns with `addColumnSafely`.
- [x] 1.4 Add `AppDatabase` helper methods for querying lessons using `WHERE course_id = ?` and `WHERE ancestor_chapter_ids LIKE '%,id,%'`.

## 2. Repository & Sync (Courses)

- [x] 2.1 Update `LessonDto` and `rowToLessonDto` mapping to include `courseId` and `ancestorChapterIds`.
- [x] 2.2 Refactor `CurriculumParser` to track the parent chain (Ancestry Stack) during heterogeneous parsing.
- [x] 2.3 Update `CourseRepository.refreshCourseContents` to persist `courseId` and `ancestorChapterIds` for all discovered lessons.
- [x] 2.4 Implement "Progressive Enrichment" in `CourseRepository.refreshChapters` to update ancestors as hierarchy links are discovered.
- [x] 2.5 Implement `CourseRepository.watchFilteredLessonsLocal` using a `LEFT OUTER JOIN` on `chaptersTable` to fetch local `chapterTitle`.
- [x] 2.6 Implement `_getApiComaptibleType` in `CourseRepository` for internal-to-backend API parameter translation (`test` -> `exams`).

## 3. Filtering Logic (Courses)

- [x] 3.1 Refactor `allLessonsProvider` (or equivalent) in `StudyContentList` to use a flat `courseId` query for instant home screen filtering.
- [x] 3.2 Update `ChapterDetailPage` to use the `ancestorChapterIds` LIKE query for fetching all nested sub-contents.
- [x] 3.3 Implement the "Scoped API Fallback" logic in `http_data_source.dart` to fetch missing filtered content for unvisited chapters.
- [x] 3.4 Implement Stream Backpressure Pagination in `ChaptersListPage` using `ScrollController` to pause and resume the filter stream.
- [x] 3.5 Update `LessonListItem` height constraints and proportions to visually match `ChapterContentItem`.

## 4. Verification

- [x] 4.1 Verify that Home Screen "Videos/Tests" filters work instantly for courses that have been partially discovered.
- [x] 4.2 Verify that filtering at a mid-level chapter (e.g., Chapter B) correctly includes lessons from all nested descendants (C, D, etc.).
- [x] 4.3 Verify that filters remain functional and fast while offline for all previously discovered branches.
- [x] 4.4 Verify lazy pagination triggers sequentially via scrolling without eagerly loading all backend pages.
