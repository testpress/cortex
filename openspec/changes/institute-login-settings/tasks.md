## 1. Network & Storage Layer

- [x] 1.1 Create `institute_settings_remote_data_source.dart` in `core` package to fetch `/api/v2.3/settings/` using Dio.
- [x] 1.2 Create `institute_settings_local_data_source.dart` in `core` package using `flutter_secure_storage` to save and load `InstituteSettings` JSON string.

## 2. Repository & State Management

- [x] 2.1 Create `settings_repository.dart` to manage fetching from `InstituteSettingsLocalDataSource` (cache) and `InstituteSettingsRemoteDataSource` (network).
- [x] 2.2 Create `settings_provider.dart` to expose `InstituteSettings` synchronously (after initial load) to the rest of the app.
- [x] 2.3 Update App Startup logic to load settings before launching the main app shell, refreshing in the background.

## 3. Login UI Integration

- [x] 3.1 Update `PasswordLoginScreen` to hide the "Forgot Password" button when `disableForgotPassword` is true.
- [x] 3.2 Update `LoginScreen` to calculate the number of active login methods based on `allowedLoginMethods` and `googleLoginEnabled`.
- [x] 3.3 Implement button visibility logic in `LoginScreen` to conditionally render Mobile, Student ID, and Google buttons based on active methods.
- [x] 3.4 Implement `allowSignup` logic in `LoginScreen` to hide the Signup text at the bottom.
- [x] 3.5 Implement auto-routing in `LoginScreen` to bypass the screen entirely if exactly 1 login method is active.
