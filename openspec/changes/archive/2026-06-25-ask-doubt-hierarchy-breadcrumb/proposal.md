## Why

Currently, when users open the Ask Doubt screen directly from the Dashboard on a fresh app start, the context breadcrumbs (`Course Name > Chapter Name`) fail to load and appear blank. This occurs due to missing parent chapter data in the local database. We need to fix this so users always have clear navigation context about which course and chapter they are asking a doubt in.

## What Changes

- Fix the Ask Doubt screen header to consistently display the 2-level breadcrumb (`Course Name > Chapter Name`).
- The current lesson/topic name will continue to be displayed properly below the breadcrumbs inside the Context Pill (`_ContextPill`).
- We will retrieve the breadcrumb titles cleanly via `CourseRepository.getLessonDetails(lessonId)`, which uses a pure SQLite join.
- To handle missing local data on fresh app starts, `CourseRepository.refreshLesson` will perform a non-blocking background hydration of the missing chapter by parsing its `chapter_slug` and fetching it from a new `getChapterDetail(slug)` endpoint.

## Capabilities

### New Capabilities
- `ui-ask-doubt-breadcrumb`: Renders a simple breadcrumb hierarchy for the Course and Chapter.

## Impact

- **Affected Code**: UI components handling the header in the Ask Doubt screen (`DoubtContextBadge`, `AskDoubtFormScreen`, `DoubtDetailScreen`).
- **UI/UX**: Users will now clearly see the Course, Chapter, and Topic for the doubt they are asking in a clean format.
