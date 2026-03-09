# PROPOSAL: LMS App Settings

## Motivation
To provide users with the ability to customize their learning environment and global app behavior. This enhances the user experience by allowing personalization of visual appearance, accessibility, and playback preferences.

## Proposed Changes
- Create an **App Settings** screen linked from the Profile tab.
- Implement appearance customization (light/dark/system).
- Implement learning preferences (default video quality, auto-play next lesson).
- Implement accessibility options (text scaling, high contrast toggle).

## Capabilities
### NEW: app-settings
- **Feature**: View and modify global application preferences.
- **Components**: `AppSettingsScreen`.
- **Logic**: Reactive settings providers with persistence.

### MODIFIED: profile-view
- **Change**: Add navigation affordance to launch the App Settings screen.

## Impact
- `packages/profile`: New screen and navigation logic.
- `packages/data`: New persistence layer for settings.
- `app_router.dart`: New route for settings.
- `app_en.arb`: New localization strings for settings labels.
