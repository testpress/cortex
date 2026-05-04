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
- **WHEN** reading `PromotionalBanners` and `QuickAccessGrid`
- **THEN** these components rely on mock data objects but use dynamic UI rendering logic, awaiting the full database integration.
- **BUT** for `HeroBannerCarousel`, the Learners section, and the **"What's New" section**, the system MUST now fetch live data from the backend/database cache.

#### Scenario: Single Learners Provider
- **WHEN** the Learners section renders
- **THEN** it MUST consume data from the single `learnersProvider`
- **AND** the UI component itself MUST partition the single list into the top 3 (podium) and the remaining list (ranks 4-10) without requiring separate backend or provider calls.

#### Scenario: What's New Feed Connectivity
- **WHEN** the "What's New" section renders on the home screen
- **THEN** it MUST consume data from the `whatsNewLessonsProvider`
- **AND** it MUST reflect real lesson metadata (Title, Chapter Name, Content Type) instead of hardcoded mock data.
