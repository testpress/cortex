## Context

We are implementing a custom bookmark folders feature (similar to YouTube playlists) for lessons.
Currently, the database and DTO models only support a binary `isBookmarked` toggle.
The backend bookmark APIs allow organizing bookmarks into user-created folders, and storing them as uncategorized bookmarks.

The backend API details are:
1. **List Folders**: `GET /api/v2.5/folders/`
2. **Create Folder**: `POST /api/v3/bookmarks/folders/` with payload `{"name": "Folder Name"}`
3. **Create Bookmark**: `POST /api/v3/bookmarks/` with payload `{"category": "video|html|attachment", "object_id": <lesson_id>, "folder": "Folder Name", "bookmark_type": "tagged"}`
4. **Delete Bookmark**: `DELETE /api/v3/bookmarks/<bookmark_id>/`

The lesson details endpoint (`GET /api/v2.4/contents/$id/`) returns `bookmark_id` (nullable int) to check bookmark state.

## Goals / Non-Goals

**Goals:**
- Design data models for bookmark folders and individual bookmark entries to communicate with the APIs.
- Separate data logic into a dedicated repository instead of nesting it in the course repository.
- Cache folders and bookmark assignments in the Drift database to support fast UI states and offline read access.
- Support storing `bookmarkId` (nullable int) in the local lesson cache to support delete operations.
- Introduce a bottom sheet selection panel matching the layout standards in the lesson header.

**Non-Goals:**
- Supporting offline queuing/syncing of bookmark modifications. Bookmark additions/deletions will require network connectivity.

## Decisions

### 1. New DTOs (`BookmarkFolderDto` & `BookmarkDto`)

Instead of parsing payloads inline in the repository, we will introduce dedicated models to parse:
- **`BookmarkFolderDto`**: Represents a folder containing a unique database ID, a name, a bookmark count, and a user owner ID.
- **`BookmarkDto`**: Represents an active bookmark mapping a lesson ID to a specific folder (or null for uncategorized bookmarks) and holding the unique server-side `bookmark_id`.

### 2. Dedicated `BookmarkRepository`

To keep the codebase modular, bookmark operations will be isolated within a new `BookmarkRepository`.
- **Responsibilities**:
  - Fetching and caching folders from the network.
  - Creating new bookmark folders.
  - Creating bookmark links (associating a lesson to a folder, or uncategorized).
  - Deleting bookmarks by their unique bookmark ID.
  - Exposing local database streams/futures for folders and item mapping.
- **Dependency Injection**: Expose this repository using a Riverpod provider.

### 3. Database Schema Cache

We will add two tables to the packages/core Drift database:
- **`BookmarkFolders` Table**:
  - `id` (Integer, Primary Key): Unique ID from the API.
  - `name` (Text): The custom folder name.
  - `bookmarksCount` (Integer): Total items saved inside.
  - `userId` (Integer, Nullable): Owner ID.
- **`BookmarkItems` Table**:
  - `id` (Integer, Primary Key): Bookmark ID from the API.
  - `folderId` (Integer, Nullable, Foreign Key referencing BookmarkFolders).
  - `folderName` (Text, Nullable).
  - `lessonId` (Integer): ID of the bookmarked lesson.
  - `bookmarkType` (Text, Nullable).

### 4. Update Lesson Bookmark Representation

- Update `Lessons` table and `LessonDto` to store `bookmarkId` (nullable Integer) instead of a boolean `isBookmarked` flag.
- The UI determines if a lesson is bookmarked by checking if `bookmarkId != null`. This provides the ID needed for unbookmarking.

### 5. Database Migration (Version 21)

- Update database schema version to `21`.
- Setup a non-destructive migration step to construct the new tables and safely add the `bookmarkId` column to the lessons table.

## Risks / Trade-offs

- **Schema Migration Risk**: Upgrading the Drift database schema to version 21. Mitigated by using safe migrations and writing proper test/migration paths.
- **Concurrency**: Local cache could drift from the server if bookmarks are created/deleted on other devices. Mitigated by refreshing the folders list and bookmark state upon opening the bottom sheet.
