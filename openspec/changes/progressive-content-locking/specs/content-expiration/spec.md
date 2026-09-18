## ADDED Requirements
### Requirement: Display expiration status in content list
The system SHALL display an indicator for content that has expired in the content list using a calendar clock icon to distinguish from progressive locks.

#### Scenario: Viewing an expired content item in the list
- **WHEN** a content item in the list has `has_ended` set to true
- **THEN** a `calendarClock` icon is displayed for that item
- **THEN** the text "Access expired on <end_date>" is displayed, where `<end_date>` is parsed from the `end` field into a readable format.

### Requirement: Render Expired Notice View in Player
The system SHALL render an expiration notice and disable interaction actions while preserving footer navigation when an expired lesson is navigated to within the lesson orchestrator.

#### Scenario: Viewing an expired lesson in orchestrator
- **WHEN** `LessonDetailOrchestrator` receives a lesson with `hasEnded == true`
- **THEN** `ContentNoticeView` is displayed with a `calendarClock` icon and localized expiration text
- **AND** Bookmark, Mark as completed, Download, and Ask Doubt FAB actions are disabled
- **AND** Previous and Next footer navigation remains functional
