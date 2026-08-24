## ADDED Requirements

### Requirement: Block navigation during bootstrap
The router MUST redirect all navigation requests to the onboarding (splash) screen while the bootstrap state is `loading`.

#### Scenario: User opens the app
- **WHEN** the bootstrap state is `loading`
- **THEN** any attempted route is redirected to `/onboarding`

#### Scenario: Bootstrap completes
- **WHEN** the bootstrap state transitions from `loading` to `unauthenticated`
- **THEN** the router redirects the user to `/login` if they are not requesting an auth route

#### Scenario: Bootstrap completes for authenticated user
- **WHEN** the bootstrap state transitions from `loading` to `authenticated`
- **THEN** the router redirects the user to `/home` if they are currently on `/onboarding` or an auth route
