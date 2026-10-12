## MODIFIED Requirements

### Requirement: View Curriculum
The system SHALL display the curriculum structure for a given product, scoping courses to base product courses and rendering the chapter and lesson hierarchy with distinction between locked and free preview contents.

#### Scenario: View Curriculum Tab with base courses
- **WHEN** user switches to the curriculum tab
- **THEN** system displays only base product courses (excluding courses bundled exclusively into subscription plans)

#### Scenario: Expand course curriculum to view chapters
- **WHEN** user expands a course in the curriculum
- **THEN** system fetches and renders the list of chapters for that course with expandable chapters and lesson details instead of summary count badges

#### Scenario: Expand chapter to view contents
- **WHEN** user expands a leaf chapter
- **THEN** system fetches and renders chapter contents with content type icons, displaying a "Buy to Unlock" badge for locked contents and a "Free Preview" badge for unlocked or previewable contents

#### Scenario: Re-expand already viewed chapters
- **WHEN** user collapses and re-expands an already fetched chapter
- **THEN** system displays the cached contents immediately without refetching from network or flickering a loading skeleton

## ADDED Requirements

### Requirement: Launch Free Preview Lesson
The system SHALL allow non-enrolled users to launch and view free preview lessons directly from the store curriculum.

#### Scenario: User taps free preview lesson
- **WHEN** user taps on a lesson tile or badge marked as free preview
- **THEN** the system navigates to the lesson detail viewer orchestrator for that lesson in preview mode

#### Scenario: User navigates preview lesson without adjacent controls
- **WHEN** user views a preview lesson launched from the store
- **THEN** the system omits next and previous lesson navigation controls to prevent advancing into un-enrolled content

#### Scenario: User navigates preview lesson without learner actions
- **WHEN** user views a preview lesson launched from the store
- **THEN** the system omits bookmarks, "mark as completed", offline downloads, and helpdesk ask doubt capabilities to keep the preview focused and avoid permission errors on un-enrolled content

#### Scenario: User taps locked lesson
- **WHEN** user taps on a lesson tile or badge marked as locked
- **THEN** the system opens the purchase plan selection sheet
