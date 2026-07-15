# store-discovery Specification

## Purpose
TBD - created by archiving change integrate-store-api. Update Purpose after archive.
## Requirements
### Requirement: Browse Store Categories
The system SHALL fetch and display a list of product categories from the `/api/v2.5/products/categories/` endpoint.

#### Scenario: Successful category fetch
- **WHEN** the user navigates to the Explore/Store tab
- **THEN** the system displays a filterable list of product categories

### Requirement: Browse Store Products
The system SHALL fetch and display a paginated list of products from the `/api/v3/products/` endpoint, optionally filtered by the selected category or search query.

#### Scenario: Products are filtered by category
- **WHEN** the user selects a product category (e.g., "NEET Courses")
- **THEN** the system re-fetches products with `?category=<id>`

#### Scenario: Exclude purchased products
- **WHEN** products are fetched
- **THEN** the backend automatically excludes purchased products and the system only shows available items

