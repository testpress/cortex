## Context

Currently, `packages/courses` is the "owner" of the User Profile, Account Settings, and Notification preferences. This creating a deep coupling where other potential packages (like `exams`) cannot have a profile without depending on `courses`.

## Goals / Non-Goals

**Goals:**
- Extract all common identity/account logic into `packages/profile`.
- Ensure `profile` has **zero** dependencies on `courses` or `exams`.
- Allow `courses` to "plug in" its custom sections (Active Courses, Recent Activity) into the Profile page.
- Single source of truth for `currentUserProvider` and `designModeProvider`.

**Non-Goals:**
- Moving core DTOs from `packages/data`.
- Re-designing the UI of the Profile page (this is a structural refactor only).
- Handling authentication flow (login/signup logic) which lives in `data`.

## Decisions

### 2. Repository-Based Data Access
- **Decision**: Define an abstract `IProfileRepository` in `packages/data`. This repository will be responsible for fetching User DTOs, Course lists, and Activity logs for the profile.
- **Rationale**: By using an interface, the `profile` package stays decoupled from the actual data source (Mock or API).

### 3. Logic Extraction (Domain Layer)
- **Decision**: Move all stats calculation logic (e.g., determining "Strongest Subject") out of the `ProfileSnapshotCard` widget and into a `ProfileStatsNotifier`.
- **Rationale**: Keeps the UI layer focused on rendering while the logic layer stays testable and optimized.

### 4. Mock Data Refactoring
- **Decision**: Move the existing mock data from `courses` to a `MockProfileRepository` inside the `profile` package.
- **Rationale**: Ensures the `profile` package can run standalone using its own test data.
tural pattern of "Repository -> Provider -> Widget."

## Risks / Trade-offs

- **[Risk] Migration Circularity** → If we don't move the providers first, `courses` will break before `profile` is ready. 
  - **Mitigation**: Move providers to `profile` first, then update `courses` to import them, then finally move the UI components.
- **[Risk] Registration Timing** → Courses must register their profile sections before the user navigates there.
  - **Mitigation**: Perform registration in the app's initialization phase or via a "Module" init system.
- **[Risk] Broken Navigation** → Sidebar links currently point to hardcoded `/profile`.
  - **Mitigation**: Ensure the navigation shell points to the new package's screens.
