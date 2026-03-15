## Why

Currently, the application shell uses a fixed width breakpoint (`tabletBreakpoint: 600`) to decide between a bottom navigation bar and a side navigation rail. This leads to a side navigation rail being displayed on tablets in portrait mode, which contradicts the user's preference for a bottom navigation bar in vertical mode on all handheld devices (tablets and mobiles). Conversely, in horizontal mode, moving the navigation to the side rail optimizes vertical space, which is especially important for smaller screens.

## What Changes

- **Orientation-Responsive Navigation**: Update the `AppShell` logic to prioritize device orientation. 
  - Vertical (Portrait) mode: Always use the bottom navigation bar (`AppTabBar`).
  - Horizontal (Landscape) mode: Always use the side navigation rail (`AppNavigationRail`).
- **Layout Robustness**: Ensure the layout remains clean and "uncongested" across all screen sizes by adjusting padding/margins or visibility of shell elements if necessary.
- **Spec Update**: Update the `lms-navigation-shell` spec to reflect these new requirements.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `lms-navigation-shell`: Update the navigation adaptation logic to be orientation-aware rather than purely width-based for mobile and tablet contexts.

## Impact

- `packages/core/lib/shell/app_shell.dart`: Main implementation change for layout logic.
- `openspec/specs/lms-navigation-shell/spec.md`: Update requirements to match new behavior.
