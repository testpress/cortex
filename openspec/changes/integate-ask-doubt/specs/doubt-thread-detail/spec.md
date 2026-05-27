## ADDED Requirements

### Requirement: Mark Resolved Action
The doubt thread header or detail screen SHALL provide a button for the student to resolve their doubt.
- **Action**: Tapping "Mark Resolved" SHALL submit a POST request to `/api/v3/helpdesk/<pk>/followup/` with the body `{"should_resolve": true}` and update the status in the UI to "Resolved".

#### Scenario: Resolving a doubt
- **GIVEN** the student is viewing their active doubt details
- **WHEN** they tap "Mark Resolved"
- **THEN** the ticket is resolved on the backend and the status in the app transitions to "Resolved"

## MODIFIED Requirements

### Requirement: Plain-Text Content Rendering
The system SHALL render the doubt's description and its replies using an HTML/Rich-text rendering widget to support structural formatting, LaTeX mathematical equations, and embedded inline images.

#### Scenario: Viewing rich-text doubt body
- **WHEN** the doubt details screen is rendered
- **THEN** the system displays the content with rich formatting, LaTeX equations, and embedded inline images correctly formatted
