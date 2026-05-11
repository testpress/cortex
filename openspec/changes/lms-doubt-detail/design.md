# Design: lms-doubt-detail

## Context

The `discussions` package manages both public forum posts and private mentoring doubts. While the creation flow (`AskDoubtFormScreen`) and listing (`DoubtsListScreen`) are implemented, students cannot currently view the details of a doubt or see mentor replies. `DoubtDetailScreen` will serve as the primary interface for the mentoring conversation.

## Goals / Non-Goals

**Goals:**
- Implement a thread-based UI for private mentoring.
- Render rich-text content for the original question and all replies.
- Support multi-format attachment previews (Images/PDFs).
- Implement high-fidelity loading states using `Skeletonizer`.
- Provide a responsive reply input at the bottom of the screen.
- Reuse existing `ForumComposer` widgets for consistency.

**Non-Goals:**
- Real-time WebSocket updates (syncing via Riverpod/Polling is sufficient).
- Editing or deleting replies.
- Advanced search within a single thread.

## Decisions

### 1. Component Reuse for Composer
- **Decision**: Use `ForumEditorField` and `ForumEditorToolbar` for the follow-up reply input.
- **Rationale**: These components are already styled for the design system and handle rich-text state management. Reusing them ensures a consistent "writing" experience across the app.

### 2. Plain-Text Rendering Strategy
- **Decision**: Use `AppText.bodySmall` to render the content.
- **Rationale**: Rendering plain text simplifies the implementation and avoids the performance overhead of QuillEditor for read-only viewing. We will use simple text strings instead of Delta format.

### 3. Attachment Handling
- **Decision**: Reuse `ForumAttachmentPreview` (refactored for path/URL flexibility) for viewing attachments in the reply draft.
- **Rationale**: The logic for removing/previewing attachments is already encapsulated.

### 4. Data Layer
- **Decision**: Implement `doubtRepliesProvider(doubtId)` as a `StreamProvider` if the DB supports it, or `FutureProvider` for API-first.
- **Rationale**: Ensures the UI updates automatically when new replies are synced or added locally.

## Risks / Trade-offs

- **[Risk]** Large Quill Delta payloads causing lag on long threads → **[Mitigation]** Quill is generally performant, but we will monitor scroll performance and use `ListView.builder` for replies.
- **[Risk]** PDF preview complexity → **[Mitigation]** Use a generic file icon with a "Tap to Open" action using existing `AppPdfViewer` or system handlers.
