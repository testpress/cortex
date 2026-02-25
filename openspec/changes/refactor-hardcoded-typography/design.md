## Context

The `courses` package was implemented with "Figma-first" code that used exact pixel values to match the design. To ensure long-term maintainability and alignment with the Typography Foundation, we must transition to a semantic-first resolution strategy.

## Goals / Non-Goals

**Goals:**
- Eliminate all hardcoded `fontSize`, `fontWeight`, and `letterSpacing` in `packages/courses`.
- **Prioritize semantic constructors** (`AppText.title`, `AppText.body`, etc.) over atomic scale tokens (`AppText.lg`, `AppText.xl`).
- Ensure contextual consistency across similar UI elements (e.g., all section headers use the same semantic role).

**Non-Goals:**
- Changing weights or sizes purely for the sake of mapping, if it significantly degrades the existing high-fidelity layout.
- Refactoring non-text styling.

## Decisions

### 1. Semantic Mapping Strategy
Instead of mapping by pixel value, we will map by the **functional role** of the text within the dashboard:

| Dashboard Element | Hardcoded Detail | Target Semantic Role | Rationale |
|---|---|---|---|
| Dashboard Title | 18px / w600 | `AppText.title()` | Primary page-level heading. |
| Section Greetings | 22px / w600 | `AppText.headline()` | Primary attention point for the user. |
| Section Headers | 18px / w600 | `AppText.subtitle()` | Secondary group heading. |
| Card Titles | 15px / w600 | `AppText.body()` | Tertiary item titles. |
| Card Body/Meta | 13px / 12px | `AppText.bodySmall()` | Supporting descriptive text. |
| Micro-labels | 10px / 11px | `AppText.caption()` | Lowest level metadata/indicators. |

### 2. Atomic Scale Usage
Atomic scale tokens (`AppText.lg()`, `AppText.xl3()`, etc.) will be reserved for:
- Statistical visualizations (e.g., the 28px numbers in `StudyMomentumGrid`).
- Custom hero components where a standard typographic role does not exist.
- Dense list items that require exact size control.

## Risks / Trade-offs

- **Risk**: Semantic roles might have different line-heights or tracking than the hardcoded Figma values.
- **Mitigation**: Prefer the Design System's standardized line-heights to improve readability across the entire app, even if it creates minor vertical shifts.
