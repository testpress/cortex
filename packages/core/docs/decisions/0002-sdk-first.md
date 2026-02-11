# ADR 0002: SDK-First Monorepo Architecture

# Context
The Cortex project is intended to be distributed as an SDK. If the application and logic are tightly coupled, extracting a reusable SDK later becomes difficult. We need a way to develop the SDK modules in isolation while having a reference application for testing.

# Decision
We adopted a monorepo structure where the reference `app/` is a consumer of the SDK packages. All business logic and UI components reside in `packages/`. The `app/` package imports ONLY `package:testpress` (the public SDK aggregator), enforcing a strict boundary between internal implementation and consumer-facing API.

# Consequences
- **Requirement**: SDK modules must expose clean, stable APIs via the `testpress` package.
- **Benefit**: Ensures the SDK is always consumable by external developers.
- **Benefit**: Enables independent scaling or distribution of modules (courses, exams).
- **Tradeoff**: Slightly more complex dependency management via `pubspec.yaml` path references.
