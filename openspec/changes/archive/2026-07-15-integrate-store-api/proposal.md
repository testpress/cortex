## Why

The current Explore page uses static/mocked data for discovery courses, short lessons, popular tests, and study tips. We need to integrate it with the real Store/Marketplace APIs (`/api/v2.5/products/categories/` and `/api/v3/products/`) to allow users to discover and purchase real products and subscriptions. This unlocks monetization and gives users access to dynamic store content directly from the app.

## What Changes

- **Add Store Models**: Create models for `ProductCategory`, `Product`, `Plan`, and `PlanDetail` to support the Store API response.
- **Update Explore Data Source**: Update the `DataSource` to fetch categories and products from the real API endpoints instead of mocks.
- **Update Explore UI**: Redesign the Explore page to act as a storefront, displaying categories for filtering and listing paginated products, handling both simple products and subscription passes.
- **Support Subscription Purchasing**: Add UI to handle selecting a plan and plan detail when a user tries to purchase a subscription product.
- **BREAKING**: Replaces the mocked `DiscoveryCourse`, `ShortLesson`, `PopularTest`, and `StudyTip` data on the Explore tab with the real Store products.

## Capabilities

### New Capabilities
- `store-discovery`: Browse store categories and view products available for purchase.
- `store-purchasing`: Handle simple product purchases and complex subscription plan selections.

### Modified Capabilities
- `lms-explore-dashboard`: Updates the Explore dashboard to render the Store/Marketplace UI instead of the previous static discovery widgets.
- `lms-explore-search`: Updates the search functionality to filter store products and categories.

## Impact

- **Affected Packages**: `packages/courses` (which currently houses the Explore UI), `packages/core` (for API networking and models).
- **APIs**: Introduces usage of `/api/v2.5/products/categories/` and `/api/v3/products/`.
- **UI/UX**: Users will see real store content on the Explore tab. The UI will need to handle product cards, plan selection dialogs, and pricing displays.
