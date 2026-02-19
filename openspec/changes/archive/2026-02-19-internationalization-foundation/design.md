# Design: Internationalization Foundation

## Context

The Cortex SDK needs a scalable way to handle translations and bi-directional layouts across a monorepo.

## Decisions

### Decision 1: LocalizationProvider & Code Gen
We will use `flutter_gen` / `intl` for ARB generation.
- `LocalizationProvider` will be a `StatelessWidget` wrapping `DesignProvider`.
- It will inject `Localizations` coordinates into the widget tree.
- A `l10n` helper utility will be added to `packages/core` to simplify access: `l10n.of(context)`.

### Decision 2: Cross-Package ARB Discovery
Since `intl` code-gen typically targets a single directory, we will establish a "Package Delegate" pattern:
- Each domain package (`courses`, `exams`) exports its own `LocalizationsDelegate`.
- The `app` shell merges these into its root `MaterialApp`.

### Decision 3: Logical Unit Migration
To support RTL without manual "flip" logic, we will convert standard widgets to directional units:
- `EdgeInsets.only(left: 10)` -> `EdgeInsetsDirectional.only(start: 10)`
- `Alignment.centerLeft` -> `AlignmentDirectional.centerStart`
- `Row(mainAxisAlignment: MainAxisAlignment.start)` -> Already logical, works out of the box.

### Decision 4: Directionality Wrapper
We'll ensure `LocalizationProvider` also manages `Directionality` based on the current locale's `textDirection`.

## Risks / Trade-offs

- [Risk] Hardcoded `left`/`right` in existing widgets will break RTL.
- [Mitigation] Lint rules (optional) or manual audit during verification.
