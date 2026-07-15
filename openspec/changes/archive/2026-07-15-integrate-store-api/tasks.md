## 1. Data Models Setup

- [x] 1.1 Create `ProductCategoryDto` in `explore_models.dart`.
- [x] 1.2 Create `PlanDetailDto` in `explore_models.dart`.
- [x] 1.3 Create `PlanDto` in `explore_models.dart`.
- [x] 1.4 Create `ProductDto` with lists for plans and plan_details in `explore_models.dart`.

## 2. API Integration

- [x] 2.1 Update `DataSource` interface in `core/data/sources/data_source.dart` with `getCategories()` and `getProducts()`.
- [x] 2.2 Implement endpoints in `HttpDataSource` and parsing logic.
- [x] 2.3 Add mock responses in `MockDataSource` for development and tests.

## 3. Providers Update

- [x] 3.1 Update `explore_providers.dart` to fetch categories and products.
- [x] 3.2 Add provider logic for handling the selected category for filtering.
- [x] 3.3 Update `exploreSearchQueryProvider` to filter the product list locally or via API search parameters.

## 4. UI Refactor

- [x] 4.1 Update `ExplorePage` to remove static mock widgets (Banners, Short Lessons, etc).
- [x] 4.2 Build `CategoryFilterBar` to show categories in a horizontally scrollable list.
- [x] 4.3 Build `ProductCard` to display individual product data (image, title, base price/status).
- [x] 4.4 Build `ProductList` to display the filtered products in `ExplorePage`.

## 5. Purchasing Flow

- [x] 5.1 Create `ProductDetailScreen` to display product information and plan selection.
- [x] 5.2 Implement inline plan selection within `ProductDetailScreen`.
