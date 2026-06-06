## Context

The app drawer has a 'Bookmark' item that links to nothing. This change implements the complete Bookmarks feature — from the UI and navigation through API integration, folder management, content detail navigation, localization, and design system compliance.

## Goals / Non-Goals

**Goals:**
- Implement the Bookmarks screen UI using the design system (tokens, semantic `AppText`, `AppCard`).
- Wire up the Bookmark drawer item to navigate to the new `/bookmarks` route.
- Integrate with the bookmark API (`v2.4` for reads, `v2.5` for folder mutations) to fetch real data.
- Support filtering by folder/category and sorting (Recent, Oldest, Lastly Opened).
- Allow users to manage folders: create, rename, and delete, with confirmation dialogs.
- Navigate to the Content Detail page when a bookmark item is tapped.
- Remove the search bar — no backend search API is available.
- Localize all visible UI strings (English, Malayalam, Arabic) with plural support where needed.
- Use only design tokens (`design.colors`, `design.spacing`, `design.radius`) — no hardcoded colors or magic numbers.

**Non-Goals:**
- Offline caching beyond basic Riverpod state.
- Moving bookmarks between folders (move action deferred).

## Decisions

- **Screen Location**: `packages/testpress/lib/screens/bookmarks/` in the `testpress` package, as it is a dashboard-level feature.
- **Routing**: GoRouter route `/bookmarks` with an optional `folderName` query param to support drilling into a folder.
- **API Versioning**:
  - `GET /api/v2.4/bookmarks/` — list bookmarks with filter/sort/folder params.
  - `GET /api/v2.4/folders/` — list bookmark folders.
  - `PATCH /api/v2.5/folders/{id}/` — rename a folder.
  - `DELETE /api/v2.5/folders/{id}/` — delete a folder.
- **Normalized JSON Parsing**: The API returns side-loaded JSON. `BookmarkDto.fromNormalizedJson()` resolves `object_id` references from the `chapter_contents` side-load array.
- **State Management**: Riverpod `paginatedBookmarksProvider` and `bookmarkFoldersProvider`, parameterized by `BookmarkFilter` (folder, type, sort order).
- **Localization**: All strings defined in ARB files and accessed via `L10n.of(context)` — stored once per `build()` call as `final l10n = L10n.of(context)`.
- **Design Tokens**: All spacing, color, and radius values sourced from `Design.of(context)` — no raw hex colors or hardcoded pixel values.

## Risks / Trade-offs

- **Risk**: Side-loaded API structure is fragile if the server response shape changes.
  **Mitigation**: Parsing is isolated in `BookmarkDto.fromNormalizedJson()` making it easy to update.
- **Risk**: No backend search means users cannot search bookmarks.
  **Mitigation**: Search bar removed entirely to avoid misleading the user.
