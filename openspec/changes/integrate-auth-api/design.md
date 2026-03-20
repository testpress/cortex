## Context

The app currently uses mock auth with in-memory session checks. To make authentication production-ready, we need a full API-backed flow and reliable app-level wire-up without introducing refresh-token complexity.

## Goals / Non-Goals

**Goals:**
- Implement auth API network calls via `dio`.
- Centralize auth endpoint strings in `api_endpoints.dart`.
- Persist access token with `flutter_secure_storage`.
- Wire auth state through provider, router, login screens, and bootstrap initialization.
- Keep implementation understandable with minimal layers.

**Non-Goals:**
- Refresh token support.
- Profile fetch/me endpoint integration.
- Login UI redesign.

## Decisions

1. Minimal auth module shape
- Keep auth flow centered around `auth_api_service.dart`, `auth_repository.dart`, and `auth_provider.dart`.
- Supporting value types may live in these files if needed, but no extra architectural layers.

2. Endpoint constants
- Add `core/lib/network/api_endpoints.dart` for all auth endpoint strings.
- Support login, OTP generation/verification, logout, and password reset.

3. Dio for network calls
- Use `dio` for auth requests with base URL from `AppConfig.apiBaseUrl`.
- Map `DioException` to `AuthException` with user-facing messages.

4. Token policy
- Store only `auth_token` in secure storage.
- Session restoration checks token presence; no refresh exchange in this change.

5. Wire-up flow
- `appInitializationProvider` triggers auth provider initialize.
- Router reads auth provider state for redirects.
- Password/mobile/otp/forgot-password screens call auth provider/repository actions.
- OTP Resend flow uses dynamic `countryCode` passed via route parameters.

## Component Responsibilities

| Component | Responsibility |
| :--- | :--- |
| **`AuthApiService`** | **Network Layer**: Pure Dio-based service for making HTTP requests (Login, OTP, Reset). Handles status code mapping to `AuthException`. |
| **`AuthRepository`** | **Domain Logic**: Orchestrator that combines API calls with local storage. It doesn't hold state, but defines the "business actions" for authentication. |
| **`AuthProvider`** | **State Management**: A Riverpod `AsyncNotifier` that holds the current `User?` object. It reacts to repository actions and triggers UI updates/router redirects. |
| **`AuthLocalDataSource`** | **Persistence**: Wraps `flutter_secure_storage` to safely manage the JWT `auth_token`. |
| **`UserAgentInterceptor`** | **Infrastructure**: Appends device-specific headers (e.g., `ios-app`) to every request for backend activity tracking. |
| **`AuthException`** | **Error Handling**: A custom domain exception that maps Dio/Backend errors into user-friendly strings. |

## Risks / Trade-offs

- [Token presence without validity check] -> Mitigation: accept as current scope; add token introspection/refresh in a separate change.
- [Backend contract mismatch] -> Mitigation: keep response parsing strict and fail with mapped errors.
- [Auth-loading redirect flicker] -> Mitigation: router treats loading state as neutral until resolved.

## Migration Plan

1. Finalize spec artifacts for auth flow + wire-ups.
2. Implement network layer (`api_endpoints.dart`, `auth_api_service.dart`, `dio`).
3. Implement repository/provider state transitions and secure storage.
4. Wire router/bootstrap/login screens.
5. Add tests and validate flows.

## Open Questions

- Final request/response contract field names for login and OTP endpoints.
- Whether logout endpoint requires auth header, body token, or both.
