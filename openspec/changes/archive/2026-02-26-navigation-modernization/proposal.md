# Proposal: Navigation Modernization

## Why
The current application uses a fixed Bottom Tab Bar and a partial-width modal drawer. While functional, this layout:
1.  **Stretches excessively** on tablets, leading to an awkward user experience with too much whitespace between navigation elements.
2.  **Feels less immersive** than modern apps like Instagram, which utilize full-page sliders for settings and account management.
3.  **Lacks adaptability** to different window sizes, which is critical for a high-quality multi-platform experience.

## What Changes
This change refactors the core navigation framework to be responsive and modernize the settings interaction.

### Adaptive Shell (`packages/core`)
- Refactor `AppShell` to determine the layout based on screen width (breakpoint: 600px).
- **Mobile (< 600px)**: Maintain the current `AppTabBar` at the bottom.
- **Tablet/Landscape (>= 600px)**: Introduce a `AppNavigationRail` on the left side.

### Instagram-Style Settings (`packages/core`)
- Refactor `AppDrawer` to support a `fullPage` configuration.
- Update transition animations to provide an immersive full-screen slide for the "Menu" interaction.
- **UX Continuity**: Synchronize slide direction with the trigger (RTL in landscape) and implement `PopScope` for native "back" gesture support.

### Integration (`packages/courses`, `packages/testpress`)
- Update `AppRouter` and `DashboardHeader` to support the new adaptive patterns.

## Impact
- **Packages**: `core` (major refactor), `courses` (integration), `testpress` (routing).
- **UX**: Significant improvement in tablet usability, modern mobile feel, and robust landscape stability (no SafeArea clipping).
