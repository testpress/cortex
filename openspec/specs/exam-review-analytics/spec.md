# exam-review-analytics Specification

## Purpose
TBD - created by archiving change integrate-exam-review-analytics. Update Purpose after archive.
## Requirements
### Requirement: Unified Solutions and Analytics DTOs
The system SHALL define structured and parsing-safe DTO classes for Review Items, Questions, Answers, and Subject Analytics.

#### Scenario: Parse Review Item DTO
- **WHEN** the API returns a JSON representation of a review item
- **THEN** the system SHALL successfully deserialize it into a `ReviewItemDto` object with correct types and fields

#### Scenario: Parse Subject Analytics DTO
- **WHEN** the API returns a JSON representation of subject stats
- **THEN** the system SHALL successfully deserialize it into a `SubjectAnalyticsDto` object

### Requirement: Real Backend Solutions Fetching
The system SHALL query the standard backend solutions endpoint using the modified review URL to fetch actual, complete question reviews.

#### Scenario: Fetch review items successfully
- **WHEN** a user triggers the Solutions Review flow
- **THEN** the system SHALL request the review items from the translated endpoint `/api/v2.2.1/attempts/<attempt_id>/review/`
- **AND** the system SHALL return the full list of `ReviewItemDto`s

