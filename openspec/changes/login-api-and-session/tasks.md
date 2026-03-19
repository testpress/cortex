## 1. Storage & Persistence (packages/core)

- [x] 1.1 Create `packages/core/lib/data/db/tables/users_table.dart`.
- [x] 1.2 Update `AppDatabase` to include `UsersTable` and bump `schemaVersion`.
- [x] 1.3 Refactor `SessionStorage` to use `shared_preferences` and expose a singleton `instance`.
- [x] 1.4 Expose all persistence models and singletons in `packages/core/lib/data/data.dart`.

## 2. API & Network Infrastructure (packages/core)

- [x] 2.1 Refactor `AuthClient` to use `Dio` and implement Password and OTP login methods.
- [x] 2.2 Create a simple `AuthInterceptor` in `packages/core/lib/data/network/interceptors/auth_interceptor.dart`.
- [x] 2.3 Implement the networking logic for `generateOtp` and `verifyOtp` methods.
- [x] 2.4 Update `AppConfig` to support dynamic API base URLs and feature flags.

## 3. SDK Integration (packages/testpress & profile)

- [x] 3.1 Refactor the `Auth` provider in `packages/core/lib/data/auth/auth_provider.dart` to read from `SessionStorage` and `AppDatabase`.
- [x] 3.2 Update `app_router.dart` to use the real `SessionStorage` for session-based redirection.
- [x] 3.3 Refactor `LoginScreen` in `packages/profile` to replace mock methods with real `AuthClient` and `authProvider` updates.
- [x] 3.4 Ensure the initialization provider in `packages/testpress` correctly hydrates the auth state on app startup.

## Enhancements (Post v1)

- [x] E1 Split auth orchestration from `Auth` provider into a dedicated `AuthService`.
- [x] E2 Extract hydration and profile refresh TTL logic into `SessionManager`.
- [x] E3 Replace `Map<String, dynamic>` auth responses with typed response models in `AuthClient`.
- [x] E4 Move token persistence to `flutter_secure_storage` while retaining non-sensitive metadata in `shared_preferences`.
- [x] E5 Update login and OTP screens to use `authProvider` actions instead of direct `MockAuthClient` usage.

## Enhancements (Post v2)

- [x] V2.1 Rename `AuthClient` to `AuthApiService` and align provider names/usages.
- [x] V2.2 Introduce/standardize `AuthRepository` as the single auth workflow coordinator.
- [x] V2.3 Refactor `authProvider` to remain state-only and call repository APIs.
- [x] V2.4 Remove auth profile-refresh dependency on generic `DataSource` in auth path.
- [x] V2.5 Keep auth profile sync routed through repository contracts (no auth use of generic `DataSource`).
- [x] V2.6 Update app routing/auth gate checks to rely on provider-backed auth state as source of truth.
- [x] V2.7 Move user profile resource ownership (`UserRepository`) into `packages/profile`.
- [x] V2.8 Add profile repository method `getCurrentUser()` for cache-first user reads.
- [x] V2.9 Wire `AuthRepository` in `core` to trigger current-user sync through the profile contract after login/otp.
- [x] V2.10 Centralize auth error typing and backend-message extraction in `AuthException`.
- [x] V2.11 Add backend logout API invocation before local session clear.
- [x] V2.12 Clear secure storage on fresh install to avoid iOS keychain session carry-over.
