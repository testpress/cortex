## Why

The paid-active profile includes a "Your certificates" entry, but there is no certificates experience behind it. Learners need a clear place to view earned certificates, track locked items, and open a certificate preview.

## What Changes

- Add a certificates list screen aligned with the approved Figma reference.
- Add unlocked and locked certificate card states with the expected actions.
- Add a certificate preview screen for unlocked certificates.
- Add profile-to-certificates navigation and back flow within the same tab context.
- Add paid-active mock certificate data for UI behavior in this phase.

## Capabilities

### New Capabilities
- `lms-certificates`: Certificates list, preview, and profile-entry behavior for paid-active LMS users.

## Impact

- Profile settings flow gains a certificates destination and preview path.
- Certificates UI follows existing design tokens, semantic typography, localization, and accessibility rules.
- No backend integration is introduced; this phase uses local/mock data only.
