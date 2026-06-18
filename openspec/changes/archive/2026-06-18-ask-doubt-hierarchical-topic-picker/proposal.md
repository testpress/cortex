## Why

The current Ask Doubt form only supports a flat selection of top-level topics (categories). The backend API actually provides a multi-level hierarchical topic tree (Topic > Subtopic > Subject). To accurately route and categorize doubts, we need to allow users to drill down through this hierarchy directly from the UI, supporting dynamic fetching and selection of sub-levels, including an "I don't know" fallback at every level.

## What Changes

- Update `HttpDataSource.getDoubtTopics()` to accept a `parentId` query parameter `?parent_id=` to fetch child topics.
- Update `DoubtRepository.syncTopics()` to pass the `parentId` through to the data source.
- Redesign the topic picker in `AskDoubtFormScreen` to support hierarchical drill-down.
- Add a clickable breadcrumb navigation (e.g., `Topics > JEE ADVANCED > Physics`) at the top of the topic picker to navigate back up the tree.
- Render the child topics dynamically based on the selected parent, replacing the chips in place instead of opening a bottom sheet.
- Ensure the "I don't know" option is available at every level, which defaults the selected topic to the highest known parent level.
- Remove the "Attachments (optional)" upload section and associated logic from `AskDoubtFormScreen` to simplify the form.

## Capabilities

### Modified Capabilities
- `ask-doubt-form`: Update topic selection behavior to support multi-level hierarchical drill-down and dynamic API fetching.

## Impact

- `AskDoubtFormScreen` UI will change from a flat `Wrap` of chips to a dynamic breadcrumb and chip replacement flow.
- `DoubtRepository` and `HttpDataSource` will be updated to handle `parentId` correctly for dynamic network requests.
