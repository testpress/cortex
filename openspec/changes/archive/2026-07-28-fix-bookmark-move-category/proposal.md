## Why

When moving an existing bookmark (like a ForumPost, Post, or Question) to a folder from the Bookmarks screen, the API request fails with a 400 Bad Request error: `{"category":["This field may not be blank."]}`. This happens because the category parameter maps to `BookmarkDto.type` (which is empty when loaded from the local database, and contains unmapped values like `'Question'` or `'Post'` when loaded from the API), rather than using the stored `BookmarkDto.bookmarkType`.
Furthermore, toast notifications are currently shown optimistically before the network request completes, which displays a success toast followed by a failure toast if the background request fails.
Additionally, when moving a bookmark, the backend response for a single bookmark POST does not return nested metadata (like the title or chapter name), causing the UI to briefly show "Unknown" or "Unknown Lesson" before a full refresh sync occurs.
Finally, when moving a bookmark to a new folder, the old bookmark in the previous folder is not removed, resulting in duplicate bookmarks for the same item. Executing these asynchronous background operations after instantly closing the sheet causes a `Cannot use "ref" after the widget was disposed` crash.

## What Changes

- Update `BookmarkRepository._mapToBackendCategory` to correctly map additional bookmark types like `'Question'`, `'Post'`, and `'ForumPost'` (case-insensitively) to their respective backend categories: `'user_selected_answer'` and `'post'`.
- Update `bookmarks_screen.dart` to pass `_selectedBookmark.bookmarkType ?? _selectedBookmark.type` as the category to `BookmarkFoldersSheet` and `CreateFolderDialog` to ensure it is not empty.
- Modify `BookmarkFoldersSheet` to show the success toast only *after* the API request completes successfully, rather than showing it optimistically beforehand.
- Update `BookmarkRepository.addBookmark` to load existing local metadata (like `title`, `chapterName`, etc.) from the DB before updating the row, ensuring this data is preserved and not reset to blank.
- Update `BookmarkFoldersSheet._toggleBookmark` to:
  - Extract the stable `ProviderContainer` using `ProviderScope.containerOf(context)` before the widget is dismissed and disposed.
  - Sequentially delete bookmarks in other folders and add to the new folder using the container to avoid `disposed ref` crashes.

## Capabilities

### New Capabilities

*(None)*

### Modified Capabilities

- `bookmark-folders`: Support moving different bookmark types (lessons, questions, and posts) to folders, show toasts only after completion, preserve metadata to prevent "Unknown" flicker, and delete duplicate/old bookmarks in other folders safely without disposed ref crashes.

## Impact

- `BookmarkRepository._mapToBackendCategory` mapping logic.
- `BookmarkRepository.addBookmark` implementation in `packages/core`.
- `bookmarks_screen.dart` in `packages/testpress`.
- `bookmark_folders_sheet.dart` in `packages/core`.
