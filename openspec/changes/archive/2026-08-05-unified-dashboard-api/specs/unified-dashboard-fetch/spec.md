## ADDED Requirements

### Requirement: Dashboard data fetched from a single endpoint
The system SHALL fetch all dashboard content (banners, resume learning, what's new, completed learning, leaderboard) from a single HTTP request to `GET /api/v3/dashboard/`.

#### Scenario: Successful unified fetch
- **WHEN** `getDashboard()` is called on the DataSource
- **THEN** the system makes exactly one HTTP request to `/api/v3/dashboard/`
- **THEN** returns a `DashboardResponseDto` containing all 5 sections

#### Scenario: Network failure during unified fetch
- **WHEN** the network request to `/api/v3/dashboard/` fails
- **THEN** the error is caught in `refreshDashboard()` on the repository
- **THEN** a debug message is logged and no DB write occurs
- **THEN** existing cached data in the DB remains unchanged

### Requirement: Dashboard repository refreshes all sections atomically
The system SHALL provide a single `refreshDashboard()` method on `DashboardRepository` that fetches the unified response and persists all sections to the DB.

#### Scenario: All sections persisted on successful fetch
- **WHEN** `refreshDashboard()` is called and the network request succeeds
- **THEN** banners, resume learning, what's new, completed learning, and leaderboard are all written to the local DB
- **THEN** each feed section is wiped and re-inserted (replacing stale data)

#### Scenario: Dashboard bootstrap uses single refresh call
- **WHEN** `dashboardBootstrap` provider is executed
- **THEN** it calls `repository.refreshDashboard()` exactly once
- **THEN** it does NOT call `refreshHeroBanners`, `refreshWhatsNewFeed`, `refreshResumeLearningFeed`, or `refreshRecentlyCompletedFeed` separately

### Requirement: Old per-section fetch methods removed
The system SHALL NOT expose individual fetch methods for dashboard sections that are now covered by the unified endpoint.

#### Scenario: DataSource no longer has old methods
- **WHEN** code references `getDashboardBanners()`, `getWhatsNewFeed()`, `getResumeLearningFeed()`, or `getRecentlyCompletedFeed()` on the DataSource
- **THEN** a compile error occurs (methods do not exist)

#### Scenario: Old endpoint constants removed from ApiEndpoints
- **WHEN** code references `ApiEndpoints.bannerAds`, `ApiEndpoints.resumeLearning`, `ApiEndpoints.whatsNewFeed`, or `ApiEndpoints.recentlyCompleted`
- **THEN** a compile error occurs (constants do not exist)

### Requirement: Mock data source implements unified dashboard fetch
The system SHALL provide a mock implementation of `getDashboard()` for development and testing.

#### Scenario: Mock returns valid DashboardResponseDto
- **WHEN** `MockDataSource.getDashboard()` is called
- **THEN** returns a `DashboardResponseDto` populated with existing mock data (banners, resume feed, whats new feed, completed feed, and an empty leaderboard list)
