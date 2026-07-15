## Context

Currently, the `ExplorePage` located in `packages/courses/` serves mock data (trending courses, short lessons, study tips) through `DataSource`. The backend provides a fully featured Store/Marketplace API offering product categories and products. A product can either grant direct course access (simple product) or contain plans (subscription plans), which in turn contain `plan_details` offering different durations and pricing.

## Goals / Non-Goals

**Goals:**
- Replace the mock Explore UI with a real Store/Marketplace interface using live data.
- Build necessary data models for Product Categories, Products, Plans, and Plan Details that deserialize the rich sideloaded API response.
- Update `DataSource` interface to support fetching from `/api/v2.5/products/categories/` and `/api/v3/products/`.
- Provide an intuitive UI for handling simple product purchases directly and a selection workflow for subscription plan products.

**Non-Goals:**
- Handling the actual payment gateway logic. (Assuming this integrates with an existing checkout flow).
- Redesigning other tabs in the app besides Explore.

## Decisions

- **Data Source Implementation**: The Store APIs will be added to the shared `DataSource` in `core`, with `HttpDataSource` making the actual network calls.
- **Model Parsing for Sideloaded Data**: The `/api/v3/products/` returns `plans` and `plan_details` sideloaded. We will define robust `fromJson` methods to map `plan_ids` to actual `Plan` objects and `plan_detail_ids` to `PlanDetail` objects, potentially creating a unified `ProductDto` object that nests these lists for easy consumption by the UI.
- **UI Adjustments on ExplorePage**: Instead of separate sections for "Trending, Popular Tests, etc", the ExplorePage will use a filter chip row for Categories, and a list/grid of Products below.

## Risks / Trade-offs

- **Performance**: Fetching a large paginated list of products with complex nested models could cause scrolling stutter. -> We will utilize standard pagination combined with Riverpod `AsyncValue` caching and avoid heavy operations during list item builds.
- **Complexity in UI Flow**: Subscription products require a multi-step selection (Plan -> Duration) before checkout. -> We will design a bottom sheet or modal dialog dedicated to Plan selection to keep the main product list clean.
