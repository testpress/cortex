## Why

The signup screen in the Cortex app currently lacks backend integration. Users cannot register for an account directly from the mobile app. By integrating the Registration API, we will enable seamless user onboarding that respects the institute settings, automatically logs users in upon successful registration, and populates the user session correctly.

## What Changes

- Integrate `POST /api/v2.3/register/` to register new users.
- Automatically trigger `loginWithPassword` (which uses `/api/v2.5/auth-token/` and then fetches `me/`) upon a `201 Created` registration success so the user is logged in immediately.
- Update the `SignupScreen` form fields:
  - Add a new "Username" field.
  - Remove the "Date of Birth" field as it is not required by the API.
  - Fix the "Country Code" field to capture and send the ISO Alpha-2 code (e.g., "IN") instead of the dial code ("+91").

## Capabilities

### New Capabilities
- `registration-api`: Covers the API integration for user registration, including payload mapping, submitting the POST request, handling HTTP 201 Created, and initiating the subsequent login flow.

### Modified Capabilities
- `login-ui`: Modifying the `SignupScreen` form fields (adding Username, removing Date of Birth, adjusting Country Code input logic).

## Impact

- `packages/profile/lib/screens/signup_screen.dart`
- `packages/core/lib/data/auth/auth_api_service.dart`
- `packages/core/lib/data/auth/auth_repository.dart`
- `packages/core/lib/data/auth/auth_provider.dart`
