# Proposal: decentralize-feature-logic

## Goal
The goal of this refactor is to transition the Cortex project from a "God Data Package" architecture to a **Feature-Autonomous architecture**. Currently, the `packages/data` package acts as a central hub for all business logic (Repositories, APIs, and Riverpod State Providers), which creates tight coupling and bloat. This change will redistribute that logic into the respective feature packages (`courses`, `exams`, `profile`), leaving `packages/data` as a lightweight, shared "Schema" layer containing only Data Transfer Objects (DTOs) and shared infrastructure.

## What Changes
- **Logic Redistribution**: Feature-specific state providers and data fetching logic currently residing in `packages/data/lib/providers/` will be moved to the `lib/providers/` or `lib/data/` directories of their respective feature packages.
- **Data Package Thinning**: The `packages/data` package will be refactored to focus exclusively on shared models (DTOs) that need to be visible across multiple modules to prevent circular dependencies.
- **Import Realignment**: All internal imports within the feature packages and the `testpress` aggregator will be updated to point to the new decentralized locations of the state providers and logic.
- **Public API Cleanup**: Barrel files (`lib/*.dart`) in each feature package will be updated to export their newly acquired logic/providers.

## Capabilities

### New Capabilities
- `decentralized-logic`: Implementation of the architectural shift where each domain module (courses, exams, profile) owns its own data fetching and state management logic.

### Modified Capabilities
- None (This is an architectural refactor; functional requirements remain unchanged).

## Impact
- **`packages/data`**: Significant reduction in code volume. It will become a "Models-only" basement.
- **`packages/courses`**, **`packages/exams`**, **`packages/profile`**: These packages will become self-sufficient, containing both their UI and their business logic.
- **`packages/testpress`**: Updates to the `appRouter` and aggregator to import providers from feature packages instead of the central data package.
- **Build Performance**: Reduced recompilation surface area when making changes to specific feature logic.
