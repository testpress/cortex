## Context

`DesignConfig` currently covers generic semantic colors but has no subject-palette
or content-status tokens. All LMS screens need these. The key constraint is
**multi-tenancy**: subjects are API-driven (a JEE institute has Physics/Maths, a
bank coaching institute has Reasoning/Quant), so the token system must never
encode subject names — only color slots addressable by index.

`CourseDto.subjectColor` is currently a placeholder `String` (holding a hex or
label). It will be replaced by `colorIndex: int` to formalize the API contract.

## Goals / Non-Goals

**Goals:**
- `DesignSubjectPalette`: an ordered list of N color slots, each with
  background/foreground/accent, light + dark variants
- `DesignStatusColors`: 4 named states (live/completed/locked/upcoming), light + dark
- `card`/`onCard` tokens in `DesignColors`
- `CourseDto.subjectColor: String` → `colorIndex: int`
- Zero breaking changes to existing widget APIs

**Non-Goals:**
- Mapping specific subjects to color slots (that's the API/app layer's job)
- New widgets (`AppBadge`, `AppSubjectChip`) — those are in `lms-primitives`
- Encoding subject names anywhere in the design system

## Decisions

### Index-based palette, not named fields

**Decision:** `DesignSubjectPalette` exposes an ordered `List<SubjectColors>` with
`atIndex(int i)` lookup (wraps around if i ≥ length, so it's always safe).

**Rationale:** Named fields like `.physics` / `.chemistry` would be JEE-specific
and break any other institute using the app. With a palette, the API simply returns
`colorIndex: 2` and the widget calls `subjectPalette.atIndex(2)` — no knowledge
of subject names required in the design system.

**Alternative considered:** Map<String, SubjectColors> keyed by subject name.
Rejected — the key would have to come from somewhere, coupling the design system
to API field values or requiring an explicit mapping step.

### 8 palette slots (extensible)

**Decision:** Default palette has 8 distinct color slots (indigo, orange, emerald,
purple, rose, sky, amber, teal). This covers most foreseeable institutes.

**Rationale:** 8 ensures visual variety for up to 8 concurrent subjects without
repetition. `atIndex` wraps modularly so a 9th subject reuses slot 0 gracefully.

### Status colors as named fields (not indexed)

**Decision:** `DesignStatusColors` uses named properties (`live`, `completed`,
`locked`, `upcoming`) — not indexed.

**Rationale:** Unlike subjects, content states are a fixed, closed set defined by
the product model. They are not API-driven and don't vary between tenants.

### `card` token goes in `DesignColors`

**Decision:** Add `card`/`onCard` to `DesignColors` — not in either new group.

**Rationale:** Card background is a generic surface concern, not LMS-specific.
`AppCard` exists in core today and needs it.

### `CourseDto.colorIndex: int` (replaces `subjectColor: String`)

**Decision:** Update the DTO field to `int` to match the index-based palette contract.

**Rationale:** The old `subjectColor` was a placeholder string with no clear
semantics. `colorIndex` is explicit and maps directly to `subjectPalette.atIndex()`.

## Risks / Trade-offs

- **Palette wrap-around** — if an institute has 9+ subjects, slot 0 repeats.
  → Mitigation: 8 slots covers most real cases; tenants can override
  `DesignConfig.copyWith(subjectPalette: custom)` with more slots.
- **`smart()` factory uses default palette** — white-label callers get the
  standard 8-slot palette unless they override.
  → Accepted trade-off; `smart()` is for primary-brand color, not palette tuning.
- **CourseDto migration** — `subjectColor: String` → `colorIndex: int` changes
  the DTO; `MockDataSource` must be updated.
  → Low risk: contained to `packages/data` and `packages/courses`.
