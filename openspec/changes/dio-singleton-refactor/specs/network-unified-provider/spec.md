## ADDED Requirements

### Requirement: Unified HTTP instance provider
The system SHALL provide a single, app-wide instance of the `Dio` HTTP client via a dedicated Riverpod provider.

#### Scenario: Singleton usage
- **WHEN** multiple services (e.g., Auth, Courses, Profile) request a Dio instance
- **THEN** the system SHALL return the exact same instance to each service

### Requirement: Service dependency injection
All network-dependent services MUST receive their HTTP client instance via constructor injection.

#### Scenario: Constructor Injection
- **WHEN** an AuthApiService is initialized
- **THEN** it SHALL require a Dio instance in its constructor
