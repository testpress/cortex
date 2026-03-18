# Auth Infrastructure

## Overview
The authentication infrastructure is the central networking core that handles all user lifecycle events (Login, OTP, Token Refresh). It ensures that all network requests are properly authenticated and that API errors are converted into understandable SDK exceptions.

## Requirements

### R1: Password Authentication
- **Endpoint**: `/api/v2.5/auth-token/` (POST)
- **Input**: `username`, `password`
- **Output**: `authToken`, `refreshToken`, and a full `UserDto` profile.
- **Side Effect**: Must trigger token storage in `SessionStorage` and user profile persistence in `AppDatabase`.

### R2: OTP Authentication
- **OTP Generation**: `/api/v2.5/generate-otp/` (POST)
  - **Input**: `phoneNumber`, `countryCode`, `email` (optional).
- **OTP Verification**: `/api/v2.5/verify-otp/` (POST)
  - **Input**: `otp`, `phoneNumber`, `email` (optional).
  - **Output**: Same as Password Auth.

### R3: Error Mapping
- **Exception**: `AuthException`
- **Types**: 
  - `invalidCredentials` (401)
  - `otpExpired` (400)
  - `networkError` (IOFailure)
  - `unauthorized` (403)

### R4: Profile Fetch
- **Endpoint**: `/api/v2.5/me/` (GET)
- **Output**: Full `UserDto` profile record for the authenticated user.

### R5: Global Interceptor
- **Logic**: For every outgoing request, if a token exists in `SessionStorage`, add the `Authorization: JWT <token>` header.
- **Scope**: Must apply to all `Dio` instances managed by the Core SDK.

## Enhancements (Post v1)

### R6: Typed Auth Responses
- `AuthClient.login` and `AuthClient.verifyOtp` MUST return typed models (not raw maps).
- Typed response MUST expose token primitives needed by session persistence.

### R7: Auth Workflow Ownership
- Login, OTP generation, OTP verification, and logout orchestration SHOULD be implemented in `AuthService`.
- `authProvider` SHOULD remain state-oriented and delegate workflow execution.
