## MODIFIED Requirements

### Requirement: Doubt Composition Form
The system SHALL provide a screen for users to compose and submit new academic doubts.
- **Fields**: Title (Plain Text), Category (Hierarchical Topic selection), and Question Content (Rich Text).
- **Validation**: Title, Category, and Content SHALL NOT be empty before submission is enabled.
- **Navigation (Success)**: Upon successful submission, the system SHALL dismiss the form and navigate the user to the newly created doubt's detail screen.
- **Navigation (Failure)**: Upon a submission error, the system SHALL dismiss the form and display an error toast message on the underlying screen.

#### Scenario: Submitting a valid doubt successfully
- **GIVEN** the user has entered a title, selected a category, and provided content
- **WHEN** the user submits the doubt and the API responds successfully
- **THEN** the system SHALL dismiss the doubt composition form and navigate to the newly created doubt detail screen

#### Scenario: Submitting a doubt fails
- **GIVEN** the user submits the doubt
- **WHEN** the API responds with an error
- **THEN** the system SHALL dismiss the doubt composition form and show an error toast message
