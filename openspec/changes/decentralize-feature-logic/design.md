## Context
The current `packages/data` package is a "God Package" containing DTOs, Repositories, API Clients, and Riverpod Providers for all features. This creates tight coupling and bloat.

## Goals
- **Unified Foundation**: Move all shared/centric data (DTOs, Database, Auth) to `packages/core/data`.
- **Feature Ownership**: Move all domain-specific logic (Repositories, Providers) to their respective feature packages.
- **Package Elimination**: Remove `packages/data` entirely to simplify the monorepo structure.

## Decisions
- **Domain-Feature Split**: 
  - `packages/core/data/`: Shared infrastructure (Database, Auth) and common DTOs (e.g., `UserDto`).
  - `packages/<feature>/`: Feature-specific logic, providers, **DTOs/Models**, and **Mock data**.
- **Dependency Rule**: Features → Core. No feature should depend on another feature directly (circular dependency prevention).
- **Aggregator Consolidation**: Global shell widgets (like `DashboardDrawer`) move to the `testpress` shell package to prevent cross-feature coupling.

## Strategy
1. **Redistribution**: Systematically move providers and repositories from `data` to features.
2. **Foundation Migration**: Batch move remaining centric code from `data` to `core`.
3. **Consolidation**: Update all cross-package imports to point to `core/data` or local feature providers.
4. **Final Cleanup**: Delete the `packages/data` directory.
