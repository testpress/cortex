## Context

The profile screen currently displays an "Edit Profile" option universally. However, the backend provides an `allowProfileEdit` setting in `InstituteSettings` that indicates whether a user is allowed to edit their profile.

## Goals / Non-Goals

**Goals:**
- Respect the backend `allowProfileEdit` setting.
- Hide the edit affordance in the profile header if `allowProfileEdit` is false.
- Hide the "Edit Profile" menu item in the Account & Preferences menu if `allowProfileEdit` is false.

**Non-Goals:**
- Change the structure or functionality of the Edit Profile screen itself.

## Decisions

- **Hide vs Disable**: We will completely hide the edit options when `allowProfileEdit` is false, rather than showing a disabled state. This aligns with standard UI practices for unavailable features.
- **Accessing Setting**: We will access the setting using `InstituteSettings.current?.allowProfileEdit ?? false` to ensure we have a safe fallback.

## Risks / Trade-offs

- [Risk] Null settings → If `InstituteSettings.current` is null, we default to `false`. This prevents unauthorized edits, but might hide the button if settings aren't fully loaded. Mitigation: Assume settings are loaded before the profile screen is accessible.
