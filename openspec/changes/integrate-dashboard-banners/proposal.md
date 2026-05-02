## Why

Currently, the Hero Banners on the dashboard use hardcoded mock data. Integrating with the real `/api/v2.4/banner-ads/` endpoint allows the app to display dynamic, institute-specific promotional banners managed via the Testpress backend.

## What Changes

- **API Configuration**: Added the dashboard endpoint to the central API configuration.
- **Data Models**: Updated `DashboardBannerDto` to support JSON deserialization from the real API response format (specifically the `banner_ads` array).
- **Data Source**: Implemented banner fetching in `HttpDataSource`.
- **Offline Caching**: Added `DashboardBannersTable` and `DashboardRepository` to persist banners locally in Drift DB.
- **Image Optimization**: Integrated `cached_network_image` for persistent disk caching of banner images.
- **State Management**: Connected `heroBannersProvider` to the new `DashboardRepository` as a stream.

## Capabilities

### New Capabilities
- `api-dashboard-banners`: Defines the contract and mapping for the dashboard banner ads retrieved from the backend.
- `offline-banners`: Provides local persistence for banners, enabling instant load and offline access.
- `cached-images`: Ensures banner images are stored on disk to reduce bandwidth and improve performance.

### Modified Capabilities
- `lms-home-paid-active`: Updated to reflect the transition from mock-only to real API integration for the Hero Banner section.

## Impact

- **Affected Packages**: `core` (API and Data Sources), `courses` (Models and Providers).
- **Network**: New GET request to `/api/v2.4/banner-ads/`.
- **UI**: No visual changes expected, but banners will now reflect real backend content.
