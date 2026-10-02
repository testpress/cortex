# Spec Delta

## ADDED Requirements

### Requirement: AI Chat UI Layout and Theming
The system SHALL display the AI Chat tab with a white background, grey AI response bubble containers, avatars for both AI and user messages, message timestamps, and a styled interactive send button.

#### Scenario: AI Chat Messages Rendering
- **WHEN** the user views the AI Chat tab
- **THEN** the screen background SHALL be white
- **AND** the AI response message bubbles SHALL have a light grey background
- **AND** AI messages SHALL display a neutral sparkles avatar on the left
- **AND** user messages SHALL display a profile avatar on the right
- **AND** messages SHALL display fixed creation timestamps in 24hr format (`HH:mm`) under each bubble
- **AND** the send button SHALL render with a themed background container and paper plane icon
- **AND** the text field border SHALL highlight when focused or containing text
