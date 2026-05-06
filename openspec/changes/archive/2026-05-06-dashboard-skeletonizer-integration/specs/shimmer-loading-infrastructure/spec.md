## ADDED Requirements

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
