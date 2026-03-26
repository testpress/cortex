## Why

The current network layer is fragmented, with `AuthApiService` and `HttpDataSource` creating separate `Dio` instances. This leads to redundant connection pools, inconsistent interceptor application, and makes global session management (like auto-logout on 401) difficult to enforce.

## What Changes

- **Centralize Dio Lifecycle**: Move the initialization of `Dio` out of individual services and into a single, lazy-loaded Riverpod provider.
- **Smart AuthInterceptor**: Refactor the `AuthInterceptor` to be path-aware (skipping authentication endpoints to avoid circular dependencies) and error-aware (handling 401 Unauthorized globally).
- **Dependency Injection**: Update all network services to accept a shared `Dio` instance in their constructors rather than creating their own.
- **Streamline UserAgent**: Merge `UserAgentHelper` logic directly into `UserAgentInterceptor` to reduce boilerplate files.

## Capabilities

### New Capabilities
- `network-unified-provider`: A single, shared `Dio` provider for all repository and data source network requests.
- `global-session-guardian`: Global interceptor logic for token injection and session invalidation.
- `user-agent-streamlining`: Consolidated User-Agent generation logic within a single Interceptor.

### Modified Capabilities
- `auth-api-session`: Extend requirements to include global session invalidation on 401 response status code.

## Impact

- Affected Packages: `packages/core` (network, data/auth), `packages/courses` (if directly accessing network providers).
- APIs: No functional changes to external APIs, but internal service signatures will change.
- Dependencies: Heavy leverage of `flutter_riverpod` and `dio`.
