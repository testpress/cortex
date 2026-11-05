## Context

The backend has merged support in API v3 (`GET /api/v3/products/{slug}/`) for product-level benefits and plan-level benefit assignments. Each product can have a master list of active benefits, and each subscription plan specifies which benefits are included. The mobile app previously required opening a modal bottom sheet to pick a plan. The new design surfaces plans and plan comparison directly inline on the product detail page.

## Goals / Non-Goals

**Goals:**
- Render an inline "Choose a plan" section on `ProductDetailScreen` when `product.plans.isNotEmpty`.
- Provide a duration segmented filter (`90 days`, `180 days`, etc.) at the top that updates pricing across all plan cards.
- Render vertically stacked plan radio cards with title, description, price/strike price, course count, benefit count (`X of Y benefits`), and radio indicator.
- Render an inline "Compare plans" section with segmented tabs (`[Basic] [Standard] [Premium]`) and a synchronized checklist of Courses (✓/✕) and Benefits (✓/✕).
- Maintain two-way synchronization: selecting a plan card updates the comparison tab and the active checkout tier; selecting a comparison tab updates the active plan card.
- Retain the standalone "What you get" perks section for products without subscription plans.
- Comply strictly with Neutral UI tokens, accessibility standards (WCAG 48dp, screen readers), and localization.

**Non-Goals:**
- Implementing an admin CRUD interface for benefits (handled exclusively in Django admin/web).
- Altering the payment flow, order creation endpoint, or coupon validation logic.
- Horizontal 2-axis scrolling desktop table that hurts narrow mobile ergonomics; we use the mobile-native segmented tab pattern provided in design specs.

## Decisions

### Decision 1: Inline "Choose a Plan" Section on Mobile
* **Choice**: Display plans directly on `ProductDetailScreen` as vertically stacked radio cards with a duration pill toggle.
* **Rationale**: Eliminates the extra modal barrier. Students can immediately compare tiers, understand pricing, and pick their preferred duration right in the main scroll view.

### Decision 2: Mobile-First "Compare Plans" Segmented Tabs
* **Choice**: Right below the plan cards, render a "Compare plans" section with a segmented tab selector (`[Basic Access] [Standard Access] [Premium Elite]`). Under the active tab, display two clear groups:
  1. **Courses**: All courses in the product with ✓ if included in that plan, or ✕ if excluded.
  2. **What you get**: All benefits in the product with ✓ if included, or ✕ if excluded.
* **Rationale**: Directly matches the provided mobile design mockup. Prevents horizontal table clashing on phone screens while giving immediate clarity on what is included.

### Decision 3: Two-Way Synchronization
* **Choice**: `selectedPlanId` drives both the active radio card above and the active comparison tab below.
* **Rationale**: Tapping a plan card scrolls/switches the comparison view to that plan, and tapping a tab above the table selects that plan for purchase.

## Risks / Trade-offs

* **[Risk] Long product detail page** → **Mitigation**: Clean spacing, compact checklist items with `LucideIcons.check` and `LucideIcons.x`, and clear section headers.
* **[Risk] Missing duration tiers for some plans** → **Mitigation**: If a plan does not have a tier for the selected duration, display the plan's available duration or disable selection with clear messaging.
