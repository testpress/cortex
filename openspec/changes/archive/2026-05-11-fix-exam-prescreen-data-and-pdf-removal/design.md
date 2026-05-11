## Context

The exam content type identification hinges purely on explicit `content_type` presence in dynamic JSON objects. When that string key is missing at the root, exams revert to `unknown` type, skipping specialized sub-parsers that would normally extract relevant fields like the exam slug.

Additionally, the product direction dictates moving away from "Download PDF" CTAs in the quick-actions prescreen.

## Goals / Non-Goals

**Goals:**
- Ensure content identified as an Exam provides its slug metadata reliably.
- Standardize fallback retrieval for key metrics like duration to cover specialized object maps.
- Remove deprecated PDF UI component.

**Non-Goals:**
- Redesigning the complete type parser strategy.
- Modifying downstream PDF downloading services.

## Decisions

### Decision 1: Feature-based type detection
Augment current type discovery heuristics with presence-checks for exclusive high-level objects. Specifically, checking for `json['exam'] != null` will designate the model as an exam content type.

### Decision 2: Unified Duration resolution
Extend standard generic parsing to explicitly scan the nested `exam` map for a valid `duration` string.

### Decision 3: Aesthetic Skeletonizer Loading
Integrate `skeletonizer` in `packages/exams`. Wrap metadata components in `Skeletonizer(enabled: examDetailAsync.isLoading)` to present high-fidelity UI structure instead of literal placeholder values (like `-- Questions`) during fetch intervals.

## Risks / Trade-offs

- **[Risk]** Nested map overlap (an object having both 'exam' and another key).
- **Mitigation**: Precedence ensures existing standard `content_type` checks always take priority if available, serving as a safe fallback chain.
