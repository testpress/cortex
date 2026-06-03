## Why

The application currently allows users to select their preferred text scale size (Small, Medium, or Large) in the settings screen, but this setting is only stored in the local database and is not applied to the actual UI. Implementing this ensures the app is fully accessible and meets the WCAG 1.4.4 (Resize Text) requirement.

## What Changes

- Create `appTextScaleMultiplierProvider` in `packages/profile` to expose a scaling multiplier factor based on the selected `TextScaleSize`.
- Update `app/lib/main.dart` to watch `appTextScaleMultiplierProvider` and override the `textScaler` globally in `MaterialApp.router`'s builder.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `app-settings`: Implement the text scaling scenario so selecting a text size dynamically updates the global text scale factor of the application.

## Impact

- `packages/profile/lib/providers/settings_providers.dart`: Exposes `appTextScaleMultiplierProvider`.
- `app/lib/main.dart`: Consumes the provider and wraps the app widget tree with a custom `MediaQuery` featuring the combined text scaler.
