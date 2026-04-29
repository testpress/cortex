# forum-post Specification

## Purpose
TBD - created by archiving change lms-forum-main. Update Purpose after archive.
## Requirements
### Requirement: Thread Isolation
The system SHALL strictly isolate discussion threads to the course context.

#### Scenario: Viewing course discussions
- **WHEN** a user selects a specific course from the Forum entry screen
- **THEN** the system SHALL fetch only threads associated with that courseId
- **AND** the UI SHALL display the threads in a chronologically sorted list

### Requirement: Social Metadata
The system SHALL display social metadata and authorship as per the design reference.

#### Scenario: Displaying thread summary
- **WHEN** the thread list is rendered
- **THEN** each item SHALL display metadata (voting scores, reply counts, and author details) following the design reference.

### Requirement: Resolution Indicators
The system SHALL indicate thread resolution states as per the design reference.

#### Scenario: Identifying thread status
- **WHEN** a thread has an 'answered' or 'unanswered' status
- **THEN** the UI SHALL render the appropriate status indicator as defined in the design reference.

