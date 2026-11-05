## ADDED Requirements

### Requirement: Product Benefits Presentation
The system SHALL display product-level benefits ("What you get") on the product detail screen when a product contains defined benefits.

#### Scenario: Standalone product with benefits is viewed
- **WHEN** a user opens the product detail screen for a product that contains benefits and has no subscription plans
- **THEN** the system SHALL display a "What you get" section listing each benefit with an affirmative visual icon and descriptive title

#### Scenario: Product without benefits is viewed
- **WHEN** a user opens the product detail screen for a product with an empty benefits list
- **THEN** the system SHALL omit the benefits section without creating empty vertical padding or gaps

### Requirement: Inline Plan Selection and Comparison Table
The system SHALL display subscription plans and a side-by-side plan comparison matrix table on the product detail screen when a product has subscription plans.

#### Scenario: Multi-plan product is viewed
- **WHEN** a user views a product with subscription plans
- **THEN** the system SHALL render an inline "Choose a plan" section with duration selector pills and vertically stacked plan radio cards
- **AND** the system SHALL render a "Compare plans" side-by-side matrix table with "Plans" as the first column header, each plan as column headers, section headers for "Courses" and "What you get", and rows displaying included (✓) and excluded (✕) indicators
- **AND** the currently selected plan column SHALL be highlighted with a distinctive tinted background and accent header text using the brand blue accent (`design.colors.accent2`) across both light and dark themes
- **AND** plan card titles, table column headers, section headers ("Courses", "What you get"), and comparison item rows SHALL be unified at 14px typography with font weight differentiating hierarchy

#### Scenario: Plan card is selected
- **WHEN** the user taps a plan radio card
- **THEN** the system SHALL set the active plan, select its radio button, and update the active price in the checkout bar
- **AND** the selected plan card border and radio indicator SHALL use the brand button color (`design.colors.accent2` blue)
