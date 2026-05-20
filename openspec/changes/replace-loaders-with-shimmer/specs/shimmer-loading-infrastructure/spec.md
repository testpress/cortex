# shimmer-loading-infrastructure Specification

## MODIFIED Requirements

### Requirement: Study Course List Skeleton Support
The system SHALL support the Study tab course list structural loading state by skeletonizing the real course card layout.

#### Scenario: Real layout skeletonization
- **WHEN** the Study tab course list is in its loading state
- **THEN** the system SHALL wrap the real course card list in a single `SliverSkeletonizer` (or `Skeletonizer`)
- **AND** the `enabled` property of `SliverSkeletonizer` SHALL be dynamically bound to the loading state (e.g., `enabled: showInitialLoader`) following the official documentation pattern
- **AND** the screen shell SHALL remain responsible only for choosing when to show the loading state
- **AND** targeted annotations MAY be used where a specific shape must be preserved

#### Scenario: Study course list loading
- **WHEN** the Study tab course list is fetching its initial data
- **THEN** the system displays shimmer skeleton placeholders that match the layout of the course cards
- **AND** the section header remains outside the skeleton boundary
- **AND** the skeleton state remains visible during the initial sync even if cached courses are already available

#### Scenario: Pagination skeleton alignment
- **WHEN** the Study tab course list is fetching the next page of courses
- **THEN** the trailing skeleton card SHALL use the same horizontal inset and card proportions as the loaded course cards
- **AND** it SHALL not span the full width of the scroll area
