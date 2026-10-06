# store-purchasing Specification

## Purpose
TBD - created by archiving change integrate-store-api. Update Purpose after archive.
## Requirements
### Requirement: Simple Product Purchasing
The system SHALL allow users to directly purchase a simple product (a product where `plan_ids` is empty). The order SHALL be created via `POST /api/v3/orders/` with only the product slug.

#### Scenario: User buys a simple product
- **WHEN** the user views a simple product (no `plan_ids`)
- **THEN** they can directly initiate checkout at the product's listed price

### Requirement: Subscription Product Plan Selection
The system SHALL require users to select a subscription plan and duration tier when purchasing a subscription product (a product with non-empty `plan_ids`). The order SHALL include `plan_detail_id` in the request body.

#### Scenario: User views a subscription product
- **WHEN** the user views a product with `plan_ids` populated
- **THEN** the system SHALL display a duration selector showing available plans and their `plan_details` (with `duration_in_days`, `price`, and `strike_through_price`)

#### Scenario: User selects a plan duration
- **WHEN** the user selects a duration tier
- **THEN** checkout SHALL create the order with `plan_detail_id: <selected_plan_detail_id>`

#### Scenario: User has not selected a duration tier
- **WHEN** the user attempts to checkout on a subscription product without selecting a tier
- **THEN** the system SHALL prevent checkout and prompt the user to select a duration

