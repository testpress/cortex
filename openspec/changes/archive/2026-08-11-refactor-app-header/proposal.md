## Why

The current `AppHeader` widget is being used inconsistently across root tab screens (like AI Screen) and interior/drawer screens (like Downloads, Bookmarks, Forum). Drawer screens need a smaller text size and card background, while root tab screens require heavier, complex headers. This change standardizes `AppHeader` specifically for interior/drawer screens, unifying their design and freeing up root screens to handle their own headers independently.

## What Changes

- **Modify `AppHeader`**:
  - Update `backgroundColor` to default to `design.colors.card`.
  - Reduce title text size from `headline` to `title`.
  - Standardize left padding to `md` (16px) and title spacing to `sm` (8px).
  - Add an optional `bottomContent` slot (a generic `Widget?`) to support contextual rows like filter chips or legends below the title without cluttering the header's parameters.
- **Extract `AppBackButton`**:
  - Create a reusable `AppBackButton` widget in `core` to unify navigation icon behavior and semantics.
- **Decouple `AiScreen`**: Remove its use of `AppHeader` and replace it with a hardcoded static header matching `StudyScreen` and `ExamsScreen`.
- **Migrate Drawer Headers**:
  - Replace the sliding App Drawer's static top header in `app_drawer.dart` with the updated `AppHeader`.
  - Update interior screens accessed via the drawer (e.g., Downloads, Bookmarks, Forum, Announcements) to use the unified `AppHeader` and `AppBackButton`, removing their custom `*Header` widget implementations.

## Capabilities

### New Capabilities
- `app-header-unification`: Standardizes interior screen headers across the application using a single, robust `AppHeader` component.

### Modified Capabilities

## Impact

- `packages/core/lib/widgets/app_header.dart`
- `packages/core/lib/screens/ai_screen.dart`
- `packages/core/lib/widgets/app_drawer.dart`
- Various custom header files across packages that will be refactored to consume the new `AppHeader`.
