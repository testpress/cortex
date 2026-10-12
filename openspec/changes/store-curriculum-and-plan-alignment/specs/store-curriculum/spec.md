## MODIFIED Requirements

### Requirement: View Curriculum
The system SHALL display the curriculum structure for a given product, scoping courses to base product courses and rendering the chapter and lesson hierarchy.

#### Scenario: View Curriculum Tab with base courses
- **WHEN** user switches to the curriculum tab
- **THEN** system displays only base product courses (excluding courses bundled exclusively into subscription plans)

#### Scenario: Expand course curriculum to view chapters
- **WHEN** user expands a course in the curriculum
- **THEN** system fetches and renders the list of chapters for that course with expandable chapters and lesson details instead of summary count badges

#### Scenario: Expand chapter to view contents
- **WHEN** user expands a leaf chapter
- **THEN** system fetches and renders chapter contents with content type icons and locked badge

#### Scenario: Re-expand already viewed chapters
- **WHEN** user collapses and re-expands an already fetched chapter
- **THEN** system displays the cached contents immediately without refetching from network or flickering a loading skeleton
