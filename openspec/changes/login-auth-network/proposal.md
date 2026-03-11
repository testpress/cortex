# Proposal: login-auth-network

## Why
The app needs a production-ready login flow that supports both credential and OTP authentication while preventing duplicate auth calls. This change defines one shared session/network behavior so authenticated routing and downstream API access remain consistent.

## What Changes
- Add a login experience in the shell with username/password and OTP entry paths.
- Add shared auth networking and session persistence under core data infrastructure.
- Ensure one active session token is reused for downstream API requests through standard authorization headers.
- Add deterministic error mapping for auth failures, validation issues, throttling, and lockout responses.
- Gate app routing with session availability (`/login` vs authenticated shell routes).

## Capabilities
### New Capabilities
- `login-auth-network`: Defines login UX behavior, auth API interaction rules, session persistence, and authenticated request header behavior.

### Modified Capabilities
- _None._

## Impact
- `packages/testpress`: login route/screen and auth-aware routing.
- `packages/core`: shared auth/session/network primitives.
- App startup: session initialization before routing decisions.
- Backend integration: `/api/v2.5/auth-token/`, `/api/v2.5/auth/generate-otp/`, `/api/v2.5/auth/otp-login/`.
