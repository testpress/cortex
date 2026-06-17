## Context

For the "brilliant" tenant/client, we need to hide the Learning Performance section on the dashboard and the three learning/course/activity sections in the Profile tab.

## Goals / Non-Goals

**Goals:**
- Identify when the client is Brilliant Study Centre / Brilliant Pala (by checking `AppConfig.apiBaseUrl`).
- Conditionally hide `StudyMomentumGrid` in `PaidActiveHomeScreen`.
- Conditionally hide `ProfileLearningSnapshot`, `EnrolledCoursesSection`, and `RecentActivitySection` in `ProfilePage`.

**Non-Goals:**
- Removing the code/widgets completely (they should still be rendered for other tenants).
- Redesigning the layout/structure of the dashboard or profile screen.

## Decisions

### Decision 1: Identify Tenant via AppConfig.apiBaseUrl
We will check if `AppConfig.apiBaseUrl.contains('brilliant')` to identify the Brilliant Pala client.
- *Rationale*: Since the compilation of client config is done via JSON definition files (like `config/elearn_brilliantpala.json`) which populate `AppConfig` constants, `AppConfig.apiBaseUrl` contains `brilliantpalalms.testpress.in`, making this check robust and tenant-specific.
- *Alternatives considered*: Adding a new boolean feature flag in `AppConfig` / client configuration JSON. Rejected because the user asked to do this quickly for local testing. Checking the base URL is minimal and safe.

### Decision 2: Hide Widgets in Build Methods
- In `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart`:
  Check `final isBrilliantPala = dto.AppConfig.apiBaseUrl.contains('brilliant');`. Conditionally exclude `studyMomentum` and the corresponding vertical spacing.
- In `packages/profile/lib/screens/paid_active_profile_screen.dart`:
  Check `final isBrilliantPala = AppConfig.apiBaseUrl.contains('brilliant');`. Conditionally exclude `ProfileLearningSnapshot`, `EnrolledCoursesSection`, and `RecentActivitySection` (along with their following `SizedBox` vertical spacing widgets).

## Risks / Trade-offs

- [Risk] Missing spacing/padding consistency in the layouts when elements are hidden.
  -> *Mitigation*: We conditionally hide the vertical spacing `SizedBox` adjacent to the hidden components so that we do not have double padding or extra blank space.
