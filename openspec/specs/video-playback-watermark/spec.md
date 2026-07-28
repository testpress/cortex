# video-playback-watermark Specification

## Purpose
TBD - created by archiving change video-watermark. Update Purpose after archive.
## Requirements
### Requirement: Configure video watermark from backend data
The system SHALL interpret backend watermark configuration containing `type` and `position` to determine the display properties of the video watermark.

#### Scenario: Type is hidden
- **WHEN** the backend returns the `hidden` type
- **THEN** no watermark is displayed on the video player

#### Scenario: Type is static
- **WHEN** the backend returns the `static` type with a valid position
- **THEN** the watermark is displayed at the fixed position corresponding to the backend data

#### Scenario: Type is dynamic
- **WHEN** the backend returns the `dynamic` type
- **THEN** the watermark is animated using a ping-pong movement across the screen

### Requirement: Static watermark positioning
When the watermark type is static, the system MUST map the string position to exact coordinates for the player SDK.

#### Scenario: Position mapping
- **WHEN** the static position is provided
- **THEN** it maps top-left to (0,0), top-right to (100,0), bottom-left to (0,100), bottom-right to (100,100), and middle to (50,50)

### Requirement: Watermark data content
The watermark MUST display the current user's identifying information.

#### Scenario: User identifying text
- **WHEN** the watermark is configured for display
- **THEN** the text displayed SHALL be the current user's username (falling back to the literal string 'user' if unavailable)

