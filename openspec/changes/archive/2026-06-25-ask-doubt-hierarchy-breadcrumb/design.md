## Context

Currently, the Ask Doubt screen only displays the immediate topic context, which can lack clarity for users in deeply nested courses. To solve this, we want to show a three-level breadcrumb: Course Name, Chapter Name, and Topic Name. We want to do this in the simplest, cleanest way possible.

## Goals / Non-Goals

**Goals:**
- Implement a 2-line header for the Ask Doubt screen.
- Line 1: Course and Chapter separated by a `>` icon.
- Line 2: Topic name with a content-type icon.
- Keep the UI implementation simple using standard Flutter text truncation.
- Keep the data fetching simple by using existing data fetching helpers.

**Non-Goals:**
- Changing the actual doubt submission API or logic.

## Decisions

**Decision 1: Simple UI Rendering**
We will render the breadcrumb using a simple `Row` with `Flexible` widgets and standard `TextOverflow.ellipsis`. 
*Rationale:* Standard Flutter truncation is clean, performant, and handles edge cases natively without custom LayoutBuilder complexity.

**Decision 2: Use Existing Data Helpers**
We will fetch the `chapterTitle` directly from the `LessonDto`/`Lesson` model where available. We will get the `courseTitle` using the existing `courseDetailProvider(courseId)` helper. For screens that only have `lessonId` (like Doubt Detail), we can use the `CourseRepository.getLessonDetails(lessonId)` helper which natively joins tables to return the course and chapter titles.
*Rationale:* This leverages our existing data layer cleanly without requiring additional repository methods or domain model fields.
