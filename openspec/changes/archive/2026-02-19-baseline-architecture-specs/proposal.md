# Proposal: Baseline Architecture Documentation

## Why

To establish a formal, testable baseline of the Cortex SDK's architecture and package contracts. This ensures that future Antigravity sessions and human contributors have a machine-readable "Source of Truth" for architectural governance, preventing regression toward platform-specific UI or static token usage.

## What Changes

- Create formal spec files in `openspec/specs/` covering:
  - **Neutral UI & Primitives**: Canvas-first, 48dp hits, no Material/Cupertino.
  - **Runtime Design System**: Context-based tokens, contrast compliance.
  - **Accessibility Contract**: Mandatory semantics, motion preferences.
  - **SDK Package Boundaries**: Import rules and public API aggregation.

## Capabilities

### New Capabilities
- `architectural-governance`: Capability to verify new code against established SDK patterns using OpenSpec.

## Impact

- `openspec/specs/core/`: [NEW] Detailed specs for core primitives and design system.
- `openspec/specs/packages/`: [NEW] Package contract definitions.
