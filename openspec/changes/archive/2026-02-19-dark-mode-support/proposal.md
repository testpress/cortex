# Proposal: Dark Mode Support

## Why

To provide a premium user experience that automatically respects system-level brightness preferences. By integrating dark mode detection directly into the `DesignProvider`, we ensure that any new screen built with the Cortex SDK honors dark mode without requiring additional developer effort.

## What Changes

- **DesignColors**: Add a new `.dark()` factory with curated dark mode tokens.
- **DesignMode**: Introduce an enum (`system`, `light`, `dark`) for theme governance.
- **DesignProvider**: Update to support dual configurations (`config`, `darkConfig`) and automatically switch based on `DesignMode` and platform brightness.
- **Core Widgets**: Ensure all primitives continue to use tokens correctly (verified by structural testing).

## Capabilities

### New Capabilities
- `dark-mode-support`: Automatic and manual theme switching.

## Impact

- `packages/core/lib/design/design_config.dart`: New dark color tokens, `DesignMode` enum.
- `packages/core/lib/design/design_provider.dart`: Automatic brightness detection and manual override logic.
- `packages/core/lib/widgets/*`: All primitives will automatically inherit dark mode colors.
