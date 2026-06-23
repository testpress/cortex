## ADDED Requirements

### Requirement: Exam Completion Badge Visibility
The system SHALL display a green circular tick badge on a `ChapterContentItem` when the lesson's `hasAttempts` field is `true` AND the lesson type is `LessonType.test` or `LessonType.assessment`.

#### Scenario: Exam card with at least one attempt
- **WHEN** the user views a chapter content list containing an exam lesson where `hasAttempts == true`
- **THEN** the system renders a green circular badge with a white checkmark icon on the top-right corner of the left-hand thumbnail image, overlapping its boundary

#### Scenario: Exam card with no attempts
- **WHEN** the user views a chapter content list containing an exam lesson where `hasAttempts == false`
- **THEN** the system renders no completion badge on that card

### &nbsp;Requirement: Attempt Synchronization Logic
When parsing `/content_attempts/` API responses, the system SHALL determine the completion and attempt state of lessons solely from the actual attempt records in the `content_attempts` array, not from the `chapter_contents` sidecar list.
- If a lesson does not have a matching completed attempt record (where the nested attempt `state` is finished/completed) in the `content_attempts` array, its `hasAttempts` field SHALL be `false` and its progress status SHALL be `notStarted`.
- If a lesson has a matching completed attempt record (where the nested attempt `state` is finished/completed) in the `content_attempts` array, its `hasAttempts` field SHALL be `true` and its progress status SHALL be `completed`.

### Requirement: Badge Restricted to Exam Content Types
The system SHALL NOT render the completion badge on non-exam content types (video, PDF, notes, attachment, live stream), even if `hasAttempts` is `true` for those items.

#### Scenario: Video lesson with attempts
- **WHEN** the user views a chapter content list containing a video lesson where `hasAttempts == true`
- **THEN** the system does NOT render a green tick badge on that card

### Requirement: Badge Uses Design System Tokens
The completion badge SHALL use `design.colors.accent4` as its background colour and `LucideIcons.check` as its icon, with a fixed size of 20×20 dp, icon size of 11 dp, and a 1.5 dp card-colored border.

#### Scenario: Badge colour in light theme
- **WHEN** the app is in light mode and a completed exam card is displayed
- **THEN** the badge background uses `design.colors.accent4` (green token) without any hardcoded colour values

#### Scenario: Badge colour in dark theme
- **WHEN** the app is in dark mode and a completed exam card is displayed
- **THEN** the badge background uses `design.colors.accent4` and adapts to the dark theme automatically via the design token
