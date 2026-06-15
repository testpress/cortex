## 1. Exception Type

- [x] 1.1 Add a `ParallelLoginException` class (extending `AuthException`) in the auth exceptions directory.

## 2. Auth Flow Orchestration

- [x] 2.1 In `AuthRepository.loginWithPassword()`: after `saveToken()`, call `_source.getProfile()`. If it throws `ApiException` with `error_code == "parallel_login_restriction"`, clear the token and throw `ParallelLoginException`.
- [x] 2.2 In `AuthRepository.verifyOtp()`: apply the same verification step after `saveToken()`.
- [x] 2.3 Add a `markAuthenticated()` method to `AuthRepository` that is a no-op on the backend — it only allows the `AuthNotifier` to set `state = AsyncData(true)` after recovery from `LoginActivityScreen`.
- [x] 2.4 Expose `markAuthenticated()` in the `Auth` notifier (`auth_provider.dart`) so it can be called from the UI layer after a successful `logoutOtherDevices()`.

## 3. UI and Navigation Wiring

- [x] 3.1 In `password_login_screen.dart`: catch `ParallelLoginException` in the `_handlePasswordLogin` method and navigate to `LoginActivityScreen` with a message argument.
- [x] 3.2 In `otp_screen.dart`: catch `ParallelLoginException` in the OTP submit handler and navigate to `LoginActivityScreen` with a message argument.
- [x] 3.3 Update `LoginActivityScreen` to accept and display an optional `message` argument (for the "Parallel login is restricted..." banner).
- [x] 3.4 In `LoginActivityScreen._logoutDevices()`: on successful `logoutOtherDevices()`, call `ref.read(authProvider.notifier).markAuthenticated()` then `context.go('/home')`.
