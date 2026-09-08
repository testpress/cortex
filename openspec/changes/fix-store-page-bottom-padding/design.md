## Context

The Cortex mobile application uses a floating bottom navigation bar within `AppShell` that renders as an overlay over scrollable tab pages. Tab screens like `StudyScreen`, `ExamsScreen`, and `InfoPage` include a trailing `SliverToBoxAdapter(child: SizedBox(height: 120))` in their `CustomScrollView` slivers list to ensure all scrollable content can be brought above the floating navigation bar. `StorePage` currently lacks this trailing spacer, causing the last row of products in `ProductList` to remain partially obscured behind the navigation bar even when scrolled to `maxScrollExtent`.

## Goals / Non-Goals

**Goals:**
- Add trailing bottom clearance sliver to `StorePage`'s `CustomScrollView` so that bottom-most products are fully visible when scrolled to the end.
- Maintain consistent visual spacing and scrolling behavior across all bottom tab screens.

**Non-Goals:**
- Altering the global `AppShell` bottom navigation bar styling or architecture.
- Changing individual product card layouts or dimensions.

## Decisions

### Decision: Add trailing `SliverToBoxAdapter(child: SizedBox(height: 120))` in `StorePage`
- **Rationale**: Aligns directly with established patterns in `StudyScreen`, `ExamsScreen`, and `InfoPage`. 120dp provides ample clearance for the floating navigation pill (~64dp height + safe area bottom inset + margins) while feeling natural.
- **Alternatives considered**:
  - *Add padding inside `ProductList` widget*: Would tie the reusable `ProductList` component to root tab shell assumptions rather than keeping the screen wrapper responsible for screen-level viewport offsets.

## Risks / Trade-offs

- **[Risk] Extra whitespace on short content** → **Mitigation**: When products list is short and doesn't fill the screen, the scroll view still bounces smoothly with AlwaysScrollableScrollPhysics, which matches the behavior across all other LMS tabs.
