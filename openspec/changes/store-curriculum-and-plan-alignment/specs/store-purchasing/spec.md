## MODIFIED Requirements

### Requirement: Subscription Product Plan Selection
The system SHALL require users to select a subscription plan and duration tier when purchasing a subscription product (a product with non-empty `plan_ids`). The subscription plan selector SHALL group options by plan, showing plan titles, bundled courses mapped from `plan.courseIds`, and duration options without pre-selection.

#### Scenario: User views a subscription product
- **WHEN** the user views a product with `plan_ids` populated
- **THEN** the system SHALL display a duration selector showing available plans, their bundled courses, and their `plan_details` (with `duration_in_days`, `price`, and `strike_through_price`)

#### Scenario: User selects a plan duration
- **WHEN** the user selects a duration tier under a plan
- **THEN** checkout SHALL create the order with `plan_detail_id: <selected_plan_detail_id>`

#### Scenario: User has not selected a duration tier
- **WHEN** the user attempts to checkout on a subscription product without selecting a tier
- **THEN** the system SHALL prevent checkout and prompt the user to select a duration
