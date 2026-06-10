## ADDED Requirements

### Requirement: Topic Analytics Screen
The system SHALL provide a dedicated topic analytics screen to display performance metrics for a specific leaf topic.

#### Scenario: Displaying the topic analytics screen
- **WHEN** the user navigates to the topic analytics screen for a given topic
- **THEN** the system SHALL render a header containing a back navigation button and the topic's name as the title
- **AND** the system SHALL display the topic's correct, incorrect, and unanswered performance metrics
- **AND** the system SHALL visually present these metrics using a category donut progress card (or similar visualization)
