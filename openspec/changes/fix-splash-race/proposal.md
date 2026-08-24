## Why

Currently, the app relies on listening to both the `authProvider` and the `instituteSettingsProvider` separately within the routing logic and `OnboardingScreen`. This decentralized state management creates a race condition during app initialization, where the router might redirect before the initial required settings are fully loaded, causing unexpected flashes of the onboarding screen or improper redirection to the login/home screen. We need a unified state that guarantees initialization is complete before making any routing decisions.

## What Changes

- Introduce a central `bootstrapProvider` to orchestrate app startup, awaiting `instituteSettingsProvider` and determining initial auth state.
- Refactor the `GoRouter` redirect logic to depend entirely on the single `bootstrapProvider` state (`loading`, `unauthenticated`, `authenticated`).
- Strip the `OnboardingScreen` of its stateful routing logic (removing `ConsumerStatefulWidget` and `_navigateToLogin` hooks), reducing it to a pure presentation `StatelessWidget`.
- **BREAKING**: Navigation redirects will now block until the bootstrap state explicitly transitions out of `loading`.

## Capabilities

### New Capabilities
- `app-bootstrap`: A centralized initialization capability that coordinates splash screen display and initial authentication state before allowing routing.

### Modified Capabilities
- `navigation`: Requirement changing to depend on the unified bootstrap state rather than individual authentication and settings providers.

## Impact

- `packages/testpress/lib/navigation/app_router.dart`: Router rebuild and redirect logic.
- `packages/testpress/lib/navigation/routes/auth_routes.dart`: Core redirect rules.
- `packages/testpress/lib/navigation/bootstrap_provider.dart` (New): Central bootstrap orchestrator.
- `packages/profile/lib/screens/onboarding_screen.dart`: Removed stateful navigation logic.
