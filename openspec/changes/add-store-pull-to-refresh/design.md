## Context

The store page displays a list of products and categories, but it currently has no mechanism for the user to manually trigger a data refresh. Other major tabs like Study and Exams use a standard pull-to-refresh gesture powered by the shared `AppRefreshIndicator` component.

## Goals / Non-Goals

**Goals:**
- Enable pull-to-refresh gesture on the main `StorePage`.
- Reload product list and category data when the refresh action is triggered.
- Maintain visual consistency by reusing the existing `AppRefreshIndicator` widget.

**Non-Goals:**
- Adding pull-to-refresh to individual product detail pages.
- Changing the layout or underlying data fetch logic significantly beyond triggering a reload.

## Decisions

- **Wrap the `CustomScrollView`**: In `StorePage`, the `CustomScrollView` (which contains `ProductList()`) will be wrapped with `AppRefreshIndicator`.
- **Refresh Providers on Pull**: The `onRefresh` callback will call `ref.refresh(storeProductsProvider.future)` and `ref.refresh(storeCategoriesProvider.future)` to await the re-fetch of the latest data from the repository.

## Risks / Trade-offs

- None identified.
