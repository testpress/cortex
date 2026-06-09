## ADDED Requirements

### Requirement: Moderation Status Display
The system SHALL display a "Pending Moderation" badge or label next to the timestamp for comments that have not been approved (`isPublic = false`).

#### Scenario: Display pending moderation badge
- **WHEN** a user views a thread with a comment where `is_public` is false
- **THEN** the UI displays the comment with a "Pending Moderation" badge next to its timestamp.
