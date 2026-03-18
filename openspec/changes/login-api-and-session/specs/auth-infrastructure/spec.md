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
