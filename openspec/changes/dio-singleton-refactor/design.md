## Context

The current architecture in `packages/core` separates network concerns by creating distinct `Dio` instances for authentication (`AuthApiService`) and general data fetching (`HttpDataSource`). This fragmentation causes:
- Inconsistent application of interceptors.
- Separate connection pools (resource waste).
- Difficulty in implementing global side-effects like automatic logout on `401 Unauthorized` responses.

## Goals / Non-Goals

### Goals
- Establish a single `dioProvider` as the source of truth for all HTTP requests.
- Implement a "Smart" `AuthInterceptor` that handles both token injection (with path exclusions) and global session invalidation.
- Ensure zero circular dependencies between `Dio`, `AuthInterceptor`, and `AuthRepository`.

### Non-Goals
- Migrating to a different HTTP client (staying with `Dio`).
- Implementing complex retry/backoff logic (can be a separate future change).

## Decisions

### 1. Riverpod Managed Singleton
We will use a `Provider<Dio>` in `packages/core/lib/network/` to manage the lifecycle.
- **Rationale**: Riverpod handles the lazy-loading and caching (memoization) automatically, ensuring only one instance exists.
- **Alternative**: A static singleton class (e.g., `NetworkProvider.instance`). Rejected because it makes testing and overriding in mock environments harder than Riverpod.

### 2. Selective Auth Path Handling
The interceptor differentiates between unauthenticated "AuthFlow" endpoints and regular data endpoints:
- **`_authFlowPaths`**: Endpoints (Login, OTP, Password Reset) that skip automatic JWT token injection to avoid sending headers to public endpoints.
- **Recursion Prevention & Error Filtering**: In the error hook, the interceptor skips the global logout trigger for any 401 on an `_authFlowPath` (preventing errors on failed login credentials from wiping the session) and specifically for the **Logout endpoint** itself (to prevent infinite recursion if a token is already invalidated on the backend).
- **Rationale**: This strategy ensures that the network layer only triggers state-wide session invalidation for valid authenticated requests that have been rejected by the backend.

### 3. Circularity Break via Agnostic Callbacks
The `AuthInterceptor` will not depend on any specific Repository or Data Source. Instead, it will accept a `Future<String?> Function() getToken` callback.
- **Rationale**: This enforces a strict architectural boundary. The interceptor is a "Pure utility" that doesn't care about your Domain or Data layer logic.
- **Implementation**: The `dioProvider` will resolve this callback by reading from `authRepositoryProvider`. Since the resolution happens inside the callback (lazy execution), it safely breaks the circular dependency loop.

### 4. Global Session Invalidation & Unified Cleanup
The `AuthInterceptor` monitors for `401 Unauthorized` responses and triggers a global logout flow via the `onUnauthorized` callback.

- **Responsibility Shift**: Previously, the database purge was performed within the `Auth` notifier. This has been moved into the **`AuthRepository`** to follow clean architecture principles.
- **Unified Purge Logic**: The `AuthRepository.logout()` method now serves as the single source of truth for both:
    1.  Clearing the **JWT Auth Token** from secure storage.
    2.  Wiping all local tables via **`AppDatabase.purgeAllData()`**.
- **Rationale**: The provider layer should only manage UI/App state, while the repository orchestrates the actual data cleanup. This avoids leaking database dependencies into the state management layer.

### 5. Consolidated User-Agent Infrastructure
The `UserAgentHelper` logic will be moved into a private method within `UserAgentInterceptor`.
- **Rationale**: The helper was a single-method class only used by the interceptor. Merging them reduces file-count and boilerplate while keeping the logic encapsulated where it's used.

## Risks / Trade-offs

- **[Risk]** Forgetting to add a new public route to the exclusion list → **[Mitigation]** Standardizing on `ApiEndpoints` ensures all auth flows are consistently identified. Any unintentional 401 on an authenticated route correctly triggers the global logout security measure.
- **[Risk]** Overhead of `ref.read` inside every request → **[Mitigation]** Negligible. A Riverpod lookup takes < 0.01ms, whereas a typical disk read for a token or a network request takes 100ms+. The delay is physically invisible.
