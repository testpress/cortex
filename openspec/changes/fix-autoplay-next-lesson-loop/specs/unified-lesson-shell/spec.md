## MODIFIED Requirements

### Requirement: AutoPlay Next Video Evaluation
The lesson shell SHALL evaluate whether to automatically navigate to the next lesson when a video completes. The completion event SHALL NOT trigger automatic navigation if the video was initialized or seeked to a near-end position on initial load.

#### Scenario: AutoPlay enabled
- **WHEN** a video lesson completes naturally, and the `autoPlayNext` user setting is enabled
- **THEN** the system SHALL automatically navigate to the next lesson, regardless of its content type.

#### Scenario: AutoPlay disabled
- **WHEN** a video lesson completes and the `autoPlayNext` user setting is disabled
- **THEN** the system SHALL NOT automatically navigate to the next lesson.

#### Scenario: Video loaded at the end with AutoPlay enabled
- **WHEN** a video lesson is opened, and the initial position is at or near the end of the video
- **THEN** the system SHALL NOT trigger a completion event or automatically navigate to the next lesson.
