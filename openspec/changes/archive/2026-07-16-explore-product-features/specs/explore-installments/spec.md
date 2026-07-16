## ADDED Requirements

### Requirement: View Installment Plans
The system SHALL display available installment plans for a product.

#### Scenario: Product has installments
- **WHEN** user views the installment plans sheet
- **THEN** system displays the list of plans with their schedule

#### Scenario: Select an installment plan
- **WHEN** user selects a specific plan
- **THEN** system highlights the selected plan and enables the checkout button
