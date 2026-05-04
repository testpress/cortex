## Context

The "Recently Completed" section on the dashboard currently uses hardcoded mock data. The `/api/v2.4/completed/` endpoint provides a list of `chapter_contents` along with a `chapters` list for metadata (chapter names). This section follows a similar relational pattern to "Resume Learning" but is simpler as it doesn't require joining with user activity attempts or progress tracking (since all items are 100% complete).

## Goals / Non-Goals

**Goals:**
- Implement the `/api/v2.4/completed/` endpoint in `HttpDataSource`.
- Create a dedicated `_parseRecentlyCompleted` method in `DashboardContentsDto`.
- Synchronize and persist completed lessons in the `DashboardContentsTable` under the `recentlyCompleted` section type.
- Display real completed lessons on the dashboard with accurate titles and chapter names.

**Non-Goals:**
- Detailed progress tracking (all items are assumed 100% complete).
- Complex duration joining (unless provided in the contents list, we will default to null).

## Decisions

### 1. Dedicated Parsing Path
We will add `_parseRecentlyCompleted` to `DashboardContentsDto`.
- **Rationale**: Similar to `whatsNew`, the "Completed" API returns a list of contents and a list of chapters. By having a dedicated branch, we keep the logic clean and isolated from the more complex `resumeLearning` branch.

### 2. Progress and Duration Handling
- **Progress**: Will be hardcoded to `100.0` for all items in this section.
- **Duration**: We will map `cover_image` and `title` normally. If duration isn't present in the `chapter_contents` list, we will leave it null.
- **Rationale**: The primary goal is to show *what* was completed. Detailed metadata like duration is secondary for this specific feed.

### 3. Repository Integration
Add `refreshRecentlyCompletedFeed()` and `watchRecentlyCompletedFeed()` to `DashboardRepository`.
- **Rationale**: Consistent with the `whatsNew` and `resumeLearning` patterns.

## Risks / Trade-offs

- **[Risk]**: Duplicate items if the same content is completed multiple times (unlikely).
- **[Mitigation]**: The database uses `lessonId` and `sectionType` as a primary key, which naturally handles deduplication during the `wipeAndInsert` process.
