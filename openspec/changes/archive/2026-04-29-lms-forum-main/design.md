## Context
We are implementing a discussion forum for courses. The system must support social metadata and be agnostic to the specific participant type (Student or Instructor).

## Goals / Non-Goals

**Goals:**
- Course-scoped discussions.
- Social metadata support (Voting and Reply counts).
- Generic authorship (using name/avatar strings).
- Non-Material design primitives.

**Non-Goals:**
- Comment nesting (Phase 1 will focus on thread list).
- Thread creation composer.

## Decisions

### Decision 1: Generic Authorship
We will use `authorName` and `authorAvatar` (string URL) in our DTOs and Database tables. This avoids hard dependencies on `Student` or `User` records and allows for flexible scaling (e.g., displaying guest or bot names).

### Decision 2: Drift Schema for Social Stats
The `ForumThreads` table will include `upvotes` and `downvotes` as integer columns. Although not initially drive-able via UI, the data layer should support these for future ranking logic.

### Decision 3: Standalone Forum Package
We will build the Forum feature (Repository, Providers, and UI) inside a dedicated `packages/forum` module. Since the data (authorship and stats) is totally generic, this guarantees the Forum feature can be plugged into `courses`, `exams`, or the global app shell in the future without circular dependencies.

### Decision 4: Routing Architecture
Forum screens will be registered as top-level routes in the `AppRouter` shell branch to provide an immersive experience that overrides the standard dashboard view while maintaining back-navigation.
