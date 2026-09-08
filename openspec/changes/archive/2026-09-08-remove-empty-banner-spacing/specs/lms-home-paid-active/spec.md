# Delta Spec: LMS Paid Active User Home Screen (`lms-home-paid-active`)

## MODIFIED REQUIREMENTS

### Requirement: Pixel-Perfect Component Spacing and Backgrounds
The system SHALL replicate exact component spacing without leaving empty gaps when section widgets are empty.

#### Scenario: Native self-contained component margins without external spacers
- **WHEN** section components (`TopCarouselSectionWidget`, `ContextualHeroSectionWidget`, `TodayScheduleSectionWidget`) are rendered
- **THEN** they MUST contain their own bottom margin/padding internally when content is present
- **AND** external `SizedBox` height widgets MUST NOT be placed between section roots in `_HomeLayout`
- **AND** when a section component contains no data (e.g. no banners or live classes), it MUST evaluate to `SizedBox.shrink()` with `0px` vertical margin/height.
