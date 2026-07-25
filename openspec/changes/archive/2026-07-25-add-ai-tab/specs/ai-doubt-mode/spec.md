## ADDED Requirements

### Requirement: Ask AI Mode
The doubt form SHALL support an "Ask AI" mode that submits user queries directly to the AI service.

#### Scenario: Submitting a query to AI
- **WHEN** the doubt form is in "Ask AI" mode and the user submits the form
- **THEN** the system processes the query as an AI doubt query instead of a traditional forum post

#### Scenario: Displaying AI context badge
- **WHEN** the doubt form is opened in "Ask AI" mode
- **THEN** the form displays an "ASKING AI" context badge with a sparkles icon
