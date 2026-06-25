## Why

Currently, when a user accesses the "Ask a Doubt" screen from a learning page, the screen only displays the title of the immediate topic they are viewing. In courses with deeply nested content structures, this lack of context can confuse users and make it hard to confirm exactly which module or subject they are asking a doubt about. To improve clarity and navigation context, we need to introduce a hierarchy breadcrumb that displays the Course name, Chapter Name, and the Topic name.

## What Changes

- Update the "Ask a Doubt" screen header to display a breadcrumb hierarchy.
- Use a clean, simple layout for the breadcrumb:
  - Display `Course Name > Chapter Name` using standard text truncation (e.g., `TextOverflow.ellipsis`).
  - Below it, display the Topic Name preceded by an appropriate content-type icon.
- We will retrieve the `chapterTitle` directly from the `LessonDto` or the `Lesson` domain model.
- We will retrieve the `courseTitle` using the existing `courseDetailProvider` helper (by passing the `courseId`), or the `getLessonDetails` helper.

## Capabilities

### New Capabilities
- `ui-ask-doubt-breadcrumb`: Renders a simple breadcrumb hierarchy for the Course and Chapter.

## Impact

- **Affected Code**: UI components handling the header in the Ask Doubt screen (`DoubtContextBadge`, `AskDoubtFormScreen`, `DoubtDetailScreen`).
- **UI/UX**: Users will now clearly see the Course, Chapter, and Topic for the doubt they are asking in a clean format.
