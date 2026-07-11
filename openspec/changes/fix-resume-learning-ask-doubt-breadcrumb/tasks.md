## 1. Database Hydration Fix

- [x] 1.1 In `LessonDto`, ensure `chapterSlug` is parsed from the API payload.
- [x] 1.2 In `DataSource`, add the `getChapterDetail(slug)` endpoint.
- [x] 1.3 In `CourseRepository.refreshLesson`, extract the background hydration logic into `_hydrateNestedChapterBackground`.

## 2. Consistency Fixes

- [x] 2.1 In `LessonDto`, add `chapterSlug` to the `mergeWith` method for safe copying.
- [x] 2.2 In `LessonDto`, add `chapterSlug` and `slug` to the `toJson` map.
- [x] 2.3 Correct the inline comment in `refreshLesson` to accurately describe database hydration logic.

## 3. Verification

- [x] 3.1 Verify background hydration triggers when a lesson is opened.
- [x] 3.2 Verify Ask Doubt screen loads breadcrumbs correctly after the database is hydrated.

## 4. UI Architecture & Localization Updates

- [x] 4.1 Refactor `DoubtContextBadge` to accept a `breadcrumbs` list instead of hardcoded `courseName` and `chapterName`.
- [x] 4.2 Update `AskDoubtFormScreen` to use `FutureBuilder` with `getLessonDetails`, avoiding unnecessary streams.
- [x] 4.3 Clean up redundant database methods (`watchLessonDetails`) and use standard offline-first pattern.
- [x] 4.4 Localize English strings (`Lesson Details`, `Question ID`) in `.arb` files for all supported languages.
