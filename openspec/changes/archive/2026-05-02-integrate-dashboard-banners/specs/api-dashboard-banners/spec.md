## ADDED Requirements

### Requirement: Dashboard Banners API Integration
The system SHALL fetch promotional banners from the `/api/v2.4/banner-ads/` endpoint.

#### Scenario: Successfully fetching Hero Banners
- **GIVEN** a valid authentication session
- **WHEN** the dashboard is loaded
- **THEN** the system MUST request data from `/api/v2.4/banner-ads/`
- **AND** it MUST extract banners from the `results` array
- **AND** it MUST map `image` to `imageUrl` and `url` to `link`

#### Scenario: Handling Missing Banner Titles
- **GIVEN** a banner object from the API with no `title` or `description`
- **WHEN** the banner is mapped to a `DashboardBannerDto`
- **THEN** the `title` and `description` fields MUST be null
- **AND** the UI MUST handle these null values gracefully (e.g., by not displaying text overlays)
