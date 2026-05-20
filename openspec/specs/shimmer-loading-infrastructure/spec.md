# shimmer-loading-infrastructure Specification

## Purpose
Support structural loading states with `Skeletonizer` for dashboard surfaces and the Study tab course list.
## Requirements
### Requirement: Global Skeletonizer Support
The system SHALL support wrapping dashboard components in a `Skeletonizer` widget to provide structural loading states.

#### Scenario: Dashboard loading with skeletons
- **WHEN** the user opens the app and dashboard data is being fetched
- **THEN** the system displays shimmer skeleton placeholders that match the layout of the final widgets

### Requirement: Pure Providers with UI-Local Skeleton Placeholders
Providers for dashboard feeds SHALL remain pure and return only real stream data, loading, or error states. Skeleton placeholder objects, if needed, SHALL be created only in the UI layer.

#### Scenario: First install with empty cache
- **WHEN** the app is launched for the first time and `dashboardRepository.watchHeroBanners()` is called
- **THEN** the provider emits database-backed stream values (including empty lists while loading)
- **AND** the UI decides whether to show skeleton structures

### Requirement: Zero-Height Prevention
Dashboard widgets (like `HeroBannerCarousel`) SHALL NOT return `SizedBox.shrink()` when empty if they are being skeletonized.

#### Scenario: Maintaining carousel height during load
- **WHEN** `HeroBannerCarousel` receives an empty list but skeletonization is enabled
- **THEN** it maintains its standard aspect ratio and displays shimmer blocks instead of disappearing

### Requirement: Backend Empty Emission Handling
The system SHALL treat backend empty emissions as valid final data and exit skeleton state once bootstrap loading completes.

#### Scenario: Empty list returned after bootstrap refresh
- **WHEN** dashboard refresh completes and a section feed resolves to an empty list from backend
- **THEN** the section renders its empty-state layout
- **AND** the section does not remain in skeleton mode

### Requirement: Study Course List Skeleton Support
The system SHALL support the Study tab course list structural loading state by skeletonizing the real course card layout.

#### Scenario: Real layout skeletonization
- **WHEN** the Study tab course list is in its loading state
- **THEN** the system SHALL wrap the real course card list in `Skeletonizer`
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
