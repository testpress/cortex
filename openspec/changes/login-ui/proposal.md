## Why
We are completely revamping the existing login flow to match the new visual design system (from Figma), delivering a cleaner, modern interface while retaining the app's dynamic configuration capabilities (such as pulling branding and allowed login methods from the institute settings).

## What Changes
- Revamp the `LoginScreen` in `packages/profile` to replace the old carousel layout with the clean, centered new design.
- Create/Revamp a standard password login screen based on the new aesthetic.
- Create/Revamp the OTP verification screen (updating from the Figma 6-digit design to a strict 4-digit input, per requirements).
- Ensure the branding (logo, institute name) and login options (Email, Mobile, Google) are dynamically sourced from `instituteSettingsProvider` but rendered in the new UI style.
- Add or update reusable UI components (e.g., text fields, gradient buttons, 4-digit OTP input) in `packages/core`.

## Capabilities

### New Capabilities
- `login-ui`: Implements the revamped visual interfaces for user authentication (Login Options, Password Login, Mobile OTP).

### Modified Capabilities

## Impact
- Overhauls the presentation layer for authentication in `packages/profile`.
- Adds/updates base UI components in the `packages/core` platform SDK to align with the new design system.
