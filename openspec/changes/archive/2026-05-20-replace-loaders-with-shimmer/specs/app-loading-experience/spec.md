# app-loading-experience Specification

## ADDED Requirements

### Requirement: Study Course List Uses Skeletons
The Study tab course list SHALL use structural skeleton placeholders while its initial content is loading.

#### Scenario: First load of the Study course list
- **WHEN** the Study tab course list is fetching its initial content
- **THEN** the UI SHALL show skeleton placeholders that preserve the course card layout
- **AND** the placeholder area SHALL remain the course list area rather than collapsing
- **AND** cached course rows SHALL not replace the initial skeleton while the sync is active

#### Scenario: Pagination while browsing the Study course list
- **WHEN** the Study tab course list is loading additional courses during scroll pagination
- **THEN** the UI SHALL show a trailing skeleton card that matches the course card size and inset
- **AND** the placeholder SHALL align with the existing list spacing instead of stretching edge to edge

### Requirement: Other Screens Keep Existing Loaders
Screens outside the Study tab course list SHALL keep their existing loading presentation in this change.

#### Scenario: Non-Study screen loading
- **WHEN** a screen outside the Study tab course list loads
- **THEN** it SHALL continue using its current loading style
- **AND** this change SHALL NOT require it to adopt shimmer placeholders
