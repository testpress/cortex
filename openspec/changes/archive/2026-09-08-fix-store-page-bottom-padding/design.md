## Context

The Cortex mobile application uses a floating bottom navigation bar within `AppShell` that renders as an overlay over scrollable tab pages. Tab screens like `StudyScreen`, `ExamsScreen`, and `InfoPage` include a trailing `SliverToBoxAdapter(child: SizedBox(height: 120))` in their `CustomScrollView` slivers list to ensure all scrollable content can be brought above the floating navigation bar. `StorePage` lacked this trailing spacer, causing the last row of products in `ProductList` to remain partially obscured behind the navigation bar when scrolled to `maxScrollExtent`.

Additionally, course titles previously allowed variable lines, and the price row's `FittedBox` scaled down both width and height when long price strings were present. This caused cards with long prices (or differing title lengths) to collapse vertically, creating uneven card heights across the 2-column grid.

## Goals / Non-Goals

**Goals:**
- Add trailing bottom clearance sliver to `StorePage`'s `CustomScrollView` so that bottom-most products are fully visible when scrolled to the end.
- Standardize `ProductCard` title to use single-line ellipsis (`maxLines: 1, overflow: TextOverflow.ellipsis`), ensuring uniform title vertical space without artificial gaps.
- Constrain the price row `FittedBox` in a fixed 24dp vertical box (`SizedBox(height: design.spacing.lg)`), guaranteeing that all cards in the grid have identical dimensions regardless of price string length.

**Non-Goals:**
- Altering the global `AppShell` bottom navigation bar styling or architecture.
- Redesigning the full product detail screen.

## Decisions

### Decision 1: Add trailing `SliverToBoxAdapter(child: SizedBox(height: 120))` in `StorePage`
- **Rationale**: Aligns directly with established patterns in `StudyScreen`, `ExamsScreen`, and `InfoPage`. 120dp provides ample clearance for the floating navigation pill (~64dp height + safe area bottom inset + margins).

### Decision 2: Single-line ellipsis (`maxLines: 1`) + Fixed 24dp Price Row (`design.spacing.lg`) in `ProductCard`
- **Rationale**: Single-line ellipsis ensures title heights are uniform without awkward middle gaps on short titles. Enclosing the price `FittedBox` in `SizedBox(height: design.spacing.lg)` (24dp) ensures that when long prices (e.g. `₹15000.00 ₹100000.00`) scale down horizontally to prevent overflow, they do not collapse the vertical height of the card.

## Risks / Trade-offs

- **[Risk] Long prices appear in smaller font size** → **Mitigation**: `FittedBox(fit: BoxFit.scaleDown)` gracefully prevents `RenderFlex` overflow while `SizedBox(height: design.spacing.lg)` maintains card grid uniformity.
