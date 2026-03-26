## ADDED Requirements

### Requirement: Single-point User-Agent generation
The system SHALL generate and provide the Testpress-compatible User-Agent string within the `UserAgentInterceptor` without relying on external helper classes.

#### Scenario: Cached User-Agent reuse
- **WHEN** the first network request is initiated
- **THEN** the system SHALL asynchronously generate the User-Agent string using device and package info
- **AND** for all subsequent requests, it SHALL reuse the cached string for performance
