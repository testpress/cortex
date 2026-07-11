## Why

Users currently lack an efficient way to filter discussion forum threads beyond basic category selection. A comprehensive filter menu is needed to allow filtering by user activity (e.g., "Posted by me", "Liked by me"), improving navigation and discoverability of relevant forum content.

## What Changes

- Add a filter icon to the `ForumPostsListScreen` header or search bar.
- Add a sorting segmented control containing tabs for "Recent", "Most Liked", and "Most Viewed" above the horizontal category chips.
- Retain the existing horizontal category chips.
- Introduce a Bottom Sheet (`ForumFilterBottomSheet`) that contains a new "Filter by Activity" section with options like "Posted by me", "Commented by me", "Liked by me", and "Bookmarked by me".
- Update the `globalForumFeedProvider` to accept and process an activity filter parameter and a sort parameter.
- **Backend Integration**: Implement a robust, layered data flow for the new filters by passing `ForumSort` and `ForumActivityFilter` enums seamlessly through the `GlobalForumFeed` provider, resolving them into primitive query parameters inside `ForumRepository`, and passing those raw values through the abstract `DataSource` contract to keep the network layer decoupled from the domain layer.

## Capabilities

### New Capabilities
- `forum-activity-filters`: Introduces filtering forum threads based on user activity (e.g., posted by me, commented by me, liked by me, bookmarked by me).
- `forum-sorting`: Introduces sorting forum threads by "Recent", "Most Liked", and "Most Viewed".

### Modified Capabilities
- `forum-post`: Updates the forum thread listing requirement to support advanced activity filtering through a Bottom Sheet and sorting through horizontal tabs.

## Impact

- **UI/UX**: Modifies the `ForumPostsListScreen` layout to include sorting tabs, and adds a Bottom Sheet for activity filter controls.
- **State Management**: Updates `GlobalForumFeed` provider to maintain activity filter state.
- **Data Layer**: Updates `ForumRepository.fetchThreads` and `DataSource.getForumThreads` API to support activity filtering parameters.
