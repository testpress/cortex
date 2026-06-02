## Context

We have an "Ask Doubt" floating action button (FAB) positioned in the `LessonDetailOrchestrator` for specific content types. When users tap this button, they should be able to submit a doubt explicitly linked to the current lesson content (`chapter_content`). The backend API (`POST /api/v3/helpdesk/`) supports linking a doubt to a chapter content by passing `chapter_content: <id>`.

## Goals / Non-Goals

**Goals:**
- Pass the current `Lesson` (or its ID and Title) from `LessonDetailOrchestrator` to the `AskDoubtFormScreen`.
- Display the linked Lesson's title within the `AskDoubtFormScreen` header or context badge.
- Ensure the API payload includes the `chapter_content` ID upon submission.
- Navigate the user back to the `LessonDetailOrchestrator` automatically after a successful submission and display a success toast.
- The Ask Doubt FAB must remain visible after a submission, allowing users to submit multiple doubts per lesson.

**Non-Goals:**
- Modifying the core helpdesk API structure or behavior.
- Supporting multiple `chapter_content` associations per doubt.

## Decisions

**1. Passing Lesson Context to Form**
- **Decision:** The `AskDoubtFormScreen` currently accepts `chapterContentId`. We will also pass the `lessonTitle` (or full `Lesson` object, but `lessonTitle` string is safer for GoRouter passing) so that the UI can render the title context without needing to fetch the lesson again.
- **Rationale:** Prevents circular dependencies or complex GoRouter object passing while still satisfying the UI requirements.

**2. Routing**
- **Decision:** We will use `context.push()` to navigate to the `AskDoubtFormScreen`. 
- **Rationale:** `push` allows us to simply `Navigator.pop(context)` or `context.pop()` back to the lesson detail screen upon successful submission. The `AskDoubtFormScreen` already calls `Navigator.pop(context)` on success.

**3. API Integration**
- **Decision:** The `DoubtRepository.createDoubt` and the underlying `HttpDataSource` already accept `chapterContentId`. We will simply map `lesson.id` (parsed as `int`) to this field.

## Risks / Trade-offs

- **[Risk] Route Object Serialization:** If we pass the whole `Lesson` object to the router, it might need extra serialization.
  - **Mitigation:** We will pass primitives: `chapterContentId` (int) and `lessonTitle` (String) via the route's path parameters or extra map.
