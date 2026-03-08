## Why

The current implementation of the Profile and Account logic is tightly coupled within `packages/courses`. This creates a heavy dependency where other features (like `exams`) cannot have a profile without importing the entire `courses` codebase.

Moving to a **Peer Architecture** ensures:
1. **True Independence**: The `profile` package becomes a standalone module that only depends on the shared foundation (`data` and `core`).
2. **Modular Growth**: Any future package can be added to the platform without touching the `profile` or `courses` code.
3. **Clean Boundaries**: Feature-specific logic stays in feature packages, while identity and account logic move to the `profile` hub.

## What Changes

- **Move Models**: Relocate shared user-centric models like `RecentActivityDto` from `packages/courses` to `packages/data`.
- **Create Profile Package**: Establish `packages/profile` as a standalone module.
- **Move Screens & Widgets**: `ProfilePage`, `NotificationsPage`, and all profile-specific widgets (Header, Snapshot, Activity) move to the `profile` package.
- **Move Providers**: Relocate profile-related logic (like `currentUserStatsProvider`) to the `profile` package.
- **Blind Navigation**: The Side Drawer in `courses` will use URI strings (`/profile`) to avoid a direct dependency on the `profile` package.

## Capabilities

### New Capabilities
- `profile-foundation`: Defines the core user profile, theme, and account settings hub.
- `profile-content-hub`: Implements self-contained displays for learning progress and activity trackers.

### Modified Capabilities
- `lms-profile`: Requirements updated to reflect its new home as a standalone package.
- `lms-navigation-shell`: Navigation shell updated to link the "Profile" tab to the new package.

## Impact

- **packages/data**: Hosts shared user-centric models.
- **packages/courses**: Focuses purely on learning features.
- **packages/profile**: Self-contained hub for identity and account management.
- **Architecture**: Modular peer structure where features share a common data foundation.
