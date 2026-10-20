## ADDED Requirements

### Requirement: History Drawer Presentation
The system SHALL present conversation history as a start-side drawer over the dimmed chat screen.

#### Scenario: Opening the drawer
- **WHEN** the user opens conversation history
- **THEN** the system SHALL show a drawer with a "Chat History" title, a close button, a full-width "New Chat" button, and a divided list where each row shows the conversation title and its relative last-activity time.

#### Scenario: Dismissing the drawer
- **WHEN** the user taps the close button, taps the dimmed area outside the drawer, or uses system back
- **THEN** the system SHALL close the drawer and leave the current conversation unchanged.

#### Scenario: History rows omit unavailable metadata
- **WHEN** a conversation row is rendered
- **THEN** the system SHALL NOT show a subject chip or a message preview.

#### Scenario: Reduced motion
- **WHEN** the user has reduced motion enabled
- **THEN** the drawer SHALL appear and disappear without slide or fade animation.
