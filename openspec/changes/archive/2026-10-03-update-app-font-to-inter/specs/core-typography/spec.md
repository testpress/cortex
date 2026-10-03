# Spec Delta

## MODIFIED Requirements

### Requirement: Foundational Typography Scale
The system SHALL provide a standardized, scale-based typography system to replace arbitrary font sizes, constructed using the Inter typeface family across all foundational tokens.

#### Scenario: Predefined Scale Access
- **WHEN** a developer accesses typography tokens in `DesignConfig`
- **THEN** they SHALL have access to a scale containing:

| Token | Font Size (px) | Default Line Height | Weight Mapping |
| --- | --- | --- | --- |
| `xs` | 12px | 1.2 | Caption |
| `sm` | 14px | 1.4 | BodySmall |
| `base` | 16px | 1.5 (Role-based) | Body |
| `lg` | 18px | — | Subtitle |
| `xl` | 20px | — | Title |
| `xl2` | 24px | — | Headline |
| `xl3` | 30px | — | Display |
| `xl4` | 36px | — | — |
| `xl5` | 48px | — | — |
- **AND** all typography scale tokens SHALL inherit the Inter font family.
