## 1. Data Layer & Providers

- [x] 1.1 Implement `threadCommentsProvider` in `packages/courses/lib/providers/forum_providers.dart` to watch replies for a specific thread.
- [x] 1.2 Implement `forumThreadDetailProvider` to fetch a single thread's metadata by ID.

## 2. Core UI Implementation

- [x] 2.1 Create `ForumPostDetailScreen` in `packages/courses/lib/screens/forum/forum_post_detail_screen.dart`.
- [x] 2.2 Implement the thread content header (title, author, description) using `AppText` and design tokens.
- [x] 2.3 Build the scrollable list of comments using `ListView.separated` and a custom `_CommentItem` widget.
- [x] 2.4 Implement the `StickyReplyInput` with a `flutter_quill` rich text editor and custom toolbar (Bold, Italic, Code, Lists, Links, Images).
- [X] 2.6 Build `_AttachmentPreview` widget: horizontal list of images with "remove" overlays.
- [X] 2.7 Connect toolbar image button to mock attachment logic.
- [x] 2.5 Implement `_QuillEditorService` for Delta-to-HTML conversion.

## 3. Navigation & Refinement

- [x] 3.1 Update navigation in `ForumPostsListScreen` to open the detail screen on thread tap.
- [x] 3.2 Polish the UI with micro-animations, correct spacing, and high-fidelity styling (premium look).
- [x] 3.3 Verify mock data integration shows the correct threads and comments.
