## ADDED Requirements

### Requirement: PDF AI Assistant Bottom Sheet
The system SHALL provide a modal bottom sheet interface (`PdfAiBottomSheet`) hosting the conversational AI chat interface (`AITab`) scoped to the active PDF lesson's content ID and `learnlensAssetId`.

#### Scenario: Opening AI Assistant bottom sheet
- **WHEN** the user taps the AI Assistant trigger in a PDF lesson
- **THEN** the system SHALL present a modal bottom sheet displaying the AI chat interface with a top drag handle, header title, and close action.
- **AND** the chat interface SHALL initialize with a document-focused greeting and prompt composer.

#### Scenario: Keyboard interaction in bottom sheet
- **WHEN** the user focuses the text composer within the bottom sheet
- **THEN** the system SHALL inset the sheet above the software keyboard so that the composer and recent chat messages remain visible.

#### Scenario: Closing AI Assistant bottom sheet
- **WHEN** the user taps the close button or drags down the modal sheet
- **THEN** the system SHALL dismiss the bottom sheet and return the user to the PDF viewer without resetting document scroll position.

