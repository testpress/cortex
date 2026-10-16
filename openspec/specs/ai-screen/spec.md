# ai-screen Specification

## Purpose
Revamped root screen focusing on onboarding and navigation to immersive experiences.
## Requirements
### Requirement: Direct Chat Interface
The system SHALL present a direct, focused conversational AI chat interface connected to the active Riverpod chat controller.

#### Scenario: Direct access to chat interface
- **WHEN** the user opens the root AI screen
- **THEN** the system SHALL display the direct chat interface with a clean empty canvas and composer ready for interaction.

### Requirement: Composer Submission Keyboard Dismissal
The system SHALL dismiss the software keyboard upon message submission to prevent unexpected keyboard popups when generation completes.

#### Scenario: Unfocus on submit
- **WHEN** the user submits a message via the composer
- **THEN** the system SHALL immediately clear the input and drop focus from the text field (`_focusNode.unfocus()`).
- **NOTE**: Dismissing the keyboard after each send prevents Flutter from automatically reopening the soft keyboard when the AI response arrives and the composer is re-enabled. While this trade-off slows rapid follow-up entries, it avoids jarring screen shifts while reading responses.

