## MODIFIED Requirements

### Requirement: Paged Question Review
The system SHALL display a paged view of all questions from a completed test.

#### Scenario: Paged navigation
- **WHEN** the user opens the "Exam Review" screen
- **THEN** the system SHALL display the first question fetched from the real server review items.
- **AND** the system SHALL provide "Previous" and "Next" buttons to navigate between question cards.

### Requirement: On-card Solution Detail
The system SHALL display the detailed solution directly on the question card.

#### Scenario: Reviewing for explanation
- **WHEN** the user views a question card
- **THEN** the card SHALL show:
  * Full Question Text HTML rendered correctly
  * User's Selected Answer (highlighted in red if wrong, green if right)
  * Correct Answer (highlighted in green)
  * Detailed Explanation (using the standard blue explanation block)
  * Percentage of users who answered correctly

### Requirement: Result Filtering Options
The system SHALL provide filter options (e.g. chips) at the top or in a filter bar to filter questions by their correctness status.

#### Scenario: Applying filters
- **WHEN** the user selects the "Wrong" filter
- **THEN** only questions that were answered incorrectly SHALL be part of the paged review available for navigation.
- **AND** the count badge on the filter option SHALL match the number of filtered items.
- **AND** the "All" filter SHALL reset the view to include every question in the test.
