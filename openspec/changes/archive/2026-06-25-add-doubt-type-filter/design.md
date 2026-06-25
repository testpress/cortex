## Context

The Helpdesk (Doubts) API returns all doubts by default. Each ticket includes a `query_type` field indicating whether it is directed to an "AI" bot or a human "Mentor". The API also supports filtering via the `query_type` URL parameter (e.g., `?query_type=ai` or `?query_type=mentor`). Currently, the app does not persist this attribute locally, nor does it allow users to filter their doubts by type, making it difficult to find specific interactions.

## Goals / Non-Goals

**Goals:**
- Store the `query_type` of each doubt in the local Drift database.
- Parse the `query_type` from the API JSON response into the `DoubtDto` model.
- Update `DataSource` and `DoubtRepository` to support fetching and streaming doubts filtered by `DoubtQueryType`.
- Implement a filter chip UI in the Doubts list screen to toggle between ALL, AI, and MENTOR doubts.

**Non-Goals:**
- Changing how doubts are created (they already support `query_type`).
- Modifying the UI of the doubt thread detail page.

## Decisions

### 1. Data Model and Local Database Schema
**Decision:** Add a nullable `TextColumn` named `queryType` to `DoubtsTable` and a corresponding `DoubtQueryType? queryType` to `DoubtDto`.
**Rationale:** We store it as a `TextColumn` using the enum's `.name` (i.e. 'ai' or 'mentor') to match existing conventions (like `status`). This allows straightforward filtering in local Drift queries. The API returns `query_type: "AI"` or `"Mentor"`, so `DoubtDto.fromJson` will map these strings to the `DoubtQueryType` enum.

### 2. Repository and DataSource API
**Decision:** Update `watchDoubts` and `syncDoubts` in `DoubtRepository` to optionally accept `DoubtQueryType? queryType`.
**Rationale:** 
- `watchDoubts({DoubtQueryType? queryType})` will add a `.where()` clause to the Drift query to filter the local DB stream.
- `syncDoubts({DoubtQueryType? queryType, ...})` will pass the filter to the `DataSource`, which will append `query_type=ai` (or `mentor`) to the API request. This ensures that when the user switches tabs, we fetch properly paginated results from the server matching the active filter.

### 3. UI State Management
**Decision:** Update the state providers (e.g., `doubtsListProvider`) to track the currently selected filter (ALL, AI, MENTOR) and re-trigger both `watchDoubts` and `syncDoubts` when the filter changes.
**Rationale:** Using standard Riverpod patterns, the UI will rebuild automatically when the selected chip changes, showing the correct local data stream while fetching the remote page 1 in the background.

## Risks / Trade-offs

- [Risk] Existing cached doubts in the database will have `queryType` set to NULL until the next sync.
  → Mitigation: The Drift schema migration should make `queryType` nullable. Doubts with a NULL `queryType` will be treated gracefully (or re-synced) when fetched.
- [Risk] Paginating with a filter might cause missing data if local DB has gaps.
  → Mitigation: The standard `syncDoubts` logic with `insertOnConflictUpdate` works identically for filtered requests. The UI will just show what's locally matching while fetching more.

## Open Questions
- Do we need to force a full re-sync of doubts on migration, or is it acceptable that old cached doubts might not appear in the filtered views until they are refreshed? (Assuming graceful degradation is fine).
