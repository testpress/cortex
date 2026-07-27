# content-expiration Specification

## Purpose
TBD - created by archiving change handle-content-end-date. Update Purpose after archive.
## Requirements
### Requirement: Block access to expired content
The system SHALL block users from accessing chapter content that has expired based on its `has_ended` status, and show a toast message explaining why.

#### Scenario: User clicks on an expired content item
- **WHEN** user taps on a lesson or content item in the study list that has `has_ended` set to true
- **THEN** the system prevents navigation to the content detail
- **THEN** the system displays a toast message: "Your access to this content has ended!"

### Requirement: Display expiration status in content list
The system SHALL display an indicator for content that has expired in the content list.

#### Scenario: Viewing an expired content item in the list
- **WHEN** a content item in the list has `has_ended` set to true
- **THEN** a lock icon is displayed for that item
- **THEN** the text "Access expired on <end_date>" is displayed, where `<end_date>` is parsed from the `end` field into a readable format.

