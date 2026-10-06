# course-access-approval Specification

## Purpose
TBD - created by archiving change course-access-approval-flow. Update Purpose after archive.
## Requirements
### Requirement: Course Action Button Rendering
The system SHALL display a dynamic action button on course cards that require external registration or administrative approval instead of standard course completion/progress elements.

#### Scenario: Course requires package request
- **WHEN** a course has a non-empty `externalContentLink` and `externalLinkLabel` is "REQUEST PACKAGE"
- **THEN** the course card renders an action button titled "REQUEST PACKAGE"
- **AND** the standard progress bar / percentage indicators are omitted.

#### Scenario: Course registration is pending approval
- **WHEN** a course has a non-empty `externalContentLink` and `externalLinkLabel` is "Pending Approval"
- **THEN** the course card renders an action button titled "Pending Approval" (or configured resubmit label)
- **AND** the standard progress bar / percentage indicators are omitted.

#### Scenario: Course is fully approved and accessible
- **WHEN** a course has an empty or null `externalContentLink` (and `externalLinkLabel` is "Contents" or similar)
- **THEN** the course card renders standard progress metrics and opens the course curriculum directly on tap without showing registration action buttons.

### Requirement: In-App Registration WebView Flow
The system SHALL launch an in-app WebView for courses requiring external registration, allowing the web flow to handle registration, approval notices, and re-appeal UI, and refresh course access state upon return.

#### Scenario: Launching enrollment form
- **WHEN** the user taps the action button or the course card for a course requiring registration
- **THEN** the system navigates to `CourseEnrollmentScreen` loading the URL specified in `externalContentLink`.

#### Scenario: Exiting enrollment flow
- **WHEN** the user exits the enrollment WebView screen
- **THEN** navigating back triggers a refresh of the course list so the card reflects any updated approval state.

### Requirement: Course Content Access Guard
The system SHALL prevent direct navigation into chapters and lessons for courses that have an active `externalContentLink`.

#### Scenario: Direct access attempt on locked course
- **WHEN** a navigation event attempts to open chapters or lessons of an unapproved course
- **THEN** the system redirects the user to the registration WebView flow rather than making unauthorized content requests.

