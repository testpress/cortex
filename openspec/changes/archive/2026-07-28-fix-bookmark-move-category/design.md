## Context

When moving a bookmark, the category string passed to the bookmark folders sheet defaults to `_selectedBookmark!.type` (which evaluates to `'Question'`, `'Post'`, or `'ForumPost'`). In `BookmarkRepository._mapToBackendCategory`, this is not mapped to the corresponding backend-recognized category, and the raw string is forwarded to the API. Furthermore, if the bookmark is loaded from the local database, `type` is empty (`""`), which causes a blank category to be sent.
Additionally, deselecting or selecting folders displays optimistic success toasts before the API call finishes. If the background call fails, the user is presented with a success toast followed immediately by a failure toast.
Finally, when updating or moving a bookmark, the single-bookmark POST response from the API does not contain the side-loaded content data (title, chapter, etc.). Saving this bookmark to the local DB resets these fields to blank/null, causing the UI list item to display "Unknown" until a background sync finishes.
Also, when moving a bookmark to a different folder, the system does not delete the bookmark from its old folder, creating duplicate bookmarks for the same item. Executing these asynchronous cleanup operations after dismissing the sheet triggers a `Cannot use "ref" after the widget was disposed` Riverpod crash.

## Goals / Non-Goals

**Goals:**
- Correctly map the bookmark UI types `'Question'`, `'Post'`, and `'ForumPost'` to backend-recognized categories.
- Ensure the bookmark category parameter is not blank when moving a bookmark from the Bookmarks screen.
- Only display the success toast after the background bookmark update operation completes successfully.
- Preserve existing local bookmark metadata (title, chapterName, slug, isForumPost, created) when updating a bookmark.
- Delete bookmarks in other folders when selecting a new folder to ensure a clean "move" operation instead of duplicating.
- Prevent Riverpod disposed `ref` crashes during asynchronous background operations after sheet closure.
- Fix the bookmark moving feature on the Bookmarks screen.

**Non-Goals:**
- Changing database schemas or API endpoints.
- Redesigning bookmark folders navigation or UI.

## Decisions

### Decision 1: Extend category mapping in `BookmarkRepository._mapToBackendCategory`

Modify `BookmarkRepository._mapToBackendCategory` in `packages/core/lib/data/repositories/bookmark_repository.dart` to support more category types.

### Decision 2: Pass `bookmarkType` as fallback to `BookmarkFoldersSheet` & `CreateFolderDialog`

In `packages/testpress/lib/screens/bookmarks/bookmarks_screen.dart`, pass `_selectedBookmark!.bookmarkType ?? _selectedBookmark!.type` for `category` properties when creating `BookmarkFoldersSheet` and `CreateFolderDialog`.

### Decision 3: Postpone success toast until API call completes

In `BookmarkFoldersSheet._toggleBookmark`, move the `AppToast.show` invocation for the success message from before the API call to inside the `try` block, after the provider futures have successfully resolved.

### Decision 4: Preserve bookmark metadata on update in `BookmarkRepository.addBookmark`

Before inserting the updated bookmark into `bookmarkItemsTable`, retrieve any existing local database row for that `lessonId` to extract the `title`, `chapterName`, `slug`, `isForumPost`, and `created` values. If the row is not found (a new bookmark), try looking up the title and chapter from `lessonsTable` as a fallback. Pass these resolved values to the insert call and return a fully populated `BookmarkDto`.

### Decision 5: Clean up old bookmarks in other folders via atomic moveBookmark

Instead of doing sequential delete-then-add calls on the client widget side (which causes list items to disappear/flicker and is prone to partial failure data loss), we introduce a dedicated, atomic `moveBookmark` repository method and `moveBookmarkProvider`.

This method:
1. Sequentially creates the new bookmark first on the server (ensuring that a failure does not leave the item unbookmarked).
2. Deletes all old bookmarks in other folders sequentially on the backend (wrapped in try-catch to tolerate partial remote failures).
3. Performs all database changes (deleting old rows, cleaning duplicates, inserting the new row, and shifting folder counts) inside a single local database transaction to prevent UI flickering.

This atomic flow is invoked from both the bottom sheet selection (`_toggleBookmark`) and the new folder dialog (`_saveFolder`) when the lesson is already bookmarked in another folder.

### Decision 6: Use stable `ProviderContainer` to avoid widget disposal crashes

Extract the stable `ProviderContainer` from the active context using `ProviderScope.containerOf(context)` as the first operation in `_toggleBookmark` and `_saveFolder`. Close the sheet/dialog instantly, and execute all sequential provider read operations using `container.read()` instead of `ref.read()`. This prevents the `Cannot use "ref" after the widget was disposed` exception.

```dart
    final container = ProviderScope.containerOf(context);
    widget.onClose();

    try {
      ...
      // Move bookmark atomically
      await container.read(moveBookmarkProvider(...).future);
      ...
    } catch (e) {
      ...
    }
```

## Risks / Trade-offs

- None. Using `ProviderScope.containerOf` is the standard, safe practice to perform async work in the background after widget unmounting/disposal.
