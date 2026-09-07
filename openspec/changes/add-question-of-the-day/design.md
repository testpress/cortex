## Context

The application introduces the "Question of the Day" (QOTD) feature to enhance student daily retention. We utilize the `/api/v2.4/daily_questions/` JSON endpoint to power a native interactive quiz workflow.

## Goals / Non-Goals

**Goals:**
- Update `InstituteSettings` to parse and store `qotdEnabled`.
- Fetch and dynamically parse daily questions data with support for polymorphic subject/difficulty payloads.
- Provide a dual-screen flow: `QotdOverviewScreen` (summary & statistics) and `QotdQuizScreen` (interactive stepper quiz).
- Use `AppHtmlV2` with MathJax SVG rendering support.

**Non-Goals:**
- Using a WebView.

## Decisions

**1. Native Interactive Quiz Architecture with Riverpod**
- **Rationale**: Manages question navigation, option selection, optimistic submissions, and solution state via `QotdQuizController`.

**2. Robust Dynamic Subject Parsing in `QotdDto`**
- **Rationale**: The backend returns subjects in varied shapes (flat strings, `{name: ...}` maps, lists, category tags). A dynamic extractor handles all shapes without artificial hardcoded fallbacks.

**3. Streamlined Question Header & Unified Metadata Pill**
- **Rationale**: Placing progress only in `AppHeader` and grouping `[Subject • Difficulty • Type]` into a single pill with `#0F172A` high-contrast text removes UI clutter while improving scannability.

**4. `AppHtmlV2` MathJax SVG Rendering**
- **Rationale**: Decodes and renders custom MathJax SVGs natively within the HTML flow.

## Risks / Trade-offs

- **Risk: Varying API Payload Structures** → Mitigation: Dynamic extractor in `QotdDto` ensures resilient parsing across different question serializers.
