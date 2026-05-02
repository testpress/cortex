## ADDED Requirements

### Requirement: Simple Video-First Layout
The system SHALL render a simplified layout for live stream lessons focused on video playback.

#### Scenario: Live lesson detail view
- **WHEN** a live stream lesson is opened
- **THEN** the screen SHALL render the video player at the top
- **AND** it SHALL render a stable, non-interactive background below the player.

## REMOVED Requirements

### Requirement: Live Chat Embedding
The system SHALL NOT render embedded live chat in the live lesson detail view.

#### Scenario: Live stream playback screen
- **WHEN** a live stream lesson is opened
- **THEN** the screen SHALL render the video player only
- **AND** it SHALL NOT render a chat webview below the player.
