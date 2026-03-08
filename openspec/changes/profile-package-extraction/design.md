## Context

Currently, `packages/courses` is the "owner" of the User Profile, Account Settings, and Notification preferences. This creates a deep coupling where other feature packages cannot have a profile without depending on `courses`.

## Goals / Non-Goals

**Goals:**
- Extract all common identity/account logic into `packages/profile`.
- Ensure `profile` has **zero** dependencies on `courses`.
- Establish `profile` and `courses` as independent "Peer" features.
- Single source of truth for `currentUser` and `studyMomentum` via the shared `data` package.

**Non-Goals:**
- Introducing complex repository interfaces (as requested by USER to avoid over-engineering).
- Re-designing the UI of the Profile page.
- Handling authentication flows which remain in `data`.

## Decisions

### 1. Feature Package Extraction
- **Decision**: Relocate all profile-related screens (`ProfilePage`, `NotificationsScreen`) and widgets into `packages/profile`.
- **Rationale**: Enables potential other packages (e.g., `exams`) to integrate profile features independently of the `courses` package.

### 2. Shared Domain Models
- **Decision**: Centralize shared DTOs like `UserDto`, `RecentActivityDto`, and `StudyMomentumDto` in `packages/data`.
- **Rationale**: Prevents data fragmentation between different parts of the UI while keeping feature packages lean.

### 3. Modular Logic Consumption
- **Decision**: Feature packages (Profile and Courses) will directly consume shared State/Domain providers from `packages/data` (e.g., `authProvider`, `studyMomentumProvider`).
- **Rationale**: Provides consistent application state (e.g., current user, streak days) across all feature tabs without over-engineered abstraction layers.

### 4. Feature-Specific Mock Data
- **Decision**: Maintain profile-only mock data (like `RecentActivityDto` for the activity feed) inside the `profile` package's data directory.
- **Rationale**: Keeps the `data` package focused on the master domain while allowing features to have their own unique data requirements for UI demonstration.

## Risks / Trade-offs

- **[Risk] State Collision** → Multiple packages might try to modify global state.
  - **Mitigation**: Use the established provider patterns in `data` for state mutations.
- **[Risk] Broken Navigation** → Navigating from Courses Drawer to Profile.
  - **Mitigation**: Use URI-based 'Blind Navigation' via route strings to avoid cross-package imports.
