## Context

The application currently has a fixed set of navigation tabs (Home, Study, Explore, Profile) with an optional Info tab. We need to introduce a tenant-specific navigation layout for "brilliantpala" that includes a new "Exam" tab and removes the "Explore" and "Profile" tabs from the bottom navigation.

## Goals / Non-Goals

**Goals:**
- Dynamically adjust the bottom navigation items based on the active tenant's configuration.
- Introduce an "Exam" tab as a primary destination.
- Ensure the routing system (GoRouter) correctly maps tab selections to branches even when the tab set changes.

**Non-Goals:**
- Redesigning the entire navigation shell.
- Implementing the full functionality of the Exams landing page (it will be a placeholder/base screen).
- Changing the drawer or other secondary navigation elements.

## Decisions

### 1. Feature Flags in ClientConfig
We will add `showExamTab` and `useRestrictedNavigation` to the `ClientConfig` model.
- **Rationale**: This allows for fine-grained control over features per tenant without hardcoding tenant IDs in the UI layer.
- **Alternatives**: Checking the tenant ID directly in the UI, which is less scalable.

### 2. Dynamic Navigation Item Building
The `buildPrimaryNavigationItems` function in `app_router.dart` will be modified to filter and order items based on the `ClientConfig`.
- **Rationale**: Centralizes the logic for which tabs appear.
- **Alternatives**: Using different `AppShell` widgets for different tenants, which would lead to code duplication.

### 3. StatefulShellRoute Branch Management
We will add a new `StatefulShellBranch` for Exams. For restricted tenants, the branches for Explore and Profile will still exist in the `GoRouter` configuration (to avoid breaking deep links or state), but they will not be reachable via the bottom navigation bar.
- **Rationale**: Keeps the router configuration stable while controlling the UI entry points.

### 4. Exam Landing Page Location
A new `ExamsScreen` will be added to `packages/exams/lib/screens/exams_screen.dart`.
- **Rationale**: Follows the existing package-by-feature architecture.

## Risks / Trade-offs

- **Index Misalignment** → The mapping between `navigationShell.currentIndex` and our logical tab IDs must be carefully handled since `StatefulShellRoute.indexedStack` indices are fixed by the `branches` list order.
- **Deep Linking** → If a user deep links to `/profile` on a restricted tenant, they will still see the profile page. This is acceptable for now as the goal is UI restriction, not strict access control.
