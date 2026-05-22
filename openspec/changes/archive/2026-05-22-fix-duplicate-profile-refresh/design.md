## Context

Currently, the `userProvider` and `appInitialization` both watch the `authProvider`. When a user logs in successfully, both providers are triggered concurrently. Both have logic to fire a background fetch for the user's profile (`userRepository.refreshProfile()`), resulting in two simultaneous identical requests to `/api/v2.5/me/`.

## Goals / Non-Goals

**Goals:**
- Eliminate redundant API calls for user profile fetching.
- Ensure the profile is still fetched reliably on app startup and immediately post-login.
- Establish a single source of truth for orchestration (`appInitialization`).
- Protect against future duplicate fetches by implementing request deduplication at the repository layer.

**Non-Goals:**
- Modifying the actual API response or the internal structure of `UsersTableData`.
- Refactoring other un-related providers.

## Decisions

1. **Centralize Orchestration in `appInitialization`**
   - Rationale: The `appInitialization` provider is designed for background initialization tasks without binding directly to UI rendering cycles. It is the perfect place to orchestrate post-login fetches (like profile and progress) cleanly.

2. **Remove side-effect from `userProvider`**
   - Rationale: The `userProvider` should strictly be a reactive stream from the local database. Triggering network requests simply because the UI starts watching this provider is an anti-pattern that leads to un-orchestrated fetches. We will remove the `refreshProfile().ignore()` call here.

3. **Implement Request Deduplication in `UserRepository`**
   - Rationale: While centralizing orchestration fixes the immediate duplicate call issue, other future providers might call `refreshProfile()`. We will add an `inFlightFuture` to `UserRepository.refreshProfile()` to deduplicate parallel requests and ensure only one network request is inflight at any given time.

## Risks / Trade-offs

- **Risk: Profile fails to fetch if `appInitialization` fails or is not triggered.**
  - **Mitigation:** The `appInitialization` provider is a global (`keepAlive: true`) provider that accurately tracks the authentication state. It reliably executes.
- **Risk: Stale Data if `userProvider` doesn't fetch on its own.**
  - **Mitigation:** Data might be slightly delayed if `appInitialization` takes longer, but `appInitialization` is the first to know about auth state changes. Any other required fetches during an active session can call `UserRepository.refreshProfile()` explicitly instead of relying on provider initialization.
