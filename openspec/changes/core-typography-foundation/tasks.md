## 1. Design Config Foundation

- [x] 1.1 Add `DesignTypographyScale` class to `DesignConfig` for atomic scale tokens (xs to xl5)
- [x] 1.2 Include `typographyScale` field in `DesignConfig` and its factories
- [x] 1.3 Update `DesignTypography.defaults()` to provide base atomic styles (size + default height)

## 2. Composed Typography Molecules

- [x] 2.1 Refactor `DesignTypography` semantic roles to bundle Size, Weight, Height, Tracking, and Color
- [x] 2.2 Implement "Optical Tracking" rules in `DesignTypography.defaults()` for headings vs. body text
- [x] 2.3 Ensure light/dark mode factories correctly map semantic colors (Primary vs. Secondary)

## 3. AppText Widget Enhancement

- [x] 3.1 Implement named constructors for the foundational scale (e.g., `AppText.lg()`, `AppText.xs()`)
- [x] 3.2 Update `AppText.build` logic to resolve styles from the composed molecules
- [x] 3.3 Ensure custom `color` and `style` overrides still work correctly with the new foundation

## 4. Verification & Testing

- [x] 4.1 Create `packages/core/test/design/typography_scale_test.dart` to verify token resolution
- [x] 4.2 Update `packages/core/test/widgets/app_text_test.dart` to cover the new scale constructors
- [x] 4.3 Verify text rendering across Light and Dark modes
