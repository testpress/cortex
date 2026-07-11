## Context

The `ForumPostsListScreen` currently utilizes horizontal chips (`_CategoryChips`) to filter forum threads by category. As the need for more complex filtering arises, the UI will be updated to introduce sorting tabs (e.g., "Recent", "Most Liked", "Most Viewed") above the category chips. A new activity filter menu will be introduced via a Bottom Sheet, accessible via a filter icon on the main screen.

## Goals / Non-Goals

**Goals:**
- Introduce a sorting segmented control containing tabs for "Recent", "Most Liked", and "Most Viewed" on `ForumPostsListScreen`.
- Retain the horizontal category chips below the new sorting tabs.
- Introduce a Bottom Sheet (`ForumFilterBottomSheet`) accessible via a filter icon.
- Introduce an "Activity Filter" section within the Bottom Sheet with predefined options (e.g., Posted by me, Commented by me).
- Update the `GlobalForumFeed` Riverpod provider to accept and maintain the selected activity filter and sort order alongside the category filter.
- Update `ForumRepository` and the underlying data sources (`DataSource`) to pass the activity filter and sort parameters to the backend.

**Non-Goals:**
- Redesigning the entire forum feed layout or thread card UI.
- Modifying the underlying backend APIs (this design assumes the backend API for activity filtering is either already capable or will be updated independently to accept these parameters).

## Decisions

### 1. UI Architecture: Bottom Sheet
We decided to implement the activity filter menu as a Bottom Sheet (`AppBottomSheet`).
- **Rationale:** A bottom sheet provides a focused, modal interaction model for mobile screens, keeping the filter options easily accessible near the bottom of the screen.

### 2. State Management for Filters
The `ForumFilterBottomSheet` will trigger filter changes immediately upon selection.
- **Rationale:** We want the user to experience immediate feedback when applying a filter without needing an extra confirmation step.

### 3. Activity Filter Enum
Introduce a `ForumActivityFilter` enum to represent the different activity filters.
- **Rationale:** Using an enum provides type safety across the repository and provider layers compared to passing raw string values.

### 4. Data Layer Encapsulation
Pass the `ForumSort` and `ForumActivityFilter` enums natively through the provider layer, resolving them into raw primitive query parameters within the `ForumRepository` before passing them to the `DataSource`.
- **Rationale:** This maintains strict separation of concerns. The network data layer remains decoupled from domain-level enums. The caller (`ForumRepository`) is responsible for translating domain business logic into primitive values for the data source.

## Risks / Trade-offs

- **Risk:** The horizontal category chips might become crowded.
  - **Mitigation:** The category chips are inside a horizontally scrollable list, allowing them to comfortably accommodate many categories.
- **Risk:** Existing instances of `globalForumFeedProvider` might break if the new activity parameter is not made optional.
  - **Mitigation:** The new `activityFilter` parameter will be nullable (`ForumActivityFilter?`) and default to `null` to ensure backward compatibility with any other screens utilizing the feed.
