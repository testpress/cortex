## MODIFIED Requirements

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
