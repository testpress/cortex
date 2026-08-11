## Context

The `AppHeader` component in `packages/core` was originally designed as a generic header for all screens. However, different screens have fundamentally different header requirements:
- **Root Tab Screens**: Demand heavy layouts with search bars, sliver effects, filters, and dynamic error banners.
- **Drawer/Interior Screens**: Demand a lightweight, consistent title bar with a back button or menu toggle, a smaller text size, and occasionally a slot for chips or a legend below the title.

This design focuses on specializing `AppHeader` strictly for drawer/interior screens, unifying the UI across the application.

## Goals / Non-Goals

**Goals:**
- Update `AppHeader`'s aesthetics (`backgroundColor`, `title` style) to match interior screen specifications.
- Provide a `bottomContent` slot to `AppHeader` to support contextual elements without bloating the widget.
- Migrate all interior screens (Downloads, Bookmarks, Forum, Announcements, and the App Drawer itself) to use the new `AppHeader`.
- Extract duplicated back arrow logic into a unified `AppBackButton` in `core`.
- Hardcode the `AiScreen` header to decouple it from `AppHeader`.

**Non-Goals:**
- Changing the header structure or UI of any other root tab screens (like `StudyScreen`, `ExamsScreen`, etc.).

## Decisions

**1. `bottomContent` Slot for AppHeader**
Instead of adding specific properties (e.g., `searchBar`, `filterChips`) which would flood the widget's constructor, `AppHeader` will expose a single `final Widget? bottomContent`.
- *Rationale*: This uses standard Flutter composition. A screen that needs multiple bottom items can simply pass a `Column` to `bottomContent`.

**2. Hardcoded `AiScreen` Header**
`AiScreen` currently uses `AppHeader`. We will replace it with a static `Container` that mirrors the exact layout of `StudyScreen`'s header.
- *Rationale*: `AiScreen` functions as a root tab. By hardcoding its header for now, we fully decouple `AppHeader` from root screens, allowing us to safely mutate `AppHeader` exclusively for drawer screens.

**3. Removing `*Header` Widgets**
Custom widgets like `DownloadsHeader`, `BookmarksHeader`, and `ForumHeader` will be deleted.
- *Rationale*: These widgets duplicate layout logic and diverge visually over time. Standardizing on `AppHeader` removes technical debt and enforces visual consistency.

**4. `AppBackButton` Extraction**
A new `AppBackButton` widget is added to `core` to encapsulate the back arrow icon, tap targets, and accessibility labels.
- *Rationale*: Eliminates duplicate `GestureDetector` blocks across screens and standardizes the navigation icon spacing and semantics.

**5. Padding and Gap Standardization**
- *Rationale*: `AppHeader` hardcodes a `md` (16px) left padding and a `sm` (8px) title gap to match app-wide conventions, removing the need to configure `titleSpacing` per-screen.

## Risks / Trade-offs

- **Risk**: A drawer screen might need a complex layout that doesn't fit the `AppHeader` paradigm.
  *Mitigation*: The `bottomContent` and `actions` slots provide significant flexibility. If a screen outgrows these slots, it should likely be elevated to a root-level design pattern anyway.
