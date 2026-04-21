## 1. Core Logic & Performance
- [x] 1.1 Extract curriculum mapping logic into `CurriculumParser` to support V2.5/V3 structures.
- [x] 1.2 Implement "Lazy Synchronization" by moving sync logic to `ChaptersListPage` and `ChapterDetailPage`.
- [x] 1.3 Update `CourseRepository` to use `Value.absent()` for partial database updates.
- [x] 1.4 Wrap repository delete/upsert logic in atomic database transactions.
- [x] 1.5 Implement `syncChapterContents` in `CourseRepository` to encapsulate sync coordination.
- [x] 1.6 Resolve repository `Future.wait` database race conditions by syncing globally then locally.
- [x] 1.7 Implement 60-second in-memory network throttling for background syncs to prevent API spam.
- [x] 1.8 Add orphaned record pruning logic specifically to `refreshLessons` using `deleteLessonsByIds`.

## 2. API Integration
- [x] 2.1 Update `chapterContents` endpoint to `/api/v2.5/chapters/{id}/contents/`.
- [x] 2.2 Implement `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/` synchronization.
- [x] 2.3 Add error logging for background synchronization tasks.

## 3. UI/UX Refinement
- [x] 3.1 Implement "Smooth Loading" in `ChapterDetailPage` to prevent flickers during background sync.
- [x] 3.2 Add "All" (Curriculum) filter to `ChapterStatusFilter` and set as default.
- [x] 3.3 Ensure filter selection reactively updates using the optimized $O(N)$ traversal logic.

## 4. Stability & Verification
- [x] 4.1 Fix infinite lookup loops between providers and repository refreshes.
- [x] 4.2 Verify content visibility across all status tabs (Running, Upcoming, History).
- [x] 4.3 Regenerate Riverpod files for `Future`-based domain composition.

## 5. Projection Layer Refactor
- [x] 5.1 Decouple relational logic from SQL by removing INNER JOIN from `watchLessonsForCourse`.
- [x] 5.2 Implement `CourseCurriculumDto` to serve as a stateless hierarchy snapshot.
- [x] 5.3 Implement rehydrated projection in `CourseRepository.watchCourseCurriculum` using Dart mapping.
- [x] 5.4 Refactor `ChaptersListPage` to build `validChapterIds` from the snapshot instead of incomplete DB chapters.
