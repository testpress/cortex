# shimmer-loading-infrastructure Specification

## MODIFIED Requirements

### Requirement: Study Course List Skeleton Support
The system SHALL support the Study tab course list structural loading state using reusable skeleton components and a shared shimmer wrapper.

#### Scenario: Reusable skeleton composition
- **WHEN** the Study tab course list is in its loading state
- **THEN** the system SHALL compose the loading UI from a reusable course skeleton card and a sliver-based list wrapper
- **AND** the screen shell SHALL remain responsible only for choosing when to show the loading state

#### Scenario: Study course list loading
- **WHEN** the Study tab course list is fetching its initial data
- **THEN** the system displays shimmer skeleton placeholders that match the layout of the course cards
- **AND** the section header remains outside the skeleton boundary
- **AND** the skeleton state remains visible during the initial sync even if cached courses are already available

#### Scenario: Pagination skeleton alignment
- **WHEN** the Study tab course list is fetching the next page of courses
- **THEN** the trailing skeleton card SHALL use the same horizontal inset and card proportions as the loaded course cards
- **AND** it SHALL not span the full width of the scroll area
