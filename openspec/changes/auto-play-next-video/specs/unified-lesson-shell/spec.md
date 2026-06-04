## ADDED Requirements

### Requirement: AutoPlay Next Video Evaluation
The lesson shell SHALL evaluate whether to automatically navigate to the next lesson when a video completes.

#### Scenario: AutoPlay enabled
- **WHEN** a video lesson completes and the `autoPlayNext` user setting is enabled
- **THEN** the system SHALL automatically navigate to the next lesson, regardless of its content type.

#### Scenario: AutoPlay disabled
- **WHEN** a video lesson completes and the `autoPlayNext` user setting is disabled
- **THEN** the system SHALL NOT automatically navigate to the next lesson.
