## ADDED Requirements

### Requirement: Centralized LearnLens Session Management
The system SHALL manage LearnLens session tokens in `packages/core` supporting both organization-scoped generic chat and content-scoped lesson contexts.

#### Scenario: Acquiring an organization AI session token
- **WHEN** an organization-wide AI chat operation is initiated without a cached session
- **THEN** the session manager SHALL call the organization session endpoint (`/api/v3/ai-chat/sessions/create/`) and cache the session token.

#### Scenario: Acquiring a content lesson AI session token
- **WHEN** a video lesson AI tutoring operation is initiated
- **THEN** the session manager SHALL call the content session endpoint (`/contents/<id>/ai-sessions/create/`) with the lesson ID and cache the session token.

#### Scenario: In-flight request coalescing
- **WHEN** multiple concurrent calls request a session token simultaneously
- **THEN** the session manager SHALL coalesce them into a single in-flight network call to avoid duplicate session creations.

#### Scenario: User switch token invalidation
- **WHEN** the authenticated user logs out or switches accounts
- **THEN** all cached session tokens SHALL be purged immediately.

#### Scenario: In-flight invalidation on session clear
- **WHEN** a content or organization session is cleared while a session creation request is in-flight
- **THEN** the session manager SHALL abort writing the completed response to cache and throw a `session_cleared` exception.

### Requirement: HTTP 401 Session Renewal & Interceptor
The system SHALL provide an interceptor that attaches the `X-Session-Token` header to outgoing requests and attempts a single token renewal on HTTP 401 responses for managed sessions.

#### Scenario: Transparent 401 retry for managed sessions
- **WHEN** an outgoing AI request using a managed session token receives an HTTP 401 Unauthorized response
- **THEN** the interceptor SHALL force-refresh the session token and retry the original request once with the new token.

#### Scenario: Skip 401 retry on caller-supplied session token
- **WHEN** an outgoing AI request supplies its own explicit session token and receives an HTTP 401 Unauthorized response
- **THEN** the interceptor SHALL NOT attempt to refresh with an organization session and SHALL propagate the 401 error.

#### Scenario: Prevent interceptor retry deadlock
- **WHEN** a retried request encounters an error
- **THEN** the error SHALL propagate cleanly through the interceptor pipeline without deadlocking or blocking subsequent network requests.

### Requirement: Unified LearnLens DTO Models & Exception Normalization
The system SHALL define shared data transfer objects and normalized exception types in `packages/core`.

#### Scenario: Deserializing session and turn payloads
- **WHEN** the LearnLens API returns session, conversation, or chat turn JSON payloads
- **THEN** the system SHALL parse them into strongly typed immutable DTOs with safe fallbacks for missing policy fields.

#### Scenario: Normalizing rate limits and quota errors
- **WHEN** the API responds with HTTP 429 or quota exhaustion payloads
- **THEN** the system SHALL wrap the response into a `LearnLensException` preserving status code, error code, message, and retry timestamp.

### Requirement: Idempotent Request Tracking
The system SHALL generate standard RFC 4122 v4 UUIDs for turn requests to ensure idempotent message submission.

#### Scenario: Submitting chat turns with client request ID
- **WHEN** a user message or follow-up is submitted to LearnLens
- **THEN** the client SHALL generate and attach a unique RFC 4122 v4 UUID client request identifier.
