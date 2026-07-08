## ADDED Requirements

### Requirement: Signup screen form fields
The Signup screen SHALL collect exactly the fields required by the registration API: Username, Email, Phone (with Country Code), and Password.

#### Scenario: Rendering the signup form
- **WHEN** the user views the Signup screen
- **THEN** the system SHALL display fields for Username, Email, Phone, and Password
- **AND** the system SHALL NOT display a Date of Birth field
- **AND** the Country Code field SHALL capture the ISO Alpha-2 string and default to "IN"
