## ADDED Requirements

### Requirement: Credential login request
The system SHALL support credential-based login by sending username/email and password to the authentication endpoint.

#### Scenario: Successful credential login
- **WHEN** the user submits valid username/email and password
- **THEN** the system SHALL call `POST /api/v2.5/auth-token/` exactly once per in-flight submit intent
- **AND** on HTTP 200 it SHALL persist the returned token as the active session.

#### Scenario: Invalid credential login
- **WHEN** the endpoint returns HTTP 400 or HTTP 401
- **THEN** the system SHALL show a user-friendly invalid-credentials message
- **AND** it SHALL keep the user on the login screen.

### Requirement: OTP login request flow
The system SHALL support OTP-based login by splitting generation and verification requests.

#### Scenario: Generate OTP
- **WHEN** the user requests OTP with phone/country or email
- **THEN** the system SHALL call `POST /api/v2.5/auth/generate-otp/`
- **AND** it SHALL prevent rapid duplicate generation requests while one request is in flight.

#### Scenario: Verify OTP
- **WHEN** the user submits OTP and identity fields
- **THEN** the system SHALL call `POST /api/v2.5/auth/otp-login/`
- **AND** on HTTP 200 it SHALL persist token and returned user metadata.

### Requirement: Session persistence and reuse
The system SHALL maintain one active session and reuse its token for authenticated requests.

#### Scenario: Applying authorization header
- **WHEN** an authenticated downstream API call is made
- **THEN** the network layer SHALL attach `Authorization: JWT <token>` using the persisted session token.

#### Scenario: Startup routing decision
- **WHEN** the app starts
- **THEN** routing SHALL direct to login when no active session token exists
- **AND** routing SHALL direct to authenticated shell routes when a valid session token exists.

### Requirement: Current user profile comes from API, not local mock defaults
The system SHALL fetch the authenticated user profile from `GET /api/v2.5/me/` using the active JWT token and use that response as the source of truth for user identity fields.

#### Scenario: Hydrating user after login
- **WHEN** credential or OTP login succeeds and a token is persisted
- **THEN** the system SHALL request `GET /api/v2.5/me/` with `Authorization: JWT <token>`
- **AND** it SHALL update the user state with the API response fields (name, email, phone, photo, etc.)
- **AND** it SHALL NOT populate user identity from local mock fixtures.

#### Scenario: Hydrating user on app relaunch
- **WHEN** a persisted session exists at startup
- **THEN** the system SHALL call `GET /api/v2.5/me/` before relying on user identity fields
- **AND** it SHALL use that response to refresh user state for downstream screens.

### Requirement: Session stores typed cached user profile
The system SHALL persist a typed cached user profile in session storage and hydrate it at app start.

#### Scenario: Persisting profile after `/me`
- **WHEN** `/me` is fetched successfully after login or startup refresh
- **THEN** the mapped `UserDto` SHALL be persisted in session storage with the active token metadata.

#### Scenario: Fast startup hydration from cache
- **WHEN** app startup detects an existing session with a cached user profile
- **THEN** the app SHALL hydrate `authProvider` from cached `UserDto` immediately
- **AND** it MAY refresh `/me` in background to update the profile.

### Requirement: Typed login response model
The auth infrastructure SHALL parse login/OTP success payloads into a typed response model instead of dynamic map handling.

#### Scenario: Parsing login payload
- **WHEN** `POST /api/v2.5/auth-token/` or `POST /api/v2.5/auth/otp-login/` succeeds
- **THEN** the response SHALL be parsed into a typed login response object
- **AND** token/session persistence SHALL use that typed model.

### Requirement: Single user hydration flow across startup and login
The system SHALL use one shared auth hydration flow for resolving current user profile from cache/network.

#### Scenario: Startup and login reuse same hydration policy
- **WHEN** startup resolves current user or login completes token persistence
- **THEN** both flows SHALL call the same auth hydration entry point
- **AND** cache-first behavior SHALL be consistent between these flows.

### Requirement: Duplicate request prevention
The auth flow SHALL avoid repeated requests for the same action while a prior request is in progress.

#### Scenario: Repeated tap during login submit
- **WHEN** the user taps login multiple times before the first response
- **THEN** only one request SHALL be sent
- **AND** additional taps SHALL not create extra network calls.

### Requirement: Auth error mapping
The system SHALL convert auth endpoint failures into predictable UI-level outcomes.

#### Scenario: Validation and throttling errors
- **WHEN** the server returns validation/throttle/lockout responses (including 422/429 and lockout-style errors)
- **THEN** the system SHALL map them to explicit, user-readable messages
- **AND** it SHALL re-enable interaction after the in-flight operation completes.

### Requirement: Login UI strings are localized
The login experience SHALL avoid hardcoded user-facing strings and use localization resources.

#### Scenario: Rendering login screen copy
- **WHEN** the login screen is rendered in any supported locale
- **THEN** labels, placeholders, helper text, CTA text, and status/error text shown by the login flow SHALL come from localization keys
- **AND** no user-facing login copy SHALL be hardcoded in the widget tree.
