## Context

The Review Analytics screens are functional and complete. This design covers the targeted visual refinement pass described in the proposal — focusing on the header layout, section title hierarchy, the Explore More Details structure, and donut chart alignment.

## Goals / Non-Goals

**Goals:**
- Replace the "Back" text label in the header with the screen title inline next to the back icon, and change the chevron icon to a standard arrow, on both the landing screen and the Subject-wise Performance screen.
- Reduce the "Performance Overview" section heading to be visually smaller than the header title.
- Move the "Explore More Details" label outside its container and render the two action items as independent cards.
- Reduce the "Overall Performance" and "Section Performance" heading sizes on the Subject-wise Performance screen.
- Center the donut chart(s) dynamically if they fit on screen, falling back to horizontal scrolling if they exceed screen width.

**Non-Goals:**
- Changing the header's background, shadow, or border styling.
- Altering the content, behavior, or navigation logic of any card or screen.
- Modifying any data, state, or provider logic.

## Decisions

### 1. Header — inline title instead of "Back" label

The header currently has two visual rows: a back chevron with a "Back" text label, and a larger title headline below it. The chevron will be replaced with a standard arrow, and the "Back" text label will be replaced with the screen title (the exam name on the landing screen, the sub-screen name on Subject-wise Performance), displayed inline next to the back arrow. The large headline below will be removed. This makes the header more compact and contextual — the user always sees where they are without the generic "Back" label.

This change applies consistently to both screens that use this header pattern.

### 2. "Performance Overview" title size

The section heading will be brought down to a size that sits clearly below the header title in the visual hierarchy. The heading should feel like a section label, not a page title. Font weight stays bold.

### 3. Explore More Details — deconstructed layout

The current single-container grouping will be broken apart into three independent elements in the scroll list: the section label, the first action card, and the second action card. Each will have its own spacing from adjacent items.

The section label becomes a freestanding heading — no background, no border, no card styling. The two action cards remain visually as they are individually — only the shared outer wrapper is removed.

### 4. Subject-wise Performance section title sizes

Both "Overall Performance" and "Section Performance" headings will be reduced to match the same sizing decision as "Performance Overview" on the landing screen — a consistent section heading size across both screens.

### 5. Donut chart centering

The donut list is rendered as a horizontal scroll. Instead of hardcoding left-alignment, the list container will use a responsive centering pattern. If the chart(s) fit entirely on the screen (e.g. 1 or 2 charts), they will be automatically grouped in the center. If there are too many charts to fit, they will seamlessly overflow into a standard left-aligned horizontal scroll.

## Risks / Trade-offs

- **Risk**: Centering the horizontal donut list could affect how multi-item scroll behaves on smaller screens.
  - **Mitigation**: The centering should only apply to the scroll content alignment, not constrain item widths — so with multiple items, the user can still scroll naturally from left to right.
