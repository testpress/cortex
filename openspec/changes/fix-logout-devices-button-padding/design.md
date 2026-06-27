## Context

The "Log out other devices" button is rendered at the bottom of `LoginActivityScreen` in a `Container` with `EdgeInsets.all(design.spacing.md)`. The screen's `SafeArea` is configured with `bottom: false`, meaning the device's system bottom inset (home indicator, gesture bar) is intentionally excluded from the main safe area. As a result, the button container gets no bottom breathing room beyond `design.spacing.md`, making the button visually cramped on devices with a bottom gesture bar.

The fix is purely cosmetic — add bottom padding to the button container that accounts for the system bottom inset, matching the visual treatment of similar bottom-anchored action buttons in the app.

**Relevant file**: `packages/profile/lib/screens/login_activity_screen.dart` — lines 330–344

## Goals / Non-Goals

**Goals:**
- Add sufficient bottom padding to the "Log out other devices" button so it clears the device's home indicator / gesture bar
- Match the bottom spacing convention used by other primary action buttons in the app

**Non-Goals:**
- Changing the button color, style, or behavior
- Modifying any other part of the login activity screen
- Changing the `SafeArea` configuration

## Decisions

**Manually incorporate the system bottom inset into the button container's padding**

The `SafeArea(bottom: false)` pattern is intentional — it lets the content scroll edge-to-edge. For a bottom-anchored action button, the correct approach is to add the device's system bottom inset on top of the existing design token spacing, keeping all other sides unchanged. This ensures the button clears the home indicator / gesture bar on all device types without affecting the rest of the layout.

**Alternative considered**: Wrapping the button in a `SafeArea(top: false)` widget. Rejected for consistency — other screens in the app that use `SafeArea(bottom: false)` handle the bottom inset manually, and this change follows the same pattern.

## Risks / Trade-offs

- **Minimal risk** — this is a single-line padding change on a non-interactive container property
- On devices without a bottom inset (e.g., physical home button), `MediaQuery.padding.bottom` is `0`, so the button retains its original `design.spacing.md` bottom padding — no regression
- No logic, state, or API surface is touched
