# video-lesson-viewer Specification

## Purpose
TBD - created by archiving change video-ai-chat-mcq. Update Purpose after archive.
## Requirements
### Requirement: LearnLens Metadata Parsing & Persistence
The system SHALL parse `is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status` from the video lesson API payload and persist them in the local database.

#### Scenario: Parsing Lesson Payload
- **WHEN** a video lesson payload is fetched
- **THEN** `LessonDto` extracts `is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status` from the `video` JSON object and stores them in `LessonsTable`.

### Requirement: AI Tab Orchestration
The system SHALL orchestrate the visibility of AI-related tabs based on backend flags.

#### Scenario: Enabling AI Tabs
- **WHEN** a lesson has `is_ai_enabled: true`, `can_enable_learnlens_ai: true`, and `learnlens_asset_status: "Completed"`
- **THEN** the system renders the AI Chat and MCQ tabs in the video subtabs view.

#### Scenario: Disabling AI Tabs
- **WHEN** any of the required AI flags (`is_ai_enabled`, `can_enable_learnlens_ai`, or `learnlens_asset_status == "Completed"`) are false/missing
- **THEN** the system hides the AI Chat and MCQ tabs.

