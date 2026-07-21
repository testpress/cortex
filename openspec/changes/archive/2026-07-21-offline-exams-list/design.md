## Context

Users can download exams for offline use, but there's currently no dedicated UI screen to list and manage these downloaded exams. We recently added a drawer item "Offline Exams" that navigates to `/exams/offline`, but this screen needs to be built.

## Goals / Non-Goals

**Goals:**
- Build a new `OfflineExamsListScreen` that retrieves offline exams from local storage/database.
- Display an empty state if no offline exams are downloaded.
- Display a list of offline exams if available.
- Provide "Delete" and "Attend" actions for each list item.
- Ensure correct navigation to the exam detail screen.

**Non-Goals:**
- Modifying the actual offline exam download mechanism or the exam player logic.

## Decisions

- **State Management**: Use Riverpod to fetch the offline exams from the local repository (e.g. `OfflineExamRepository` or equivalent local DB).
- **UI Architecture**: Standard list screen layout (matching existing Cortex list views) with cards or list tiles for each exam. The empty state should use the standard `EmptyStateWidget` (or similar) in the app.
- **Routing**: `GoRouter` path `/exams/offline` is already assumed. The router configuration in the exams/testpress package needs to be updated to map this route to `OfflineExamsListScreen`.

## Risks / Trade-offs

- **Data Sync**: Deleting an offline exam needs to ensure any local results or attempts are properly managed (if applicable). Mitigation: rely on existing offline exam deletion logic if it exists, otherwise remove the local records carefully.
