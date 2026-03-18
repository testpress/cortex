## Why

The current authentication flow relies on UI-only mocks and transient session stubs. To enable real-world usage, we must implement a production-ready authentication infrastructure that handles secure network requests, persists session tokens across app restarts, and manages environment-specific configurations.

## What Changes

- **Implement `AuthClient`**: A Dio-powered network client in `packages/core` to handle real Password and OTP authentication endpoints.
- **Implement `SessionStorage`**: A persistent storage service using `shared_preferences` to securely store and retrieve lifecycle-critical data (Auth Tokens, Session ID).
- **Implement `UsersTable`**: Add a dedicated persistence layer in `AppDatabase` for user profiles, ensuring user identity is managed as a first-class database entity.
- **Enhanced Configuration**: Update `AppConfig` to support dynamic API base URLs and environment-based feature flags (e.g., `useMockData`).
- **Middleware Integration**: Update the app router's redirection logic and the initialization provider to use the new persistent session state.

## Capabilities

### New Capabilities
- `auth-infrastructure`: The core networking layer for authentication, including Dio setup, interceptors, and error mapping.
- `session-management`: The persistence layer responsible for lifecycle management of the user's session and identity.
 
### Modified Capabilities
- `login-ui`: Updating the requirements of the login screen to transition from mock-driven behavior to real API-driven feedback and error states.

## Impact

- **`packages/core`**: Introduction of `dio` and `shared_preferences` dependencies.
- **`packages/testpress`**: Updates to the `initialization_provider` to hydrate session state on startup.
- **`packages/profile`**: Refactoring `LoginScreen` to utilize the real `AuthClient`.

## Enhancements (Post v1)

The original plan and delivery remain unchanged above. The following items are
iterative enhancements to improve long-term maintainability and security.

- **Auth flow ownership split**: Keep `Auth` provider state-focused by moving
  login/otp/logout orchestration into a dedicated `AuthService`, and session
  hydration/TTL logic into `SessionManager`.
- **Typed auth responses**: Replace `Map<String, dynamic>` auth responses with
  a typed token response model to improve compile-time safety and refactorability.
- **Secure token persistence**: Move auth token and refresh token persistence
  from `shared_preferences` to `flutter_secure_storage` while keeping
  non-sensitive metadata in preferences.
- **Unified auth entrypoint for UI**: Update login/OTP screens to call
  `authProvider` actions instead of directly instantiating `MockAuthClient`.
