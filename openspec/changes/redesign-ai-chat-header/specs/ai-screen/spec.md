## MODIFIED Requirements

### Requirement: Direct Chat Interface
The system SHALL present a direct, focused conversational AI chat interface connected to the active Riverpod chat controller, with the redesigned header coordinating navigation, active title, and conversation actions.

#### Scenario: Direct access to chat interface
- **WHEN** the user opens the root AI screen
- **THEN** the system SHALL display the direct chat interface with a clean empty canvas, redesigned header, and composer ready for interaction.

#### Scenario: Header state integration
- **WHEN** an active conversation is open in the direct chat interface
- **THEN** the header reflects the active conversation title, allows resetting to a new chat, and allows deleting the conversation via the 3-dot overflow menu.
