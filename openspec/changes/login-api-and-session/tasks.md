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
