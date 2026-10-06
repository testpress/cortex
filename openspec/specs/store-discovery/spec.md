# store-discovery Specification

## Purpose
TBD - created by archiving change integrate-store-api. Update Purpose after archive.
## Requirements
### Requirement: Browse Store Categories
The system SHALL fetch and display a list of product categories from the `/api/v2.5/products/categories/` endpoint.

#### Scenario: Successful category fetch
- **WHEN** the user navigates to the Store/Store tab
- **THEN** the system displays a filterable list of product categories

### Requirement: Browse Store Products
The system SHALL fetch and display a paginated list of products from the `/api/v3/products/` endpoint, optionally filtered by the selected category or search query.

#### Scenario: Products are filtered by category
- **WHEN** the user selects a product category
- **THEN** the system re-fetches products with `?category=<id>`

#### Scenario: Exclude purchased products
- **WHEN** products are fetched
- **THEN** the backend automatically excludes purchased products and the system only shows available items

#### Scenario: Product has subscription plans
- **WHEN** a product has `plan_ids` populated
- **THEN** the product card SHALL indicate it has duration-based pricing tiers

