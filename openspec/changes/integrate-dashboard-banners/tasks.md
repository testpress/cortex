## 1. Data Layer Preparation

- [x] 1.1 Add dashboard endpoint to `ApiEndpoints` in `packages/core/lib/network/api_endpoints.dart`.
- [x] 1.2 Update `DashboardBannerDto` in `packages/courses/lib/models/dashboard_banner_dto.dart` with `fromJson` factory and optional fields.
- [x] 1.3 Add `getDashboardBanners()` method to the `DataSource` interface in `packages/core/lib/data/sources/data_source.dart`.
- [x] 1.4 Implement `getDashboardBanners()` in `MockDataSource` to return existing mock data.

## 2. API Implementation

- [x] 2.1 Implement `getDashboardBanners()` in `HttpDataSource` in `packages/core/lib/data/sources/http_data_source.dart`.
- [x] 2.2 Map the `results` array from the `/api/v2.4/banner-ads/` response to `DashboardBannerDto` objects.

## 3. Provider Integration

- [x] 3.1 Update `heroBannersProvider` in `packages/courses/lib/providers/dashboard_providers.dart` to fetch from data source.
- [x] 3.2 Maintain mock data for `promotionBannersProvider` and other dashboard sections.

## 4. UI Stability

- [x] 4.1 Update banner mapping in `PaidActiveHomeScreen` to handle null metadata gracefully.
