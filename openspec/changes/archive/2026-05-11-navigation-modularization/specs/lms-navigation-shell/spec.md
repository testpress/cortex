# Capability: LMS Navigation Shell

## MODIFIED Requirements

### Requirement: Auth-state-based router redirect
The router SHALL use auth provider state to decide redirects for auth routes and protected routes. This logic SHALL be encapsulated within the `AuthRoutes` module for modularity.

#### Scenario: Unauthenticated protected navigation
- **WHEN** user is unauthenticated and requests a protected route
- **THEN** router SHALL redirect to onboarding/login route

#### Scenario: Authenticated auth-route navigation
- **WHEN** user is authenticated and requests login/onboarding routes
- **THEN** router SHALL redirect to home route

#### Scenario: Loading-state redirect guard
- **WHEN** auth provider is in loading state during startup restoration
- **THEN** router SHALL avoid premature redirect loops until state resolves
