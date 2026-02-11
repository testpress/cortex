# Architecture Documentation

This directory is the source of truth for the Cortex architectural philosophy and technical constraints.

## Contents

- **[architecture.md](architecture.md)**: High-level system design, package boundaries, and technical standards.
- **[ai_context.md](ai_context.md)**: Directive instructions for AI sessions to ensure consistency and prevent architectural violations.
- **[decisions/](decisions/)**: Significant Architecture Decision Records (ADRs) documenting historical rationale.

## Core Pillars

1. **Neutral UI**: No platform-specific visual widgets (Material/Cupertino).
2. **Design Governance**: Runtime token injection via DesignProvider.
3. **Accessibility**: Mandatory semantic helpers and motion preferences.
4. **SDK-First**: Strict internal/external boundaries.
