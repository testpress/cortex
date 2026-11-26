## ADDED Requirements

### Requirement: YouTube Embed Related Video Restriction
The embedded iframe viewer SHALL enforce the `rel=0` query parameter on any YouTube embed URL before rendering to restrict end-screen recommendations to videos from the same channel. Existing query parameters SHALL be preserved, and duplicate `rel` parameters SHALL be avoided.

#### Scenario: Enforcing rel=0 on plain YouTube embed URL
- **WHEN** an iframe with `src="https://www.youtube.com/embed/dQw4w9WgXcQ"` is loaded
- **THEN** the URL is transformed to include `rel=0` (e.g. `https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0`) before the iframe HTML is generated

#### Scenario: Preserving existing query parameters when appending rel=0
- **WHEN** an iframe with `src="https://www.youtube.com/embed/dQw4w9WgXcQ?start=30&autoplay=1"` is loaded
- **THEN** existing query parameters are preserved and `rel=0` is merged (e.g. `https://www.youtube.com/embed/dQw4w9WgXcQ?start=30&autoplay=1&rel=0`)

#### Scenario: Overriding existing rel parameter or idempotent handling
- **WHEN** an iframe with `src="https://www.youtube.com/embed/dQw4w9WgXcQ?rel=1"` or already containing `rel=0` is loaded
- **THEN** the `rel` parameter is set to `0` without duplicating parameters

#### Scenario: Non-YouTube URLs remain untouched
- **WHEN** an iframe with a non-YouTube URL (e.g. `https://player.vimeo.com/video/12345`) is loaded
- **THEN** the URL is not modified by YouTube embed parameter rules
