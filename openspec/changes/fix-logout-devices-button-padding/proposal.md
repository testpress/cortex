## Why

The "Log out other devices" button in the login activity dashboard lacks sufficient bottom padding, making it feel cramped and visually inconsistent with the login button. This fix improves visual polish and readability without any behavioral changes.

## What Changes

- Add bottom padding to the "Log out other devices" button to match the spacing style of the login button
- No color, typography, or behavioral changes — purely a padding adjustment

## Capabilities

### New Capabilities

_(none — this is a cosmetic fix, no new capabilities introduced)_

### Modified Capabilities

- `login-activity`: The "Log out other devices" button spacing is being adjusted (implementation-level only, no requirement-level spec change needed)

## Impact

- Affects the login activity screen in the dashboard
- Change is limited to widget-level padding (likely a `Padding` widget or `EdgeInsets` on the button)
- No API, state, or logic changes
- No breaking changes
