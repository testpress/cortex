## 1. Component Refactoring & Setup

- [x] 1.1 Extract shared editor components (`_QuillEditorService`, toolbar controls, `_AttachmentPreview`) from `forum_post_detail_screen.dart` into `packages/forum/lib/widgets/forum_composer.dart`.
- [x] 1.2 Refactor `_StickyReplyInput` to utilize the new shared composer components, ensuring no regression in reply functionality.
- [x] 1.3 Add required localization keys for the creation screen (e.g., `forumCreateNewPost`, `forumPostTitleHint`, `forumPostDescriptionHint`, `forumButtonSubmit`, `forumButtonCancel`).

## 2. Implement Post Creation Screen

- [x] 2.1 Create the `ForumPostCreateScreen` in `packages/forum/lib/screens/forum_post_create_screen.dart`.
- [x] 2.2 Implement the screen header using `ForumHeader` with "Create New Post" title.
- [x] 2.3 Add the Title/Subject input field using `AppTextField` with appropriate `design.radius.xl` styling.
- [x] 2.4 Integrate the `ForumComposer` for the description field, including formatting toolbar support.
- [x] 2.5 Add category selection using payload-style category objects (`id`, `name`) with ID-based selected state.
- [x] 2.6 Add the bottom action row with "Cancel" and "Submit" buttons as per the design reference.

## 3. Logic & Navigation

- [x] 3.1 Implement form validation logic to enable/disable the "Submit" button based on field content.
- [x] 3.2 Implement the mock submission effect (loading state followed by navigation pop).
- [x] 3.3 Update `ForumPostsListScreen` to navigate to `ForumPostCreateScreen` when the "Create New Post" button is tapped.
- [x] 3.4 Render category labels from category payload data (backend-ready), not static l10n category enums.
- [x] 3.5 Move category model to shared forum DTO layer; keep mock source limited to mock values and lookup helper usage.
- [x] 3.6 Add category retrieval contract in `DataSource`, implement in mock/http sources, and expose via `ForumRepository`.
- [x] 3.7 Add `forumCategoriesProvider` and consume it from create screen (no direct mock constants in UI).
- [x] 3.8 Finalize UI polish (padding, colors, and typography) to match the project's design tokens and design reference.
