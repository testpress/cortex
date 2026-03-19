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
- **Ownership**: This endpoint SHOULD be implemented in profile user services
  (for example `UserApiService`) rather than the auth transport service.

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

## Enhancements (Post v2)

### R8: Service Naming Standard
- Auth network transport MUST be represented by a `*Service` class name (for example, `AuthApiService`) instead of `*Client`.

### R9: Repository-Centric Auth Flow
- `authProvider` MUST invoke auth workflows through repository APIs.
- Login, OTP generation, OTP verification, hydration, and logout orchestration MUST be owned by `AuthRepository`.

### R10: Network Layer Scope
- `AuthApiService` MUST be network-only and MUST NOT persist DB/session state directly.
- API parsing and auth error translation MUST remain inside `AuthApiService`.

### R11: Package Boundary
- `AuthRepository`, `AuthApiService`, and session/token infrastructure MUST stay in `packages/core`.
- `UserRepository` and user profile resource services SHOULD be owned by `packages/profile`.

### R12: Typed Auth Error Contract
- Authentication failures MUST be represented by a typed auth exception model with error categories.
- Backend-provided validation/auth error details SHOULD be surfaced to users when available, with user-friendly fallback messages.

### R13: Logout API Call
- `AuthRepository.logout` MUST invoke backend logout when available before clearing local session state.
- If backend logout endpoint is unavailable for a deployment, local logout MUST still complete.
