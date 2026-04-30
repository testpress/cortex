# sequential-navigation Specification

## Purpose
TBD - created by archiving change integrate-lesson-detail-ui. Update Purpose after archive.
## Requirements
### Requirement: API-Driven Sequential Navigation
Navigation between lessons MUST be driven by the `next_content_id` and `previous_content_id` provided by the API completion response.

#### Scenario: Navigating to Next Lesson
- **WHEN** The "Next" button is clicked in the Navigation Footer
- **THEN** The app navigates via `context.pushReplacement()` to the ID specified in `next_content_id`.

#### Scenario: End of Chapter
- **WHEN** `next_content_id` is null or zero
- **THEN** The "Next" button should be hidden or allow exit from the chapter.

### Requirement: Video Completion Tracking
The orchestrator MUST trigger progress updates to the repository when a video reaches its end.

#### Scenario: Video reaching end
- **WHEN** Playback completes in the `TestpressPlayer`
- **THEN** The orchestrator marks the lesson as COMPLETED in the repository.

