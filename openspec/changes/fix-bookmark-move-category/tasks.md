## 1. Core Implementation

- [x] 1.1 Update `BookmarkRepository._mapToBackendCategory` in `packages/core/lib/data/repositories/bookmark_repository.dart` to map `'Question'`, `'Post'`, and `'ForumPost'` (case-insensitively) to `'user_selected_answer'` and `'post'` respectively.
- [x] 1.2 Update `bookmarks_screen.dart` in `packages/testpress` to pass `bookmarkType ?? type` to `BookmarkFoldersSheet` and `CreateFolderDialog`.
- [x] 1.3 Update `bookmark_folders_sheet.dart` in `packages/core` to display the success toast only after the background API request completes successfully.
- [x] 1.4 Update `BookmarkFoldersSheet._toggleBookmark` in `packages/core` to delete bookmarks in other folders when adding to a new folder.

## 2. Verification

- [x] 2.1 Verify the packages compile successfully by running `flutter analyze` in `packages/core` and `packages/testpress` (or root).
- [x] 2.2 Run tests in `packages/core` to ensure no regressions are introduced.
- [x] 2.3 Add unit tests verifying category mapping and metadata preservation in `BookmarkRepository`.
