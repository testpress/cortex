## 1. Network Layer

- [x] 1.1 Add `dio` dependency in `packages/core/pubspec.yaml`.
- [x] 1.2 Add `packages/core/lib/network/api_endpoints.dart` with auth endpoint constants.
- [x] 1.3 Implement `auth_api_service.dart` using `dio` and `AppConfig.apiBaseUrl`.

## 2. Auth Domain Flow

- [x] 2.1 Implement `auth_repository.dart` with login, generateOtp, verifyOtp, initialize-session, and logout flows.
- [x] 2.2 Store and clear only access token via `flutter_secure_storage`.
- [x] 2.3 Implement explicit auth state lifecycle in `auth_provider.dart` (loading/authenticated/unauthenticated/failure).

## 3. App Wire-Ups

- [x] 3.1 Wire initialization provider to run auth initialization.
- [x] 3.2 Wire router redirects to auth provider state.
- [x] 3.3 Replace `MockAuthClient` calls in password/mobile/otp screens with auth provider actions.

## 4. Validation

- [x] 4.1 Add tests for login success/failure and logout token cleanup.
- [x] 4.2 Add tests for startup session restoration transitions.
- [x] 4.3 Run analyze/tests for touched packages and verify manual auth navigation flows.
