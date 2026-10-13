## ADDED Requirements

### Requirement: Bounded PDF Rendering Cache and Viewport Memory
The PDF viewer SHALL bound native raster rendering memory usage during document viewing and continuous scrolling by limiting native raster image caching, maintaining a conservative viewport cache extent, and tiling large pages, preventing unbounded native heap growth and out-of-memory process terminations.

#### Scenario: Continuous scrolling through multi-page document
- **WHEN** a user continuously scrolls through pages of a multi-page PDF document
- **THEN** the PDF viewer SHALL limit native image rendering caching so that off-screen raster buffers can be collected
- **AND** the PDF viewer SHALL retain at most 0.5 viewport heights of pre-rendered cache extent
- **AND** the PDF viewer SHALL tile pages larger than 1500px rather than allocating monolithic textures
- **AND** the PDF viewer SHALL throttle page image decoding during rapid scrolling
- **AND** the PDF viewer SHALL NOT execute redundant background progressive page loading passes.
