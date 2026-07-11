# forum-activity-filters Specification

## Purpose
TBD - created by archiving change add-forum-filters. Update Purpose after archive.
## Requirements
### Requirement: Activity Filtering
The system SHALL support filtering forum threads based on the user's activity.

#### Scenario: User selects an activity filter
- **WHEN** a user selects an activity filter (e.g., "Posted by me") from the filter bottom sheet
- **THEN** the system SHALL fetch and display only the threads matching that activity criteria
- **AND** the system SHALL update the feed provider to maintain the active activity filter state

