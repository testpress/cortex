## Why

The application had a 'Bookmark' option in the drawer with no associated screen or functionality. This change fully implements the Bookmarks feature end-to-end: UI, navigation, real API integration, folder management (rename/delete), content detail navigation, localization, and design token compliance.

## What Changes

- Create a new Bookmarks screen UI using the design system (`Design.of(context)`, `AppText`, `AppCard`, design tokens).
- Add navigation from the `DashboardDrawer` to the Bookmarks screen.
- Integrate with the backend API (`/api/v2.4/bookmarks/`, `/api/v2.5/folders/`) to fetch, filter, and sort real bookmarks.
- Implement folder management: create, rename, and delete folders via the API.
- Navigate to the Content Detail page when tapping a bookmark item.
- Remove the search bar (no backend search API support).
- Localize all visible strings into `app_en.arb`, `app_ml.arb`, and `app_ar.arb`.
- Replace all hardcoded colors, paddings, and sizes with `design.colors` and `design.spacing` tokens.

## Capabilities

### New Capabilities
- `bookmarks`: A full Bookmarks screen — view, filter, sort bookmarks, manage folders, and navigate to content.

### Modified Capabilities
- `lms-navigation-shell`: Add route `/bookmarks` and wire the drawer item.

## Impact

- `packages/testpress/lib/screens/bookmarks/bookmarks_screen.dart` (new screen)
- `packages/testpress/lib/screens/bookmarks/widgets/bookmark_item.dart` (bookmark list item)
- `packages/testpress/lib/screens/bookmarks/widgets/folder_item.dart` (folder list item)
- `packages/testpress/lib/screens/bookmarks/widgets/bookmarks_header.dart` (screen header)
- `packages/testpress/lib/widgets/dashboard_drawer.dart` (navigation wiring)
- `packages/testpress/lib/navigation/app_router.dart` (route definition)
- `packages/core/lib/data/sources/http_data_source.dart` (getBookmarks, updateFolder, deleteFolder)
- `packages/core/lib/network/api_endpoints.dart` (v2.4 bookmark endpoint, v2.5 folder endpoint)
- `packages/core/lib/data/models/bookmark_item_dto.dart` (DTO with normalized JSON parsing)
- `packages/core/lib/data/providers/bookmark_provider.dart` (Riverpod paginated provider)
- `packages/core/lib/widgets/bookmark_folders_sheet.dart` (create/rename folder sheet)
- `packages/core/lib/l10n/app_en.arb`, `app_ml.arb`, `app_ar.arb` (new localization keys)
