## 1. Networking and Authentication

- [x] 1.1 Create `ApiClient` in `packages/core/lib/data/network` with base URL, `Authorization` interceptor, and error handling.
- [x] 1.2 Create `ApiException` to standardize HTTP error propagation.
- [x] 1.3 Implement `HttpDataSource.getCourses` with `page` and `page_size` query parameters.
- [x] 1.4 Update `MockDataSource.getCourses` signature to return `PaginatedResponseDto<CourseDto>`.
- [x] 1.5 Update `AuthProvider` to accept dev credentials ("222"/"222") and transition to authenticated state.

## 2. Data Layer and Synchronization

- [x] 2.1 Update `CourseRepository.refreshCourses` to support paginated fetching using the API `next` field.
- [x] 2.2 Add `PaginatedResponseDto<T>` model in `packages/core` to handle paginated API responses.
- [x] 2.3 Export `PaginatedResponseDto` from the `core/data/data.dart` barrel file.
- [x] 2.4 Gate all course API calls behind auth check — no network calls before login.

## 3. UI

- [x] 3.1 Show `AppLoadingIndicator` only on first entry when local DB cache is empty.
- [x] 3.2 Display cached courses instantly on subsequent tab visits without any blocking loader.
- [x] 3.3 Show pagination loader at the bottom of the course list while fetching the next page.
- [x] 3.4 Trigger next-page fetch when user scrolls within 500px of the list bottom.
