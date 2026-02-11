# Regression Testing Philosophy

# Purpose
Testing in the Cortex monorepo is not about visual pixel-perfection; it is about **contract validation**. Our tests are designed to prevent regressions in accessibility, design token sourcing, and motion governance.

# Why Golden Tests Are Avoided
For a cross-platform foundation, Golden tests are often fragile. Small differences in rendering engines or font rendering on CI/CD servers can cause false failures. Instead, we prioritize **Structural and Behavioral Testing**:
- **Structural**: Verifying the presence and configuration of widgets in the accessibility tree.
- **Behavioral**: Ensuring interactivity triggers the correct callbacks and semantic state updates.

# What These Tests Guarantee

### 1. Design Token Sourcing
All UI tests verify that widgets source their colors, spacing, and typography from the `DesignProvider` context. We specifically test with "Inverted" configurations to ensure no hardcoded colors remain.

### 2. Accessibility Contracts
Tests under `test/widgets/` must validate:
- Minimum hit targets (48x48dp).
- Existence of semantic labels for interactive elements.
- Correct semantic roles (e.g., button role for clickable elements).

### 3. Motion Governance
We test animation logic to ensure `MotionPreferences` correctly overrides durations and curves based on the provided accessibility context.

# Test Organization

- `test/design/`: Validation of the `DesignProvider` injection and runtime configuration updates.
- `test/accessibility/`: Core motion and focus preference testing.
- `test/widgets/`: Deep verification of UI primitives against design and accessibility contracts.

# Best Practices for Future Tests
1. **Behavioral over Visual**: Test that a button *works* and *is accessible* rather than its exact hexadecimal color.
2. **Context Injection**: Always wrap test subject widgets in a `DesignProvider` to mimic the runtime environment.
3. **Semantic Querying**: Use `find.bySemanticsLabel` where possible to ensure the accessibility tree is valid and searchable.
