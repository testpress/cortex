## Context
The application needs to display subject analytics, including both top-level subjects and an N-level hierarchy of child subjects. The API provides this data by splitting it into `subjects` (metadata like name and leaf status) and `subject_stats` (scores and percentages). To provide instant load times and offline accessibility, the app must implement an offline-first architecture where the UI reads from a local database that is periodically synced with the remote API in the background.

## Goals / Non-Goals

**Goals:**
- Implement a custom parser to merge `subjects` and `subject_stats` from the paginated API response.
- Build an offline-first data flow using Drift (for local storage) and Riverpod (for pagination state management and UI reactivity).
- Support lazy pagination (infinite scrolling) and navigation into any depth of the subject hierarchy.

**Non-Goals:**
- Offline creation or modification of analytics (this is a read-only feature).
- Pre-fetching entire subject trees (data is only fetched when a user navigates to a specific parent node).

## Decisions

**1. Reactive UI via Drift Streams**
- **Decision**: The UI will exclusively listen to a reactive Drift database stream.
- **Rationale**: This establishes a true single source of truth. The background sync logic (Riverpod Notifier) only concerns itself with fetching from the API and saving to Drift; it does not manually update UI state.

**2. Transactional Delete-and-Insert for Page 1 Refreshes**
- **Decision**: When refreshing the first page of a subject node, the local repository will use a single database transaction to delete existing children of that `parentId` and immediately insert the newly fetched children.
- **Rationale**: If we only use upserts (`insertAllOnConflictUpdate`), subjects deleted on the server would linger in the app forever as stale data. If we delete and insert sequentially without a transaction, the reactive stream would momentarily emit an empty list, causing a UI flicker. A transaction guarantees a seamless, atomic update.

## Risks / Trade-offs

- **Risk: Managing pagination with a local database cache** 
  Coordinating API pagination (e.g., page 2, page 3) with a single reactive database stream can be complex, as appending new pages to the database might trigger UI rebuilds if not handled correctly.
  *Mitigation*: The `SubjectAnalyticsPaginationNotifier` will strictly manage the `currentPage` and `hasMorePages` state in memory, appending to the database smoothly so the stream naturally updates the ListView without flickering.
