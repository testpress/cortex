## Context
The `profile` package currently provides a read-only view of the user's learning profile. Users need a way to update their identity information (name, email, phone). The technical challenge is extending the existing data model and provider while maintaining isolation between packages.

## Goals / Non-Goals

**Goals:**
- Implement `EditProfileScreen` following the existing design system tokens.
- Add `phone` field to `UserDto` and ensure it's editable.
- Provide a clear save/success workflow with validation feedback.
- Update `AuthProvider` to support profile modifications in memory (mock implementation).

**Non-Goals:**
- Actual image upload to a server (will remain a UI placeholder for now).
- Password change or security-sensitive settings.
- Backend API integration (remains in mock data layer).

## Decisions

### 1. Extending `UserDto` and `AuthProvider`
- **Decision**: Add `String? phone` to `UserDto` and implement `updateProfile(UserDto newUser)` in the `Auth` provider.
- **Rationale**: Keeps common user data in the shared `data` package while allowing the `profile` package to perform updates.
- **Alternatives**: Creating a separate `ProfileSettingsDto` was considered but rejected as the fields are core to the user identity already present in `UserDto`.

### 2. Form State Management
- **Decision**: Use an `AsyncNotifier` (or a simple `Notifier`) in the `profile` package to manage the `EditProfileScreen` state.
- **Rationale**: `AsyncNotifier` provides built-in support for loading and error states during the "Save" operation, which is critical for UX.

### 3. UI Implementation
- **Decision**: Create a reusable `AppTextField` in `packages/core` if one doesn't exist, specifically tailored for the LMS design system (borderless, card-based, or consistent with `AppSearchBar`).
- **Rationale**: Promotes consistency across the app for future input-heavy screens.

## Risks / Trade-offs

- **[Risk] Mock Data Reset** → Changes made during a session will be lost if the app hot-restarts.
  - **Mitigation**: This is acceptable for the current development phase; persistent local storage (e.g., Drift) implementation for user data is a separate future task.
- **[Trade-off] Phone Field in DTO** → Adding `phone` to the core `UserDto` makes it available everywhere, even if only used in the profile.
  - **Mitigation**: Given the small size of the app, this overhead is negligible compared to the benefit of unified data management.
