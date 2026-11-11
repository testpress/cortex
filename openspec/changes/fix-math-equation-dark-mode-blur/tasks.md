## 1. Filter Implementation

- [x] 1.1 Implement ColorFilter.matrix constant for color inversion in AppHtmlV2
- [x] 1.2 Implement _DarkModeEquationFilter to reactively read Design.of(context).isDark

## 2. Equation Heuristics

- [x] 2.1 Implement _hasMathAttributes for class names, roles, and data attributes
- [x] 2.2 Implement _hasMathEngineUrl for known formula URLs
- [x] 2.3 Implement _parseElementHeight and _isLegacyInlineFormula for dimension/alignment fallback
- [x] 2.4 Compose _isEquationOrInlineImage and register BuildOp.inline for equation images

## 3. Verification & Testing

- [x] 3.1 Add widget tests for light mode, dark mode, and reactive theme toggle
- [x] 3.2 Verify non-math diagrams and height thresholds are preserved without inversion

