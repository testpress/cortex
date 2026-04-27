## ADDED Requirements

### Requirement: Display Thread Content
The screen must display the full title and body of the discussion thread at the top of the view.

#### Scenario: View Thread
- **WHEN** a user navigates to a thread detail screen from the listing
- **THEN** the original question's full description and author metadata are shown.

### Requirement: Chronological Reply List
Replies to the thread must be displayed in a list sorted by their creation date.

#### Scenario: Display Comments
- **WHEN** the thread detail screen loads
- **THEN** it fetches and displays all related forum comments beneath the main thread content.
