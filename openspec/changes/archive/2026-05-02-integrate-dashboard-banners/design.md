## Context

The current dashboard implementation in the `testpress` package relies on hardcoded mock data for all sections, including the Hero Banner carousel. To move towards a production-ready application, we need to integrate the real backend API (`/api/v2.4/banner-ads/`) specifically for these banners.

## Goals / Non-Goals

**Goals:**
- Implement a real network request to fetch banners from the `/api/v2.4/banner-ads/` endpoint.
- Implement offline caching using Drift DB to allow instant display of last-known banners.
- Use `CachedNetworkImage` for persistent disk caching of banner images.
- Update the `DashboardBannerDto` model to handle the real API response format.
- Ensure the `heroBannersProvider` automatically switches to the real API when a backend is available.
- Gracefully handle cases where the API provides image URLs but lacks text metadata (titles/descriptions).

**Non-Goals:**
- Integrating other dashboard sections like Announcements, Top Learners, or Quick Shortcuts (these will remain mock for now).
- Modifying the UI components themselves; only the data layer is affected.
- Implementing local persistence (DB) for banners in this phase.

## Decisions

### 1. Model Adaptation
- **Decision**: Update `DashboardBannerDto` to make `title` and `description` optional and add a `fromJson` factory.
- **Rationale**: The real API response for `banner_ads` only provides an ID, image URL, and target URL. Making other fields optional prevents parsing errors while maintaining compatibility with the existing UI components which might use them if available.

### 2. API Endpoint Definition
- **Decision**: Add `static const String bannerAds = '/api/v2.4/banner-ads/';` to `ApiEndpoints`.
- **Rationale**: Centralizing endpoints in `ApiEndpoints` is the established pattern in the `core` package for maintainability.

### 3. Data Retrieval Strategy
- **Decision**: Introduce `DashboardRepository` to coordinate between `DataSource` and `AppDatabase`.
- **Rationale**: This follows the "Offline First" principle. The repository emits cached data from the DB first, then fetches fresh data from the network and updates the cache.

### 4. Image Optimization
- **Decision**: Replace `Image.network` with `CachedNetworkImage`.
- **Rationale**: Banners are high-impact visual elements. Persistent caching ensures they load instantly on subsequent app opens even with poor connectivity.

### 4. Provider Update
- **Decision**: Modify `heroBannersProvider` in `packages/courses` to call `ref.watch(dataSourceProvider).getDashboardBanners()`.
- **Rationale**: Leveraging Riverpod's dependency injection via `dataSourceProvider` ensures that the app can switch between mock and real data sources globally (e.g., via a feature flag or build config).

## Risks / Trade-offs

- **[Risk]**: The UI expects a `title` for the carousel items, but the API doesn't provide one.
  - **Mitigation**: The `HeroBanner` mapping logic in `PaidActiveHomeScreen` will be updated to handle null titles gracefully, or provide a default if absolutely necessary.
- **[Risk]**: The banner-ads API is relatively large and fetching it just for banners might be inefficient.
  - **Mitigation**: This is the dedicated endpoint for banners, so it is the most efficient way to fetch this specific data.
