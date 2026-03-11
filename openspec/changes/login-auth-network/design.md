## Context
The shell currently needs a complete auth entry flow with reliable session reuse and guarded request behavior. The design must keep domain boundaries intact: shell-level routing and screens in `testpress`, shared data/auth infrastructure in `core`, and one persisted session source consumed by all authenticated traffic.

## Goals / Non-Goals
**Goals:**
- Provide one login surface for both credential and OTP flows.
- Centralize auth API calls and session persistence in shared core data infra.
- Ensure downstream calls automatically include the active authorization token.
- Prevent duplicate requests during in-flight auth operations.

**Non-Goals:**
- Adding new auth methods beyond credential and OTP.
- Redesigning post-login feature screens.
- Reworking broader package architecture.

## Decisions
- Keep login route and UI in `testpress` since it controls shell entry and top-level navigation.
- Keep auth/session/network primitives in `core` for cross-feature reuse and stable API boundaries.
- Use a single session store as source of truth for route gating and request authorization.
- After token persistence, fetch `/api/v2.5/me/` and hydrate `authProvider` from server response so identity fields are API-backed.
- Disable login actions while requests are in flight and enforce request-level de-duplication in auth infrastructure.
- Normalize auth endpoint errors into explicit UI-friendly messages at the auth layer boundary.

## Risks / Trade-offs
[Risk] Session token exists but becomes invalid server-side. -> Mitigation: on auth-related downstream failures, clear session and redirect to login.
[Risk] OTP requests can still be spammed by repeated user interaction. -> Mitigation: in-flight dedupe plus short cooldown guard at auth request layer.
[Risk] Inconsistent error payload shapes across endpoints. -> Mitigation: defensive parsing with fallback generic messaging.

## Migration Plan
- Introduce shared auth/session/network infra in core first.
- Add login route and screen wiring in testpress.
- Connect startup/session initialization and route redirect logic.
- Validate compile and analysis; then test credential and OTP happy/error paths manually.

## Open Questions
- Should we persist extra OTP response fields for onboarding decisions now or defer?
- Should lockout messaging include server-provided retry duration when present?
