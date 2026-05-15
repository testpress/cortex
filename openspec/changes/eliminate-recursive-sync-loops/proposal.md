## Why

The curriculum synchronization logic currently uses a "Greedy Master Sync" and recursive triggers that cause excessive network traffic (10+ sequential API calls) and high CPU/memory usage. This pattern risks 429 (Too Many Requests) errors from the backend and potential server crashes under load, while also blocking the UI even when local data is available.

## What Changes

- **Modification**: Refactor `CourseRepository` and `CourseListProvider` to decouple course list metadata from curriculum content fetching.
- **Modification**: Replace the recursive "Discovery" logic in `ChaptersListPage` with a lazy, level-by-level synchronization strategy.
- **Modification**: Implement a "Stale-While-Revalidate" (SWR) pattern for curriculum data to yield local cache instantly.
- **Removal**: Eliminate recursive sync triggers in `ChaptersListPage` and greedy `while` loops in `HttpDataSource`.

## Capabilities

### New Capabilities
- `lazy-curriculum-discovery`: Ability to fetch and sync specific curriculum nodes (chapters/folders) only when navigated into, rather than crawling the entire tree.

### Modified Capabilities
- `curriculum-sync-logic`: Update the existing sync mechanisms to be cache-first, non-blocking, and scoped to the current view depth.

## Impact

- **Affected Code**: `CourseRepository`, `HttpDataSource`, `ChaptersListPage`, `CourseListProvider`, `info_providers.dart`.
- **Performance**: Significant reduction in Time-to-First-Byte for course content and dramatic decrease in redundant API calls.
