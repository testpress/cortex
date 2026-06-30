## Context

Currently, when users navigate to the Ask Doubt screen from certain entry points (like a fresh app start via the Dashboard), the top breadcrumbs (Course Name and Chapter Name) are missing or blank. To solve this, we need to ensure the breadcrumb always correctly displays the 2-level hierarchy: `Course Name > Chapter Name`. The current lesson/topic name continues to be displayed below this breadcrumb inside a distinct Context Pill.

## Goals / Non-Goals

**Goals:**
- Fix the issue where the 2-level breadcrumb (`Course Name > Chapter Name`) is missing/blank.
- Ensure the breadcrumb renders cleanly separated by a `>` icon.
- Keep the UI implementation simple using standard Flutter text truncation.
- Ensure robust data fetching by hydrating missing chapter data upstream.

**Non-Goals:**
- Changing the actual doubt submission API or logic.

## Decisions

**Decision 1: Simple UI Rendering**
We will render the breadcrumb using a simple `Row` with `Flexible` widgets and standard `TextOverflow.ellipsis`. 
*Rationale:* Standard Flutter truncation is clean, performant, and handles edge cases natively without custom LayoutBuilder complexity.

**Decision 2: Self-Healing Data Fetching (Single Source of Truth)**
For screens that only have `lessonId` (like Doubt Detail), we rely on `CourseRepository.getLessonDetails(lessonId)` which natively joins tables to return the course and chapter titles. To prevent empty data on fresh app starts, we parse `chapter_slug` from the API into `LessonDto`, and during `refreshLesson(lessonId)`, we run a non-blocking background task to hydrate missing chapters using a new `getChapterDetail(slug)` API endpoint.
*Rationale:* This enforces the Repository as the single source of truth, avoids polluting the UI layer with network fallbacks, and keeps the database UI query perfectly fast and network-free.
