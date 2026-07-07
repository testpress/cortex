## Context

The application requires a comprehensive revamp of the authentication UI. The existing `LoginScreen` in `packages/profile` uses a carousel format and dynamic options driven by `instituteSettingsProvider`. New Figma designs introduce a cleaner, modern aesthetic (Sign Up style, OTP Verification) with specific fonts (Inter/Plus Jakarta Sans), borders, and gradients (`#1d61e7` to `#375dfb`). We are adapting this aesthetic system to completely revamp the login flow (Login Options, Password Login, and OTP Verification), ensuring that the dynamic branding logic is preserved within the new visual framework. An explicit constraint is that the OTP input must be exactly 4 digits, deviating from the 6-digit Figma design.

## Goals / Non-Goals

**Goals:**
- Completely revamp `LoginScreen` and related authentication screens in `packages/profile`.
- Retain dynamic fetching of logos and login methods from `instituteSettingsProvider`.
- Build an OTP verification screen with exactly 4 digits.
- Create or update existing UI components in `packages/core` to conform to the Figma design attributes (shadows, typographies, primary button gradients).

**Non-Goals:**
- Altering the backend API interactions or auth token logic.
- Building the actual Sign Up screen (we are applying the Sign Up's aesthetic to the Login screens).

## Decisions

- **Location of Components**: Reusable widgets (Text fields, 4-digit OTP input array, Gradients Buttons) will be placed in `packages/core` to ensure application-wide consistency.
- **Form Handling**: Standard Flutter `TextEditingController` and `Form` widgets will be used for state management.
- **Dynamic Branding**: The new layouts will feature a top placeholder for the logo. We will use the same logic from the existing `_buildBrandingSection()` in `LoginScreen` to fetch `settings?.name` or logos, adapting it into a static header rather than a carousel.
- **OTP Implementation**: Instead of a full third-party pin code package, we will build a clean 4-digit input row or utilize a lightweight package if it strictly aligns with the Figma's simple bordered boxes.

## Risks / Trade-offs

- **Risk**: Mismatch between existing dynamic configurations (e.g. 3 login methods) and the clean Figma layout (which assumes fewer elements).
  - **Mitigation**: Ensure the options container is scrollable and buttons are stacked cleanly as per the original `_buildOptions` logic, but with the new button styles.
