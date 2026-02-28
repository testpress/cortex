## Context

### Visual Debt Report
The system currently experiences "visual debt" in the following areas:
- **Component Geometry**: `card` radius is 12.0. Secondary components (buttons) lack a formal geometric relationship to the primary container.
- **Space Management**: Spacing follows a mixed 4pt/8pt rhythm without strict enforcement, leading to layout randomness.
- **Elevation System**: Shadows are hardcoded with high opacity (0.1) and small blur radii, creating harsh, noticeable boundaries.
- **Separation Stacking**: UI primitives often stack borders, shadows, and color deltas simultaneously, increasing visual noise.

## Goals / Non-Goals

**Goals:**
- **Calm Surface Transitions**: Enforce the Surface Contrast Contract to ensure depth via singular separation.
- **Precision Spacing**: Align all layout dimensions to the 8pt atomic set.
- **Confident Geometry**: Standardize the `Radius Hierarchy` (Card: 16.0, Button: 12.0).
- **Inert Shadows**: Implement Shadow Governance to make shadows "felt, not seen" (opacity <= 0.045).

**Non-Goals:**
- Introduction of branding/color changes beyond luminance calibration.
- Redesign of page layouts or information architecture.
- Adoption of Material 3 or Cupertino design patterns.

## Decisions

### Decision 1: Surface-Background Luminance Delta (0.02–0.05)
**Rationale**: To achieve a "Notion-style" low-noise interface, the distinction between the canvas and nested surfaces must be minimal. A 2–5% delta provides sufficient depth for accessibility without creating harsh visual borders.

### Decision 2: Radius = baseRadius * 2 for Primary Containers
**Rationale**: Linear-style precision and Fintech-level confidence are projected through generous but disciplined radii. Setting `card` radius to 16.0 (2x base) establishes a clear geometric hierarchy.

### Decision 3: Singular Separation Logic in UI Primitives
**Rationale**: To reduce "visual clutter," the system enforces a rule where only one separation method (Shadow OR Border OR Color Delta) is allowed per surface transition. 
- **Preference**: Shadow (SurfaceSoft) is preferred for primary elevation. Border is reserved for low-elevation secondary separation where shadow would conflict.

### Decision 4: Global Alpha-4% Shadow Standard
**Rationale**: Premium calibration requires shadows to be barely perceptible. Reducing opacity to 0.04 while doubling blur to 40.0 creates a "soft glow" rather than a hard boundary.

### Decision 5: Neutral 900/800 Basis for Dark Mode
**Rationale**: While a 950/900 basis (Pure Black/Zinc-950) offers an "inky" high-end feel, it can compromise component visibility in low-light environments. Adopting the industry-standard 900/800 basis (Zinc-900 for surface, Zinc-800 for card) ensures:
1. **Visibility**: Higher contrast ratio (~1.15:1) for better legibility and surface distinction.
2. **Standardization**: Alignment with established frameworks like Tailwind and Preline.
3. **Hierarchy**: The `canvas` will remain pure black (#000000) or Zinc-950 to preserve depth, with UI surfaces sitting at Zinc-900.

### Decision 6: Light Mode Midpoint Basis (Slate-150)
**Rationale**: Slate-100 (#F1F5F9) is too subtle, while Slate-200 (#E2E8F0) is too prominent. Adopting a custom "Slate-150" basis (#E9EEF4) achieves the ideal balance:
1. **Separation**: Provides a clear ~1.08:1 contrast ratio against white cards.
2. **Restraint**: Maintains the "calm" Notion-like quality without the heavy visual weight of a full Slate-200 background.

## Risks / Trade-offs

- **[Risk] Layering Ambiguity** → **[Mitigation]** Strictly enforce the Surface Contrast Contract’s 1.05:1 ratio for cards.
- **[Risk] High-Elevation Overlapping** → **[Mitigation]** Multi-layer shadows are explicitly permitted only for $z > 40$ exceptions.

## Token Migration Plan

### DesignRadius Refactor
- `card`: 12.0 → 16.0
- `button`: 8.0 → 12.0
- `dialog`: 16.0 → 24.0

### DesignSpacing Refactor
- Standardize all layout tokens to the 8pt set.
- `cardPadding`: 16.0 → 24.0
- `sectionGap`: 32.0 → 40.0

### DesignShadows (NEW)
- Integrate `DesignShadows` into `DesignConfig`.
- Implement `DesignShadows.light()` and `DesignShadows.dark()` factories.
