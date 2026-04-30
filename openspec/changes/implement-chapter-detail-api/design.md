## Context

Currently, the app only fetches chapter metadata for courses. The detailed content list (lessons, activities) is not synchronized, which causes the "All", "Video", "Lesson", etc. filters in the curriculum view to appear empty.

## Goals / Non-Goals

**Goals:**
- Integrate the Testpress V2.5 and V3 APIs for course contents.
- Implement a decentralized (lazy) synchronization model to optimize app startup.
- Ensure data integrity during partial updates (List vs Detail APIs).
- Extract complex multi-version parsing logic into a dedicated utility.

**Non-Goals:**
- Global synchronization of all course contents at app launch.
- Changing the local database schema.

## Decisions

### 1. Lazy Synchronization (Performance Optimization)
- **Choice**: Move all network synchronization from the global `appInitializationProvider` to screen-level `initState` methods.
- **Rationale**: Eager synchronization of the entire course catalog caused massive CPU/Network spikes and recursive API loops. Lazy loading ensures data is only fetched when a user views a specific course or chapter.

### 2. Specialized Curriculum Parsing
- **Choice**: Extract lesson mapping into a static `CurriculumParser` class.
- **Rationale**: Handling multiple API structures (V2.5, V3, nested results) and metadata enrichment (chapter names) in the `HttpDataSource` was violating SRP. A dedicated parser handles version detection and content filtering cleanly.

### 3. Chapter Content Endpoint (V2.5)
- **Choice**: Use `/api/v2.5/chapters/{id}/contents/` for direct chapter content lookup.
- **Rationale**: The V3 course-level contents API is less reliable for specific leaf-chapter deep-linking; V2.5 provides more stable results for direct chapter content retrieval.

### 4. Atomic Partial Updates
- **Choice**: Use `Value.absent()` in repository mappers and sequentially await database syncs.
- **Rationale**: Prevents "blind overwrites" where partial data from a list API would nullify existing detail data in the database. Sequential syncs (global vs chapter) eradicate `Future.wait` race conditions. Transactions ensure local storage never enters a half-synced state.

### 5. Network Throttling & Pruning (SWR Upgrades)
- **Choice**: Implement a memory-based Time-To-Live (TTL) cache to throttle background syncs and natively prune orphaned local records during chapter refresh by comparing remote IDs.
- **Rationale**: The Stale-While-Revalidate pattern triggered excessive API calls and blindly upserted stale rows. Throttling prevents Testpress API spam, and explicit orphaned-ID pruning during `refreshLessons` prevents ghost content without deleting pagination boundaries across the whole course.

## Risks / Trade-offs

- **[Risk] Sync Latency** → [Mitigation] Implement "Smooth Loading" in UI components (showing cached data while refreshing in background) to eliminate flickers.
