## Context

The current `DesignTypography` tokens are limited to a high-level semantic set (`display`, `headline`, `title`, etc.). While correct for simple UIs, high-density screen designs often require specific sizes (e.g., 18px or 13px) that don't fit these roles. This has led to the proliferation of "magic numbers" in feature widgets.

| Token | Size | Height | Role Mapping |
|---|---|---|---|
| `xs` | 12 | 1.3 | Caption |
| `sm` | 14 | 1.5 | BodySmall |
| `base` | 16 | 1.5 | Body |
| `lg` | 18 | 1.4 | Subtitle |
| `xl` | 20 | 1.4 | Title |
| `xl2` | 24 | 1.3 | Headline |
| `xl3` | 30 | 1.2 | Display |
| `xl4` | 36 | 1.1 | - |
| `xl5` | 48 | 1.0 | - |

## Goals / Non-Goals

**Goals:**
- **Atomic Scale**: Provide a foundational typography scale (12px to 48px) that eliminates magic numbers.
- **Composed Molecules**: Redefine semantic roles as compositions of 5 attributes: Size, Weight, Height, Tracking, and Color.
- **Optical Tracking**: Implement automatic letter-spacing adjustments for large vs. small text.
- **Contextual Defaults**: Ensure semantic roles default to the correct theme color (Primary vs. Secondary).

**Non-Goals:**
- **Dynamic Fonts**: This design does not change the font families used (Roboto/Inter remains).
- **Rich Text Engine**: We are not building a replacement for `RichText`, only improving the `AppText` primitive.

## Decisions

### 1. Hybrid Design System Structure
We will adopt a multi-layered approach to typography:
- **Atoms**: `DesignTypographyScale` defines the raw scale and base line heights. These are **color-neutral**.
- **Molecules**: `DesignTypography` roles (e.g., `body`, `caption`) are **compositions** of scale atoms + weight + tracking + semantic color.

### 2. The 5-Attribute Molecule
A semantic role is no longer just a `TextStyle`. It is defined by the following composition:
- **Scale Atom**: Sets the `fontSize` and base `height`.
- **Density**: Sets `fontWeight`.
- **Rhythm**: Overrides/refines `height` for the specific intent.
- **Tracking**: Sets `letterSpacing` (Optical Tracking).
- **Intent**: Provides a default `DesignColors` key (e.g. `textSecondary` for captions).

### 3. Optical Tracking Rules
To ensure high-end aesthetics, the tracking will be dynamically assigned:
- **Large Scales (xl3 to xl5)**: Negative tracking (e.g., `-0.5` to `-0.025em`) to maintain "tension" in display text.
```dart
final display = design.typographyScale.xl3.copyWith(
  fontWeight: FontWeight.w700,
  letterSpacing: -0.5,
);
```
- **Body Scales (base)**: Slight positive tracking (e.g., `0.1` to `0.2`) for improved legibility.
- **Micro Scales (xs)**: Increased tracking to prevent character merging at 12px.

### 4. Implementation Strategy in `AppText`
Instead of having 20+ independent constructors, `AppText` will use a private internal factory that resolves the configuration:
```dart
// Conceptual building logic
final style = _variant != null 
  ? design.typography.fromVariant(_variant) 
  : design.typography.fromScale(_scale);

return Text(
  text,
  style: style.copyWith(color: color ?? style.color),
);
```

## Risks / Trade-offs

- **[Risk] Complexity in DesignConfig** → We will use factory defaults to hide the complexity from standard users.
- **[Risk] Migration overhead** → Existing semantic roles will be preserved (re-mapped) to ensure backward compatibility.
- **[Trade-off] Multi-attribute tokens** → Storing 5 attributes per role increases memory footprint slightly but significantly improves design consistency.
