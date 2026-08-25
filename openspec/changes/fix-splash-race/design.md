## Context

Currently, the app initialization state is fractured. Navigation redirects depend on a combination of `authProvider` and `instituteSettingsProvider` (often accessed via a stateful `OnboardingScreen`). This decentralized state creates race conditions where the router might redirect to a login screen or home screen before the necessary initialization data (like institute settings) has finished loading, leading to screen flickering and improper app states.

## Goals / Non-Goals

**Goals:**
- Unify the application initialization state into a single, predictable source of truth.
- Prevent routing redirects before the application has fully finished bootstrapping.
- Simplify `OnboardingScreen` to a pure UI component.

**Non-Goals:**
- Rewriting the underlying network layer or authentication mechanisms.
- Modifying the internal logic of `instituteSettingsProvider` or `authProvider` beyond how their outputs are orchestrated for navigation.

## Decisions

- **Introduce `BootstrapState` Enum**: Create a simple state machine (`loading`, `unauthenticated`, `authenticated`) to clearly represent the app's overall startup phase.
- **Create `bootstrapProvider`**: This new Riverpod provider will watch both `instituteSettingsProvider` and `authProvider`. It acts as a single gateway that transitions from `loading` to either authenticated or unauthenticated state only when both underlying dependencies have emitted stable values.
- **Router Redirect Refactor**: Modify `AuthRoutes.redirect` and the `GoRouter` configuration to depend exclusively on `bootstrapProvider`. If the state is `loading`, all initial routes will land on `/onboarding`. Only when it transitions out of `loading` will regular authentication route guards apply.
- **Stateless Onboarding**: The `OnboardingScreen` will no longer watch providers or execute imperative `context.go()` navigation. It will simply render the splash image and rely on the router to handle redirection automatically based on the updated `bootstrapProvider` state.
- **Animated Route Transitions**: Auth routes will use a `CustomTransitionPage` with a slide animation. This animation will strictly depend on `Design.of(context).motion` to ensure standard app motion tokens are respected, and will check `MotionPreferences.shouldAnimate` for accessibility compliance.


## Risks / Trade-offs

- **Risk**: Increased perceived loading time if `instituteSettingsProvider` is slow.
  - *Mitigation*: The onboarding screen provides visual feedback (splash image). Ensure network calls have appropriate timeouts.
- **Trade-off**: The `bootstrapProvider` introduces an abstraction layer. Any new global initialization dependencies must be added here rather than directly in the router. This centralizes logic, which is cleaner, but requires developers to understand the bootstrap sequence.
