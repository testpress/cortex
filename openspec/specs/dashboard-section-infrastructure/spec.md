# dashboard-section-infrastructure Specification

## Purpose
TBD - created by archiving change integrate-whats-new-section. Update Purpose after archive.
## Requirements
### Requirement: Dashboard Mapping Table
The system SHALL maintain a dedicated database table to store the association between dashboard sections and content items (Lessons/Courses).

#### Scenario: Section-based playlist management
- **WHEN** the dashboard feed is refreshed (e.g., 'whats_new')
- **THEN** the system MUST clear all existing entries for that specific `section_type` in the mapping table
- **AND** it MUST insert the new IDs with a `display_order` reflecting the API response sequence.

#### Scenario: Cross-section data integrity
- **WHEN** a lesson exists in both a course curriculum and a dashboard section
- **THEN** the system MUST maintain a single source of truth in the `LessonsTable`
- **BUT** allow the mapping table to independently track its presence in dashboard sections.

#### Scenario: Offline dashboard loading
- **WHEN** the app is offline
- **THEN** the dashboard providers MUST query the mapping table joined with the core tables to return the last cached state of the feed instantly.

