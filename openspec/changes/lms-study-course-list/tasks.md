## 1. Domain Models & Data Layer (`packages/data`)

- [x] 1.1 Define `Course`, `Chapter`, and `Lesson` models with JSON serialization.
- [x] 1.2 Implement `enrollmentProvider` and `recentActivityProvider` using Riverpod annotations.
- [x] 1.3 Add mock data generators for the study curriculum based on Phase 2 requirements.

## 2. Core UI Components (`packages/courses`)

- [x] 2.1 Implement `CourseCard` with right-aligned percentage and `success` green progress bar.
- [x] 2.2 Implement `ContentTypeFilterChip` with compressed aspect ratio (5.0).
- [x] 2.3 Create `StudyResumeCard` with tiered shadow, custom vertical padding (12px), and compact button.
- [x] 2.4 Set up normalized spacing (12px) for list headers and full-width divider.

## 3. Main Page & Logic (`packages/courses`)

- [x] 3.1 Create `StudyPage` with sticky `AppHeader` containing the search bar and filter grid.
- [x] 3.2 Implement search filtering logic for the course and lesson lists.
- [x] 3.3 Implement view switching between "Course View" and "Filtered Lesson View".
- [x] 3.4 Wire up Riverpod providers and handle `AsyncValue` (Loading/Error) states.

## 4. Navigation & Verification

- [x] 4.1 Update the `app` navigation shell to point the "Study" tab to the new `StudyPage`.
- [x] 4.2 Verify Dark Mode transition for all 64 unique color instances identified in audit.
- [x] 4.3 Ensure all interactive elements (chips, cards) meet 48dp minimum touch targets.

## 5. Technical Refinement & Optimization
- [x] 5.1 Optimize `recentActivityProvider` with complex SQL joins for O(1) metadata lookup.
- [x] 5.2 Implement list virtualization (`ListView.builder`) for curriculum and lesson views.
- [x] 5.3 Centralize content type colors into `DesignStudyTheme` design tokens.
- [x] 5.4 Refactor data layer to use `authProvider` and side-effect-free initialization logic.
- [x] 5.5 Standardize floating resume card with `AppButton` and metadata breadcrumbs.
- [x] 5.6 Optimize filtering logic using a flattened `allLessonsProvider` for O(N) traversal.
- [x] 5.7 Integrate `AppFocusable` into filter chips for consistent focus visuals and full-cell tap capture.
- [x] 5.8 Refine chip layout with left-aligned icons and standardized horizontal gutters.
