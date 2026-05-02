## ADDED Requirements

### Requirement: Dynamic Content Layouts
The `LessonDetailShell` SHALL support a stable live-stream presentation without rendering embedded chat content.

#### Scenario: Live stream shell presentation
- **WHEN** a live stream lesson is active
- **THEN** the shell SHALL keep the video area fixed at the top
- **AND** the content area below SHALL be rendered as a non-interactive filler region.
