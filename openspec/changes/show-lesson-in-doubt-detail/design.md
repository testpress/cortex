## Context

The doubt detail screen currently displays the doubt title, content, attachments, and replies, but it lacks context about which lesson the doubt was asked from. The `DoubtDto` already contains a `lessonId`, but we need a way to display the lesson title to provide better context to the student and mentor.

## Goals / Non-Goals

**Goals:**
- Display the lesson title in the `DoubtDetailScreen` if a `lessonId` is present.
- Fetch the lesson title efficiently without blocking the main doubt content from rendering.

**Non-Goals:**
- Allowing users to navigate to the lesson from the doubt detail screen (out of scope for this simple UI addition).
- Refactoring the entire doubt detail screen UI.

## Decisions

1. **How to get the Lesson Title**
   - **Rationale**: The `DoubtDto` contains `lessonId`. To get the title, we must query the repository (e.g., `CourseRepository` or `LessonRepository`).
   - **Decision**: We will use a Riverpod provider to fetch the lesson details by ID. This will allow the UI to asynchronously load the lesson title and display it once ready, without delaying the doubt rendering.

2. **UI Placement**
   - **Decision**: We will add a small badge or text element in `_DoubtHeaderCard` to show "Lesson: <Title>" below or next to the topic badge.

## Risks / Trade-offs

- **Risk**: Fetching the lesson might add an extra network request if not cached.
  - **Mitigation**: Use Riverpod's caching to only fetch if necessary. If the lesson is already in the local database, it should return instantly.
