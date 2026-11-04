# auth-api-session Specification

## Purpose
TBD - created by archiving change integrate-auth-api. Update Purpose after archive.

## Requirements

### Requirement: Auth API service endpoints
The system SHALL provide an auth API service that calls backend endpoints for password login, OTP generation, OTP verification, and logout.

#### Scenario: Password login call
- **WHEN** login is requested with username and password
- **THEN** the auth API service SHALL send a request to the configured login endpoint
- **AND** it SHALL return parsed session token data or throw a mapped auth error

#### Scenario: OTP verification call
- **WHEN** OTP verification is requested
- **THEN** the auth API service SHALL call the verify endpoint and return parsed session token data

### Requirement: Secure token persistence
The system SHALL persist only access token values via secure storage and SHALL NOT store auth tokens in Drift.

#### Scenario: Store token after successful auth
- **WHEN** password login or OTP verification succeeds
- **THEN** repository logic SHALL persist the access token in secure storage before setting authenticated state

#### Scenario: Clear token on logout
- **WHEN** logout is triggered
- **THEN** the stored access token SHALL be removed regardless of API logout response outcome

### Requirement: Startup session restoration
The system SHALL restore authentication state at app initialization using secure token presence.

#### Scenario: Existing token at startup
- **WHEN** an access token exists in secure storage
- **THEN** auth provider SHALL transition to authenticated state during initialization

#### Scenario: Missing token at startup
- **WHEN** no access token exists
- **THEN** auth provider SHALL transition to unauthenticated state during initialization

### Requirement: Explicit auth state model
The system SHALL expose explicit auth session states from auth provider to support deterministic UI and router behavior.

#### Scenario: Auth loading lifecycle
- **WHEN** initialize/login/verify actions are in progress
- **THEN** auth provider SHALL expose loading state before final state resolution

#### Scenario: Auth failure lifecycle
- **WHEN** auth API service returns an error
- **THEN** auth provider SHALL expose failure state with error message

### Requirement: OTP generation delivery channel
The auth API service SHALL preserve the existing initial default-SMS OTP request and SHALL support explicit delivery channels for OTP resend requests.

#### Scenario: Initial OTP generation
- **WHEN** a user submits a phone number to begin OTP login
- **THEN** the app SHALL send the existing OTP generation request without a `channel` field
- **AND** the backend SHALL use its default SMS delivery channel

#### Scenario: Resend OTP through SMS
- **WHEN** a user requests another OTP through SMS
- **THEN** the OTP generation request SHALL include `channel: sms`
- **AND** the phone number and country code identity SHALL remain unchanged

#### Scenario: Resend OTP through WhatsApp
- **WHEN** a user requests another OTP through WhatsApp
- **THEN** the OTP generation request SHALL include `channel: whatsapp`
- **AND** the phone number and country code identity SHALL remain unchanged
