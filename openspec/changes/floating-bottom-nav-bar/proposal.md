## Why

The current bottom navigation bar is fixed, which takes up screen space and feels less modern. A floating bottom navigation bar improves the UI aesthetics and provides a more modern, spacious feel to the application while retaining easy access to core navigation destinations.

## What Changes

- Redesign the bottom navigation bar to be a floating widget with rounded corners, margins, and shadow effects.
- Update the layout of the main shell to ensure content doesn't get obscured by the floating nav bar (e.g., using padding at the bottom or letting content scroll underneath).

## Capabilities

### New Capabilities
- `floating-nav-bar`: Design and functionality of the new floating bottom navigation bar component.

### Modified Capabilities
- `lms-navigation-shell`: The main navigation shell layout will need to adapt to the floating nav bar (padding, scrolling behavior).

## Impact

- Main navigation shell layout and UI.
- All screens that rely on the bottom navigation bar (need to ensure their scroll views account for the floating bar).
