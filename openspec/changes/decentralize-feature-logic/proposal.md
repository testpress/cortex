# Proposal: decentralize-feature-logic

## Goal
The goal of this refactor is to transition the Cortex project from a "God Data Package" architecture to a **Unified Core Architecture**. We are eliminating the central `packages/data` package by:
1. Redistributing feature-specific business logic (Repositories, Providers) into their respective domain packages (`courses`, `exams`, `profile`).
2. Consolidating shared infrastructure (Database, Auth, and common DTOs like UserDto) into `packages/core/data`.
3. Ensuring feature packages (`courses`, `exams`, `profile`) own their own domain-specific DTOs/Models and Mock data.

This simplifies the dependency graph by making `core` the single foundation for every feature in the app.

## Motivation
This architectural shift solves several growing pains in the project:
- **Simplified Dependency Graph**: Feature packages now only depend on `core`. This removes the complexity of managing a separate `data` package and prevents circular dependencies.
- **Build Performance**: Decentralizing logic ensures that a change in `courses` only triggers a `build_runner` cycle for that package, rather than a project-wide cycle in a monolithic `data` package.
- **Domain Ownership**: Each feature becomes a self-sufficient domain. This allows for isolated development, testing, and even deletion of features without impacting the rest of the app.
- **Maintenance**: Developers can find logic where they expect it (with the UI it serves). Shared foundation code is centralized in `core`, where the Platform SDK already lives.

## What Changes
- **Feature Autonomy**: All feature-specific state providers and repositories move to their respective feature packages.
- **Foundation Consolidation**: Centric components (Shared Models/DTOs like `UserDto`, Database, and Auth infrastructure) move from `packages/data` into `packages/core/data/`.
- **Feature DTO Ownership**: Feature-specific DTOs and mocked entities move from the central layer into their respective domain packages (e.g., `AssignmentDto` to `courses`).
- **Package Elimination**: The `packages/data` package is completely removed.
- **Dependency Realignment**: All feature packages and the testpress shell switch their dependencies from `data` to `core`.

## Impact
- **`packages/core`**: Becomes the "Universal Foundation," housing the Design System and the Shared Data Layer.
- **`packages/data`**: **Removed**.
- **`packages/courses`**, **`packages/exams`**, **`packages/profile`**: Become self-sufficient domains depending only on `core`.
- **Project Structure**: Reduced package overhead and a clearer separation between "Feature Logic" and "Platform Foundation."
