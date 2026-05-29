# exam-review-analytics Specification

## Purpose
TBD - created by archiving change integrate-exam-review-analytics. Update Purpose after archive.
## Requirements
### Requirement: Unified Solutions and Analytics DTOs
The system SHALL define structured and parsing-safe DTO classes for Review Items, Questions, Answers, and Subject Analytics. The `AttemptDto` SHALL include a `timeTaken` field mapped from the `time_taken` field in the attempt API response.

#### Scenario: Parse Review Item DTO
- **WHEN** the API returns a JSON representation of a review item
- **THEN** the system SHALL successfully deserialize it into a `ReviewItemDto` object with correct types and fields

#### Scenario: Parse Subject Analytics DTO
- **WHEN** the API returns a JSON representation of subject stats
- **THEN** the system SHALL successfully deserialize it into a `SubjectAnalyticsDto` object

#### Scenario: Parse `time_taken` from attempt response
- **WHEN** the attempt end API returns a response containing a `time_taken` field
- **THEN** the system SHALL map it to `AttemptDto.timeTaken` as a `String?`
- **AND** if `time_taken` is absent from the response, `AttemptDto.timeTaken` SHALL be `null`

### Requirement: Real Backend Solutions Fetching
The system SHALL query the standard backend solutions endpoint using the modified review URL to fetch actual, complete question reviews.

#### Scenario: Fetch review items successfully
- **WHEN** a user triggers the Solutions Review flow
- **THEN** the system SHALL request the review items from the translated endpoint `/api/v2.2.1/attempts/<attempt_id>/review/`
- **AND** the system SHALL return the full list of `ReviewItemDto`s

### Requirement: Exam Metadata Forwarded to Analytics
The system SHALL carry `ExamDto` through the review route payload so the analytics screen can access exam-level configuration — specifically `duration`, `markPerQuestion`, and `negativeMarks` — without re-fetching.

#### Scenario: ExamDto available in analytics after exam submission
- **WHEN** a user submits an exam and navigates to `ReviewAnalyticsScreen`
- **THEN** the `ReviewRoutePayload` SHALL contain the `ExamDto` that was active during the exam session

#### Scenario: ExamDto absent when accessing analytics from history
- **WHEN** a user accesses `ReviewAnalyticsScreen` from exam history (not immediately post-submission)
- **THEN** `ReviewRoutePayload.exam` SHALL be `null`
- **AND** the analytics screen SHALL handle this gracefully by showing `-` for any metric that requires exam-level configuration
