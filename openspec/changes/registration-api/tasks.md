## 1. Network & API Layer

- [x] 1.1 Update `ApiEndpoints` with `register = '/api/v2.3/users/register/'` in `packages/core/lib/network/api_endpoints.dart`.
- [x] 1.2 Implement `register` method in `AuthApiService` mapping `username`, `email`, `password`, `phone`, and `country_code` to the request payload.

## 2. Authentication Flow Integration

- [x] 2.1 Implement `register` in `AuthRepository` that calls `_apiService.register` and then awaits `loginWithPassword`.
- [x] 2.2 Add `register` action to `AuthProvider` to expose the repository method to the UI.

## 3. UI Updates (Signup Screen)

- [x] 3.1 Modify `SignupScreen` to remove the Date of Birth field and controller.
- [x] 3.2 Add a new Username text field and controller to `SignupScreen`.
- [x] 3.3 Update Country Code field to use "IN" instead of "+91" as the default text.
- [x] 3.4 Wire the "Register" button to call `authProvider.notifier.register(...)` and handle loading states and error messages.
