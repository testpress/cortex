# Cortex Packages

This directory contains the modular Flutter SDK packages that form the Cortex platform.

## Package Categories

### Framework Foundation
- **core**: The architectural foundation. Contains neutral UI primitives, design system runtime (DesignProvider), and accessibility infrastructure.

### Domain Modules
- **courses**: LMS module providing course listing, progress, and content rendering logic.
- **exams**: Exam engine module for assessments and quiz rendering (placeholder).

### SDK Aggregator
- **testpress**: The public entry point. Re-exports stable APIs from internal modules for external consumption.

## Dependency Rules

- Internal modules (`courses`, `exams`) depend on `core`.
- The public aggregator (`testpress`) depends on all internal modules.
- Consumer applications (like `app/`) should import ONLY `package:testpress`.

This structure ensures clean boundaries and a stable public API while allowing internal modules to evolve independently.
