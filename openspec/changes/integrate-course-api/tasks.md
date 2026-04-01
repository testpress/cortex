## 1. Networking and Authentication

- [x] 1.1 Implement centralized networking in `NetworkProvider` (in `network_provider.dart`) with base URL, interceptors, and shared error handling.
- [x] 1.2 Create `ApiException` to standardize HTTP error propagation.
- [x] 1.3 Implement `HttpDataSource.getCourses` with `page` and `page_size` query parameters.
- [x] 1.4 Update `MockDataSource.getCourses` signature to return `PaginatedResponseDto<CourseDto>`.
- [x] 1.5 Update `AuthProvider` to accept dev credentials ("222"/"222") and transition to authenticated state.
- [x] 1.6 Refactor `NetworkProvider` to use a flexible interceptor-injection model during instantiation.
- [x] 1.7 Abstract `AuthInterceptor` to use a `getToken` callback instead of a direct `AuthLocalDataSource` dependency.
- [x] 1.8 Remove redundant `AuthException.fromDio` and `dio` library dependency from `auth_exception.dart`.

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

## 4. Architectural Refinement (Session Decoupling)

- [x] 4.1 Extract pagination logic from Repository into dedicated `PaginationService` in `packages/core`.
- [x] 4.2 Decouple session state (`nextPage`, `hasMore`) from `CourseRepository` into `CourseList` notifier.
- [x] 4.3 Isolate backend-specific quirks (Testpress nested lists) in `PaginatedResponseDto`.
- [x] 4.4 Separate `isInitialSyncing` from `isMoreSyncing` and add background error reporting via `syncErrorProvider`.
- [x] 4.5 Delete redundant `RemoteCourseDto` and merge parsing logic into `CourseDto.fromJson`.
