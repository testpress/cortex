## Why

Currently, the Doubts list displays all doubts together without distinguishing between those answered by AI bots and those answered by human mentors. Users need a quick way to filter the doubts view based on the type of query (AI vs Mentor) to easily find specific discussions, similar to the filtering chips used in the Forum pages.

## What Changes

- Add a filter chip row [ ALL, AI, MENTOR ] at the top of the Doubts list view.
- Update `DoubtsTable` (Drift schema) to store `queryType` locally.
- Update `DoubtDto` and `DoubtRepository` to map and persist `query_type` from the API response.
- Update the Doubts list UI state to handle the selected filter and display doubts based on their `query_type`.

## Capabilities

### New Capabilities
- `doubts-filter-ui`: UI elements (chips) for filtering the doubts list by query type.

### Modified Capabilities
- `doubts-ui`: The existing doubts list view needs to support the new filtering logic and UI layout.
- `doubts-core`: (Optional) Update the data fetching or local querying logic to support filtering by `DoubtQueryType`.

## Impact

- `doubts-ui` feature (DoubtsListScreen).
- `doubts-core` feature (DoubtRepository, DoubtQueryType).
