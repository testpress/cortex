## 1. UI Construction

- [x] 1.1 Create `bookmarks_screen.dart` in `packages/testpress/lib/screens/bookmarks/`.
- [x] 1.2 Create child widgets: `bookmark_item.dart`, `folder_item.dart`, `bookmarks_header.dart`.
- [x] 1.3 Implement tab bar (All / Folders), filter chips (Uncategorized / All), content type dropdown, and sort dropdown using design tokens.
- [x] 1.4 Implement skeleton loading states using `Skeletonizer` for both bookmarks list and folders list.
- [x] 1.5 Implement empty state UI for when there are no results.

## 2. Navigation Integration

- [x] 2.1 Add route `/bookmarks` (with optional `folderName` query param) in `packages/testpress/lib/navigation/app_router.dart`.
- [x] 2.2 Update `packages/testpress/lib/widgets/dashboard_drawer.dart` to navigate to `/bookmarks` when the Bookmark item is tapped.
- [x] 2.3 Navigate to the Content Detail page (`/content-detail`) when a bookmark item is tapped.

## 3. API Integration & State

- [x] 3.1 Create `BookmarkDto` with `fromNormalizedJson()` in `packages/core/lib/data/models/bookmark_dto.dart`.
- [x] 3.2 Create `BookmarkFolderDto` in `packages/core/lib/data/models/bookmark_folder_dto.dart`.
- [x] 3.3 Add `bookmarksV2_4` and `foldersV2_5` endpoints to `packages/core/lib/network/api_endpoints.dart`.
- [x] 3.4 Add `getBookmarks()`, `getBookmarkFolders()`, `updateFolder()`, `deleteFolder()` to `packages/core/lib/data/sources/http_data_source.dart`.
- [x] 3.5 Create Riverpod `paginatedBookmarksProvider` and `bookmarkFoldersProvider` in `packages/core/lib/data/providers/bookmark_provider.dart`.
- [x] 3.6 Wire providers into the screen to drive the list with pull-to-refresh and infinite scroll pagination.

## 4. Folder Management

- [x] 4.1 Implement Create Folder via `BookmarkFoldersSheet` (existing widget in `packages/core/lib/widgets/`).
- [x] 4.2 Implement Rename Folder: bottom sheet pre-filled with current name, calls `PATCH /api/v2.5/folders/{id}/`.
- [x] 4.3 Implement Delete Folder: confirmation dialog, then calls `DELETE /api/v2.5/folders/{id}/`.
- [x] 4.4 Refresh folder list after create/rename/delete.
