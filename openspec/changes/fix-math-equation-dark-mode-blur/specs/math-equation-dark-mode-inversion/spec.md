## ADDED Requirements

### Requirement: Dark Mode Math Equation Color Inversion
The `AppHtmlV2` widget SHALL detect math formula images and apply an alpha-preserving color inversion filter when dark mode is active.

#### Scenario: Formula image rendered in dark mode
- **WHEN** `AppHtmlV2` renders an HTML string containing an equation image (e.g. Wiris, LaTeX, or legacy inline formula) in dark mode
- **THEN** the image is wrapped in a `ColorFiltered` widget applying color matrix inversion to render crisp white strokes

#### Scenario: Formula image rendered in light mode
- **WHEN** `AppHtmlV2` renders an equation image in light mode
- **THEN** the image is rendered normally without color inversion

### Requirement: Reactive Theme Adaptation
The equation color inversion SHALL reactively toggle when the application theme switches between light and dark modes without requiring HTML re-parsing.

#### Scenario: Dynamic theme toggle
- **WHEN** the user switches between light mode and dark mode at runtime
- **THEN** the equation filter updates immediately without rebuilding the HTML parse tree

### Requirement: Equation Image Detection Heuristics
The renderer SHALL distinguish inline equations from diagrams and illustrations using class indicators, roles, data attributes, URL patterns, or inline alignment and height boundaries.

#### Scenario: Explicit formula classes or URLs
- **WHEN** an image tag has a class containing `wiris`, `math`, `formula`, or `equation`, or a URL containing recognized formula engines
- **THEN** the element is classified as an equation

#### Scenario: Large general diagrams
- **WHEN** an image is a general illustration without formula attributes and has height exceeding 50dp
- **THEN** the element is NOT classified as an equation and is not inverted

