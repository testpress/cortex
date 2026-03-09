## 1. Data Layer & Persistence

- [x] 1.1 Create `SettingsRepository` to manage persistent app-wide preferences.
- [x] 1.2 Implement Riverpod providers for `appearanceSettings`, `playbackSettings`, and `accessibilitySettings`.
- [x] 1.3 Update `DesignProvider` to consume the `appearanceSettings` state for theme switching.

## 2. App Settings Interface

- [x] 2.1 Implement `AppSettingsScreen` with sticky back header and hierarchical structure.
- [x] 2.2 Add **Appearance** preference controls (Light/Dark/System) with radio selection behavior.
- [x] 2.3 Add **Learning & Playback** preferences (Video Quality list and Auto-play toggle).
- [x] 2.4 Add **Accessibility** preferences (Text Size and High Contrast).

## 3. Routing & Integration

- [x] 3.1 Define new route in `app_router.dart` for `/profile/settings`.
- [x] 3.2 Update `PaidActiveAccountPreferencesSection` in the profile tab to link settings button to the new route.

## 4. Refinement & Verification

- [x] 4.1 Add new localization strings to `app_en.arb` for all setting labels.
- [x] 4.2 Conduct final visual verification for layout density and hierarchy consistency.
