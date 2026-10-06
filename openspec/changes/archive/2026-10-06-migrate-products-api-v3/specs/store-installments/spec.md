## MODIFIED Requirements

### Requirement: View Installment Plans
The system SHALL display available installment plans for a product and SHALL distinguish between a first-time installment enrollment and an active ongoing installment plan.

#### Scenario: Product has installments
- **WHEN** user views the installment plans sheet and `user_installment_plans` is empty
- **THEN** system displays the list of available installment plans

#### Scenario: User has an active ongoing installment plan
- **WHEN** `user_installment_plans` contains an entry with `status == "Active"`
- **THEN** the system SHALL show a "Pay Next Installment" CTA with the due amount from `next_due_amount`

#### Scenario: Select an installment plan
- **WHEN** user selects a specific plan (first-time enrollment)
- **THEN** system highlights the selected plan and enables checkout with `installment_plan_id` sent to `POST /api/v3/orders/`

#### Scenario: No installment plans available
- **WHEN** `installment_plans` is empty
- **THEN** system hides the installments option entirely
