# Design: Baseline Architecture Documentation

## Context

The Cortex SDK is built on a "Neutral UI" philosophy, using Flutter as a rendering engine and enforcing strict package boundaries. These rules are currently documented in various markdown files and ADRs. This change formalizes these rules into OpenSpec `specs/` to enable machine-verifiable governance.

## Goals

- Create a persistent, machine-readable record of architectural requirements.
- Bridge the gap between human-readable docs and AI-verifiable constraints.
- Establish the baseline from which all future features and refactors will be measured.

## Decisions

### Decision 1: Mapping Docs to Specs
We will map existing documentation to four primary capability areas: `core/primitives`, `core/design-system`, `core/accessibility`, and `packages/contracts`. This structure mirrors the `packages/core` directory and the monorepo's dependency rules.

### Decision 2: Requirement Format
Specs will use the `Requirement -> Scenario (WHEN/THEN/AND)` format as prescribed by the OpenSpec workflow. This ensures that each architectural rule is expressed as a testable behavior.

### Decision 3: Source Alignment
The content for these specs is derived directly from:
- `packages/core/docs/architecture.md`
- `packages/core/docs/decisions/*.md`
- `packages/core/docs/ai_context.md`
- Existing package structure and dependency rules (git history).
