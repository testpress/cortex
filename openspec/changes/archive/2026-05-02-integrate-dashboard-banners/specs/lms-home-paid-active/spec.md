## MODIFIED Requirements

### Requirement: Offline-First Scaffold Architecture
The system SHALL organize data models and UI state following an offline-first repository pattern utilizing Riverpod providers.

#### Scenario: Mock Provider Usage
- **WHEN** the `TodaySnapshot` and `StudyMomentum` components render
- **THEN** they MUST strictly read data from Riverpod mock providers (`todayClassesProvider`, `studyMomentumProvider`) to prepare the UI for the future Drift DB offline-first data layer (completed in `lms-data-layer`).

#### Scenario: Localization implementation
- **WHEN** rendering dynamic text components (headers, captions, badges)
- **THEN** they MUST use `L10n.of(context)` for all user-facing strings to support internationalization.

#### Scenario: Temporary Hardcoded Data Models
- **WHEN** reading `PromotionalBanners`, `TopLearnersSection`, and `QuickAccessGrid`
- **THEN** these components rely on mock data objects but use dynamic UI rendering logic, awaiting the full database integration.
- **BUT** for `HeroBannerCarousel`, the system MUST now fetch live data from the backend as specified in the `api-dashboard-banners` capability.
