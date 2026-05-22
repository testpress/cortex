## 1. Database and Models

- [x] 1.1 Define `BookmarkFoldersTable` and `BookmarkItemsTable` under `packages/core/lib/data/db/tables/`.
- [x] 1.2 Update `LessonsTable` to replace the `isBookmarked` boolean column with a nullable `bookmarkId` integer.
- [x] 1.3 Update `AppDatabase` schema version to 21 and register the new tables.
- [x] 1.4 Implement the Drift database schema migration path for version 21 (create new tables, add nullable `bookmarkId` column to lessons).
- [x] 1.5 Create `BookmarkFolderDto` and `BookmarkDto` in `packages/core/lib/data/models/bookmark_dto.dart` and export them in `packages/core/lib/data/data.dart`.
- [x] 1.6 Update `LessonDto` to replace `isBookmarked` with `bookmarkId` and update serialization, `copyWith`, and `mergeWith` logic.
- [x] 1.7 Run `build_runner` in `packages/core` to regenerate the database schema and model classes.
- [x] 1.8 Update database mapping and query methods in `CourseRepository` to sync lesson bookmark state with `bookmarkId` instead of `isBookmarked`.
- [x] 1.9 Update provider mappings (`chapter_detail_provider` and `lesson_detail_provider`) to use `bookmarkId` and resolve compilation errors.

## 2. API / Data Source Integration

- [x] 2.1 Add bookmark API endpoint constants to `ApiEndpoints`.
- [x] 2.2 Add new methods to the `DataSource` interface for folder listing, folder creation, bookmarking, and deletion.
- [x] 2.3 Implement the new methods in `HttpDataSource`.
- [x] 2.4 Implement mock implementations in `MockDataSource` to support local development and previewing.

## 3. Repository Integration

- [x] 3.1 Create `BookmarkRepository` under `packages/core/lib/data/repositories/bookmark_repository.dart`.
- [x] 3.2 Register and expose `bookmarkRepositoryProvider` in `packages/core/lib/data/repositories/repository_providers.dart` and export the repository.
- [x] 3.3 Create UI-facing bookmark providers under `packages/core/lib/data/providers/bookmark_provider.dart`.

## 4. Core UI & Orchestration

- [x] 4.1 Update `LessonDetailShell` bookmark icon to toggle states based on the presence of `bookmarkId`.
- [x] 4.2 Update `LessonDetailOrchestrator` to display the custom bottom sheet when the bookmark action is clicked.
- [x] 4.3 Implement self-synchronizing stream in `BookmarkRepository.watchBookmarkFolders()` to automatically trigger `refreshFolders()` asynchronously.

## 5. Bookmark Folders Sheet

- [x] 5.1 Implement `BookmarkFoldersSheet` as a floating card-style bottom sheet with margins, rounded corners, premium handle bar, and no header close button.
- [x] 5.2 Display "Uncategorized" and user folders in the sheet.
- [x] 5.3 Implement folder rows with a single gesture target (no checkboxes) to prevent duplicate network requests, using active primary color and bold typography for selection.
- [x] 5.4 Integrate a visible `Scrollbar` with a custom `ScrollController` wrapping the folder list.
- [x] 5.5 Instantly close the bottom sheet upon tapping a folder row and execute the bookmark API operations asynchronously in the background.

## 6. Folder Creation Dialog

- [x] 6.1 Implement folder creation to display as a premium modal dialog overlay with input validation.
- [x] 6.2 Orchestrate closing the bottom sheet and launching the centered creation dialog at the `LessonDetailOrchestrator` level.
- [x] 6.3 Adjust the creation dialog layout dynamically using `MediaQuery` keyboard insets to prevent keyboard overlap.

## 7. Global Toast Notification

- [x] 7.1 Expose a premium global Overlay-driven dark capsule toast system that displays animated feedback upon success or network failure.