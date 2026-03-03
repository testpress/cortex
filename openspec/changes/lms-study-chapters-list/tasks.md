## 1. Data Layer & Providers

- [x] 1.1 Create `courseDetailProvider(courseId)` in `packages/courses` to fetch a course with its chapters.
- [x] 1.2 Implement a flattened lesson provider or utility to extract all lessons for type-based filtering.

## 2. UI Components (`packages/courses`)

- [x] 2.1 Implement `ChaptersListPage` skeleton and skeleton items for the loading state.
- [x] 2.2 Create `CurriculumHeader` with custom back-action and course title display.
- [x] 2.3 Create `ContentTypeTabBar` (Horizontal filter pill row).
- [x] 2.4 Create `ChapterAccordionItem` with lesson/assessment count labels and subject-aware icons.
- [x] 2.5 Create `LessonStatusBadge` (Completed, In Progress, Locked states).

## 3. Routing & Integration

- [x] 3.1 Update `app_router.dart` in `packages/testpress` with the new route: `/study/course/:courseId/chapters`.
- [x] 3.2 Add `onTap` to `CourseCard` to navigate to the chapters list.
- [x] 3.3 Ensure the `Study` tab remains active when navigating into the curriculum.

## 4. Polish & Verification

- [x] 4.1 Verify spacing, color contrast, and touch targets against the reference.
- [x] 4.2 Test filtering logic across different chapters.
- [x] 4.3 Ensure proper loading and error states for course details.
