## ADDED Requirements

### Requirement: Product Benefits Presentation
The system SHALL display product-level benefits ("What you get") on the product detail screen when a product contains defined benefits.

#### Scenario: Standalone product with benefits is viewed
- **WHEN** a user opens the product detail screen for a product that contains benefits and has no subscription plans
- **THEN** the system SHALL display a "What you get" section listing each benefit with an affirmative visual icon and descriptive title

#### Scenario: Product without benefits is viewed
- **WHEN** a user opens the product detail screen for a product with an empty benefits list
- **THEN** the system SHALL omit the benefits section without creating empty vertical padding or gaps

### Requirement: Inline Plan Selection and Comparison
The system SHALL display subscription plans and an interactive plan comparison section directly on the product detail screen when a product has subscription plans.

#### Scenario: Multi-plan product is viewed
- **WHEN** a user views a product with subscription plans
- **THEN** the system SHALL render an inline "Choose a plan" section with duration selector pills and vertically stacked plan radio cards
- **AND** the system SHALL render an inline "Compare plans" section with segmented plan tabs displaying included courses and benefits (✓/✕)

#### Scenario: Plan card is selected
- **WHEN** the user taps a plan radio card
- **THEN** the system SHALL set the active plan, select its radio button, update the active price in the checkout bar, and switch the "Compare plans" segmented tab to that plan

#### Scenario: Compare plans tab is tapped
- **WHEN** the user taps a plan tab under "Compare plans"
- **THEN** the system SHALL switch the comparison view to that plan and select that plan card above
