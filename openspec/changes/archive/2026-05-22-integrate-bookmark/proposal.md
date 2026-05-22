## Why

Currently, lessons can only be bookmarked with a binary toggle (`isBookmarked`), which doesn't allow students to categorize or group bookmarked lessons by topic, priority, or subject. Introducing custom bookmark folders (similar to YouTube playlists) will let students organize their studying materials more effectively.

## What Changes

- **Database Schema Support**: Add table structures for `BookmarkFolder` and `BookmarkItem` (many-to-many relationship linking lessons to folders) to packages/core Drift database.
- **Bottom Sheet Modal Selection (YouTube playlist style)**:
  - When clicking the bookmark icon in the lesson header, show a bottom sheet modal instead of instantly toggling bookmark state.
  - The bottom sheet will display the list of all bookmark folders with checkboxes.
  - Tapping a checkbox saves/removes the lesson to/from the corresponding folder.
  - Provide a "+ New Folder" action at the bottom of the list that allows the user to input a name and instantly create a new folder (automatically selected).
- **Core UI Widgets**: Update the bookmark icon visual state in `LessonDetailShell` to indicate if the lesson is saved to *any* folder (filled bookmark icon if >= 1 folder, outline if 0 folders).

## Capabilities

### New Capabilities
- `bookmark-folders`: Organise bookmarked lessons into user-created folders, including folder creation, listing, and multi-folder selection.

### Modified Capabilities
- `unified-lesson-shell`: Change bookmark interaction from a binary toggle to showing the bookmark folders bottom sheet.

## Impact

- **packages/core**:
  - Drift schema migration to support `BookmarkFoldersTable` and `BookmarkFolderItemsTable`.
  - Add standard checkboxes/list item tiles if needed, or build directly in `courses`.
- **packages/courses**:
  - Update `CourseRepository` / providers to fetch folders, create folders, and link lessons to folders.
  - Update `LessonDetailOrchestrator` to show the bottom sheet when the bookmark action is clicked.
