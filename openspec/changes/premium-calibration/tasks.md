- [x] 1.5 Recalibrate dark mode palette to neutral grays (Zinc) and ensure card visibility.
- [x] 1.6 Transition dark mode basis to 900/800 range (Zinc) as per industry standard.
- [x] 1.7 Recalibrate light mode surface contrast for 90/100 basis (Slate-200 background against white cards).
- [x] 1.8 Refine light mode to Slate-150 midpoint (#E9EEF4) for restrained prominence.

## 2. Component Refactor

- [x] 2.1 Update `AppCard` to implement strict singular separation logic (suppress border if shadow enabled).
- [x] 2.2 Ensure `AppCard` uses `DesignRadius.card` and `DesignShadows.surfaceSoft` tokens exclusively.

## 3. Verification & Testing

- [x] 3.1 Update `app_card_test.dart` to verify exactly 16.0 radius and binary singular separation pass.
- [x] 3.2 Update `app_primitive_design_test.dart` to verify new typography luminance constraints.
- [x] 3.3 Run all core tests to ensure zero regressions across the design system.
