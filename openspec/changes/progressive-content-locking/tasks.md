## 1. Data Layer & Localization
 
-- [x] 1.1 Update `LessonDto` and `CurriculumParser` to extract `locked_contents` and resolve `isLocked` state.
-- [x] 1.2 Add multi-language localization keys for locked prerequisite and expiry notices (`en`, `ta`, `ar`, `ml`).
-- [x] 1.3 Handle 403 prerequisite lock responses during direct lesson refreshes by marking lessons as locked in database.

## 2. List Views & Interaction Guards

-- [x] 2.1 Update `ChapterContentItem` and `LessonListItem` with distinct icons (`lock` vs `calendarClock`), tap-blocking error toasts ("Complete previous content to unlock"), and progress status badges.

## 3. Detail Player & Notice Views

-- [x] 3.1 Create reusable `ContentNoticeView` in `package:core` and integrate into `LessonDetailOrchestrator` for locked and expired content.
-- [x] 3.2 Disable secondary actions (bookmarking, downloads, completion, doubt FAB) on locked items while preserving footer navigation.
-- [x] 3.3 Render `ContentNoticeView` in `ExamPrescreen` when exam lesson is locked.

## 4. Verification

-- [x] 4.1 Add parser unit tests and orchestrator/list widget tests verifying locked and expired behaviors.
