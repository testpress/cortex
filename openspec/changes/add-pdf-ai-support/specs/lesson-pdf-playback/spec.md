## ADDED Requirements

### Requirement: PDF Action Entry Points and Speed Dial
The system SHALL provide a unified action floating button on PDF lessons that supports triggering both the AI Assistant and human doubt submission.

#### Scenario: Unified action FAB when both AI and Ask Doubt are available
- **WHEN** a lesson of type "pdf" is displayed
- **AND** `lesson.isAiEnabled` is true, `lesson.canEnableLearnlensAi` is true, and `lesson.learnlensAssetStatus == 'completed'`
- **AND** helpdesk/doubts is enabled for the tenant and lesson
- **THEN** the system SHALL display a single primary circular FAB with a sparkles icon.
- **AND** tapping the FAB SHALL expand an actions menu containing:
  1. "Ask AI (PDF)" action with document icon
  2. "Ask Doubt" action with question/doubt icon
- **AND** tapping "Ask AI (PDF)" SHALL dismiss the menu and present the `PdfAiBottomSheet`.
- **AND** tapping "Ask Doubt" SHALL dismiss the menu and navigate to the doubt submission screen.
- **AND** while expanded, the FAB icon SHALL display a close (X) icon.

#### Scenario: Single action when only AI Assistant is available
- **WHEN** a lesson of type "pdf" is displayed
- **AND** PDF AI Assistant is available
- **AND** helpdesk/doubts is not enabled or unavailable
- **THEN** the system SHALL display the primary circular sparkles FAB.
- **AND** tapping the FAB SHALL directly present the `PdfAiBottomSheet` without opening a menu.

#### Scenario: Single action when only Ask Doubt is available
- **WHEN** a lesson of type "pdf" is displayed
- **AND** `lesson.isDetailFetched` is true
- **AND** helpdesk/doubts is enabled
- **AND** PDF AI Assistant is not available (disabled or asset processing)
- **THEN** the system SHALL display the standard `AskDoubtFab`.

#### Scenario: Delaying fallback button during initial load
- **WHEN** a lesson of type "pdf" is displayed
- **AND** `lesson.isDetailFetched` is false (full lesson detail is in-flight)
- **THEN** the system SHALL NOT display the fallback `AskDoubtFab` prematurely until AI status is known.

#### Scenario: Both disabled
- **WHEN** neither PDF AI Assistant nor Ask Doubt is available
- **THEN** the system SHALL NOT render any floating action button over the PDF.

