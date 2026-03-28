## Context

The `profile` and `explore` packages are inconsistent with the core project standards (e.g., `courses`, `exams`). The goal of this design is to reset their package shell using the standard template without manually creating each individual boilerplate file.

## Goals / Non-Goals

**Goals:**
- **Full Shell Alignment**: Use `flutter create --template=package` to bootstrap fresh, compliant package structures.
- **Internal Preservation**: Migrate existing business logic and code (`lib/`, `pubspec.yaml`) into the new shells.
- **Structure Parity**: Standardize folder hierarchies in `explore`.

**Non-Goals:**
- Refactoring `material.dart` or migrating UI primitives.
- Changing app logic, screens, or providers.

## Decisions

- **Transplant Methodology**: To ensure 100% template compliance, we will isolate existing code in a `temp/` directory, generate new packages, and then "graft" the old code back in.
- **Selective Merge (pubspec)**: We will not simply replace `pubspec.yaml`, as that would lose the new template's boilerplate. Instead, we will merge existing dependencies and the project name into the template-generated file.
- **Layer Stubs**: For `explore`, we will proactively create `data/`, `models/`, and `repositories/` directories to match the domain package pattern.

## Risks / Trade-offs

- **Manual Merge Error**: The `pubspec.yaml` merge requires precision to avoid losing version constraints.
- **Dependency Resolving**: Re-shelling may require a `flutter pub get` and potential resolution of path dependencies.
