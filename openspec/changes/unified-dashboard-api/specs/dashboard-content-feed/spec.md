## MODIFIED Requirements

### Requirement: Resume learning feed shape
The system SHALL parse the `resume_learning` section from the unified API response, which is a nested object, and flatten it into `DashboardContentDto` items for the DB.

#### Scenario: Resume items mapped from nested response
- **WHEN** `resume_learning` is parsed from the unified response
- **THEN** each `content_attempt` entry is joined with its matching `user_videos` entry (via `user_video_id`)
- **THEN** video title is sourced from `user_videos[].video_content.title`
- **THEN** total duration is sourced from `user_videos[].video_content.duration`
- **THEN** remaining duration is sourced from `user_videos[].remaining_duration`
- **THEN** progress is sourced from `user_videos[].watched_percentage`
- **THEN** cover image is sourced from `chapter_contents[].cover_image_medium` (matched by `chapter_content_id`)
- **THEN** each mapped item is stored in the DB under `DashboardSectionType.resumeLearning`

#### Scenario: Missing user_video entry is skipped
- **WHEN** a `content_attempt` has a `user_video_id` that has no matching entry in `user_videos`
- **THEN** that content attempt is skipped and not stored in the DB

### Requirement: Completed learning feed replaces recently completed feed
The system SHALL parse the `completed_learning` section (renamed from `recently_completed`) and store it under `DashboardSectionType.completedLearning`.

#### Scenario: Completed items mapped and stored
- **WHEN** `completed_learning` is parsed from the unified response
- **THEN** content attempts with `state == "Completed"` are mapped using the same join logic as resume learning
- **THEN** items are stored in the DB under `DashboardSectionType.completedLearning`

#### Scenario: DashboardSectionType enum reflects rename
- **WHEN** code references `DashboardSectionType.recentlyCompleted`
- **THEN** a compile error occurs (enum value does not exist)
- **WHEN** code references `DashboardSectionType.completedLearning`
- **THEN** it compiles successfully

### Requirement: What's new feed shape
The system SHALL parse the `whats_new` section from the unified response, extracting newly added contents and matching them with their chapters.

#### Scenario: What's new items mapped from nested response
- **WHEN** `whats_new` is parsed from the unified response
- **THEN** each chapter content is mapped to a dashboard feed item with progress set to null (as it represents new, unattempted content)
- **THEN** chapter name is resolved from the corresponding `chapters` list
- **THEN** items are stored in the DB under `DashboardSectionType.whatsNew`

## REMOVED Requirements

### Requirement: Individual per-section dashboard refresh
**Reason**: Replaced by the unified `refreshDashboard()` call. Maintaining 5 separate refresh triggers adds complexity with no benefit now that the server provides all data in one call.
**Migration**: Replace all calls to `refreshHeroBanners()`, `refreshWhatsNewFeed()`, `refreshResumeLearningFeed()`, `refreshRecentlyCompletedFeed()` with a single call to `refreshDashboard()`.
