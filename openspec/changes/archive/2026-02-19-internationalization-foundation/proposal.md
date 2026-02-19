# Proposal: Internationalization Foundation

## Why

To enable the Cortex SDK to serve global markets by providing robust, machine-verifiable infrastructure for translations (Multi-language) and bi-directional layouts (RTL). This ensures that all future components are built with a "Global First" mindset.

## What Changes

- **Localization Infrastructure**: Integrate `flutter_localizations` and `intl` into `packages/core`.
- **Locale Governance**: Create a `LocalizationProvider` to manage the active locale and provide generated localization helpers.
- **RTL Refactor**: Audit and migrate all `packages/core` widgets from physical units (Left/Right) to logical units (Start/End).
- **Package-Bound Translation**: Establish a standard for merging ARB files from multiple monorepo packages.

## Capabilities

### New Capabilities
- `localization`: Automated string translation and locale management.
- `rtl-support`: Layout adaptation for bi-directional languages.

## Impact

- `packages/core/pubspec.yaml`: New dependencies (`intl`, `flutter_localizations`).
- `packages/core/lib/widgets/*`: Migration to `Directional` geometry.
- `packages/core/lib/l10n/`: Base translation files.
- `app/lib/main.dart`: Initialization of `LocalizationProvider`.
