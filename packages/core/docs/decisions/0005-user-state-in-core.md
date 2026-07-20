# 0005: User State in Core Package

## Context
The `profile` package originally owned the `UserRepository` and `UserProvider`. However, domain packages like `courses` and `exams` often need access to the current user's profile (e.g., for analytics tracking or rendering watermarks on PDF lessons). Because domain packages are strictly forbidden from importing each other (to prevent circular dependencies), they were unable to access the current user's state.

## Decision
As proposed by the maintainers, we moved the `UserRepository` and `UserProvider` from the `profile` domain package into the `core` package (`packages/core/lib/data/repositories` and `packages/core/lib/data/providers`).

The `core` package now acts as the single source of truth for the authenticated user's profile data, exposing the `userProvider` to all domain packages. 
The Auth layer remains entirely decoupled from this domain profile logic; it handles identity tokens and delegates profile hydration and database syncing to the `UserRepository`.

## Consequences
- **Positive**: Domain packages (like `courses`) can now safely import `package:core/core.dart` to access the current user profile without violating package boundaries.
- **Positive**: Resolves circular dependency risks between the `profile` package and other domains.
- **Tradeoff**: The `core` package takes on slightly more domain knowledge (the definition of a `User`), but since `User` is a fundamental entity accessed by almost all features, it is a justified promotion to the core layer.
