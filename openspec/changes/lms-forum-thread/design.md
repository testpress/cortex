# Design: lms-forum-thread

## Context

The forum module currently has course selection and thread list screens. However, users cannot click into a thread to see the full content or replies. This design addresses the implementation of the thread detail view.

## Goals / Non-Goals

**Goals:**
- Implement a high-fidelity `ForumPostDetailScreen`.
- Integrate with existing mock data for threads and comments.
- Implement a persistent, rich-text "Sticky Reply Input" (Quill) at the bottom of the screen.
- Establish clean state management for thread replies using Riverpod.

**Non-Goals:**
- Real API integration (staying with Mock data for now).
- User mentions or tagging in replies.

## Decisions

- **Architecture**: The screen lives in `packages/forum/lib/screens/`.
- **State Management**:
    - `forumThreadDetailProvider(courseId, threadId)`: To fetch/watch thread metadata.
    - `threadCommentsProvider(threadId)`: To fetch/watch comments associated with the thread.
- **UI Components**:
    - Use `ForumHeader` for consistency.
    - `ThreadContentHeader`: To display the original question at the top.
    - `AttachmentPreview`: A horizontal list of selected images with remove capabilities.
    - `CommentList`: Vertical list of comments rendered under the thread content.
    - `StickyReplyInput`: A rich-text editor based on `flutter_quill`.
- **Rich Text Architecture**:
    - **Editor**: `quill.QuillEditor` for WYSIWYG editing.
    - **Toolbar**: Custom built toolbar (Material-free) for Bold, Italic, Code, Lists, and Images.
    - **Conversion**: `_QuillEditorService` converts internal Delta format to HTML for API payload compatibility.
- **Design Tokens**: Strict adherence to `Design.of(context)` for colors, typography, and spacing to ensure a premium feel.

## Risks / Trade-offs

- **Layout Complexity**: Managing the scrollable height with a sticky footer on varying screen sizes.
- **Mock Synchronicity**: Ensuring the mock data feels responsive and correctly reflects "sent" replies in the local state.
