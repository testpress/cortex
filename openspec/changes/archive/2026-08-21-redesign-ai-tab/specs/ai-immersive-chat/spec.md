## Purpose

Provides a full conversational chat interface with mock AI responses and typewriter typing indicators.

## ADDED Requirements

### Requirement: Interactive conversational chat flow
The system SHALL display the message history and allow the user to send new messages, resulting in typewriter-animated mock AI responses.

#### Scenario: User sends a message
- **WHEN** the user submits a message in the immersive chat
- **THEN** the message is appended to the list, a bouncing typing indicator is briefly displayed, and a mock AI response is printed character by character.
