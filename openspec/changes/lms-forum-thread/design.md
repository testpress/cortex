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

- **Architecture**: The screen will live in `packages/courses/lib/screens/forum/`. 
- **State Management**:
    - `threadDetailProvider(threadId)`: To fetch the thread metadata.
    - `threadCommentsProvider(threadId)`: To fetch/watch comments associated with the thread.
- **UI Components**:
    - Use `ForumHeader` for consistency.
    - `ThreadContentCard`: To display the original question at the top.
    - `AttachmentPreviewRow`: A horizontal list of selected images with remove capabilities.
    - `ReplyList`: Vertical list of comments (using Column inside ScrollView for performance).
    - `StickyReplyInput`: A rich-text editor based on `flutter_quill`.
- **Rich Text Architecture**:
    - **Editor**: `quill.QuillEditor` for WYSIWYG editing.
    - **Toolbar**: Custom built toolbar (Material-free) for Bold, Italic, Code, Lists, Links, and Images.
    - **Conversion**: `_QuillEditorService` to convert internal Delta format to HTML for backend compatibility (Trix format).
- **Design Tokens**: Strict adherence to `Design.of(context)` for colors, typography, and spacing to ensure a premium feel.

## Risks / Trade-offs

- **Layout Complexity**: Managing the scrollable height with a sticky footer on varying screen sizes.
- **Mock Synchronicity**: Ensuring the mock data feels responsive and correctly reflects "sent" replies in the local state.
