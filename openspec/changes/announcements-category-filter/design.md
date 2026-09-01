## Context

Clients with Quick Links enabled need to organize announcements into categories (such as events, notices, exams). Currently, the announcements feed only loads all posts sequentially into the local Drift SQLite database. Adding category filtering requires separating transient filtered feeds from persistent cached posts while maintaining a clean, accessible UI matching Cortex design standards.

## Goals / Non-Goals

**Goals:**
- Implement in-memory `CategoryPosts` family provider in `packages/core` to paginate filtered posts directly via `DataSource`.
- Add an instant-selection floating bottom sheet modal to pick categories or view all posts.
- Place a borderless filter icon in `AppHeader.actions` with an active state badge indicator.
- Display a removable active filter pill above the list when filtered.
- Support pull-to-refresh on empty announcement views.
- Provide a `QuickLinksSectionWidget` on the dashboard linking directly to filtered announcement views.

**Non-Goals:**
- Creating a separate offline database cache for each category (category filtering is server-driven and transient).
- Adding complex multi-select filtering (single category selection only).

## Decisions

### Decision 1: Non-Caching Repository Fetch for Category Posts
- **Choice**: Expose a non-caching `fetchPostsOnlineOnly` method on `PostsRepository` and call it from `CategoryPosts` provider.
- **Rationale**: Keeps strict domain/data layer encapsulation (providers only talk to repositories) while preventing filtered queries from modifying or wiping the local Drift DB cache.
- **Alternatives Considered**: Direct DataSource access in provider (rejected as architecture violation), or creating a dedicated `CategoryPostsTable` in Drift DB (rejected as over-engineering for simple filtered views).

### Decision 2: Header Filter Button + Active Pill Pattern
- **Choice**: Move filter action to `AppHeader.actions` with `showDivider: false` and render only an active pill `[ ● Category Name ✕ ]` when filtered.
- **Rationale**: Replaces horizontal scrolling rows with a scalable, compact design that matches the Discussion Forum UI.
- **Alternatives Considered**: Persistent horizontal scrolling chip bar (rejected as cluttered for institutes with 10+ categories).

### Decision 3: Scrollable Empty State Wrapper
- **Choice**: Wrap empty list views in `AppRefreshIndicator` + `CustomScrollView` with `AlwaysScrollableScrollPhysics` and `SliverFillRemaining`.
- **Rationale**: Fixes pull-to-refresh being disabled on empty lists.

## Risks / Trade-offs

- **[Risk] Network failure during category filtering** → Show error state with retry button inside the UI without affecting cached all announcements.
- **[Risk] Category list change from backend** → `PostCategories` provider watches the category table and refreshes in the background.
