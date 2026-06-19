## Why

To support multiple different clients using the same core LMS application, we need a robust dynamic branding system. This requires automated tooling to generate client-specific apps (downloading logos, updating package names) and resilient UI logic to seamlessly swap assets without crashing if configuration is missing.

## What Changes

- Add `client_utils.dart` to centralize automation scripting logic (fetching configs, downloading icons, renaming native targets).
- Refactor `generate_client_app.dart` to use the shared utilities for building production APKs.
- Introduce `run_client.dart` to allow developers to easily launch `flutter run` with specific client branding and hot-reload.
- Update `InstituteBanner` and `PaidActiveHomeScreen` to dynamically detect and load local/network logos without relying on brittle boolean `--dart-define` parsing.
- Implement robust `errorBuilder` fallbacks in `OnboardingScreen` to gracefully render default icons (like the graduation cap) if custom client logos are missing.

## Capabilities

### New Capabilities
- `client-automation`: Tooling to automatically fetch remote configs, inject local image assets, update iOS/Android package names, and build/run the app.
- `dynamic-branding`: UI resilience across the splash screen, dashboard banner, and login screen to handle custom logos with safe fallbacks.

### Modified Capabilities
- 

## Impact

- Development toolchain (`app/scripts/`)
- Native build config cleanup routines
- UI core components (`packages/core/lib/widgets/institute_banner.dart`, `packages/profile/lib/screens/onboarding_screen.dart`)
