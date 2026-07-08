## Context

The Registration API (`POST /api/v2.3/users/register/`) is currently not integrated into the Cortex app. The `SignupScreen` exists but acts as a stub, rendering a "Register" button that redirects to `/home` without triggering any backend call. To provide a seamless onboarding experience, the app needs to call the API, auto-login upon success, and correctly format the country code as an ISO Alpha-2 string (e.g. "IN") rather than a dial code ("+91"). In addition, the Date of Birth field is to be removed and a dedicated "Username" field added to match the API requirements.

## Goals / Non-Goals

**Goals:**
- Connect the registration UI to the backend Registration API.
- Automatically log in the user upon a successful `201 Created` registration.
- Update the UI to match the exact fields required by the backend API: Add `username`, remove `DOB`, and format `country_code` correctly.

**Non-Goals:**
- Modifying the backend registration logic.
- Building a full Country Picker UI (we will default to "IN" or prompt for Alpha-2 string).

## Decisions

**1. API Payload Construction**
- We will add the `register` method to `AuthApiService` which maps `username`, `email`, `password`, `phone`, and `country_code`.

**2. Auto-login Flow**
- In `AuthRepository`, after a successful call to `_apiService.register`, we will directly await `loginWithPassword(username, password)`. This leverages the existing session management, token storage, and `me/` fetching.

**3. UI Adjustments**
- We will modify `SignupScreen` to include `_usernameController` and remove `_dobController`.
- For `_countryCodeController`, we will change the default value to `"IN"` to satisfy backend validation.

## Risks / Trade-offs

- [Risk] If auto-login fails (e.g., due to parallel login restriction or server error) after a successful registration, the user might be left in an unauthenticated state despite an account being created.
  → Mitigation: Standard error handling will catch it and allow the user to go back and log in manually.
