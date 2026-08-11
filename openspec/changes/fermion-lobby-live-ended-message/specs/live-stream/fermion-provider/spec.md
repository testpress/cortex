# live-stream/fermion-provider Delta Specification

## Requirements

### Requirement: Fermion Lobby Screen

#### [MODIFY] Scenario: Completed Fermion session without recording shows ended notice
- **WHEN** a user opens a Fermion lesson with `streamStatus == "Completed"` and `showRecordedVideo == false`
- **THEN** the system SHALL display a clear ended notice on the lobby card.
- **AND** the ended notice SHALL feature:
  - An alert icon (LucideIcons.alertCircle)
  - A prominent status title ("Recording Not Available")
  - A clear explanation message ("No recording is available for this class.")
  - Styled as a plain metadata row with the icon in warning color to match the card's row layout.
