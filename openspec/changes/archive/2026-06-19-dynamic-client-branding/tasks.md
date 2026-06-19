## 1. Client Automation Scripts

- [x] 1.1 Create `app/scripts/client_utils.dart` to handle JSON config fetching, logo downloading, and git checkout logic.
- [x] 1.2 Refactor `app/scripts/generate_client_app.dart` to use `client_utils.dart` for building the production APK.
- [x] 1.3 Create `app/scripts/run_client.dart` wrapper to invoke `client_utils.dart` followed by an interactive `flutter run` session.

## 2. Dynamic Branding Resilience

- [x] 2.1 Update `InstituteBanner` to conditionally render `Image.asset()` for local paths and `Image.network()` for remote URLs.
- [x] 2.2 Add `errorBuilder` fallback to `InstituteBanner` to handle missing local assets gracefully.
- [x] 2.3 Refactor `OnboardingScreen` to use dynamic logo resolution with graduation-cap fallback logic.

