## 1. Analytics Header — Inline Title, Remove "Back" Text

- [x] 1.1 In the analytics header widget, remove the "Back" text label and its spacing from the back button row.
- [x] 1.2 Replace the chevron icon with a standard arrow, and replace the "Back" text with the title string passed into the header, displayed inline.
- [x] 1.3 Remove the large headline text block that currently sits below the back button row.
- [x] 1.4 Verify the header renders correctly on both the Review Analytics landing screen and the Subject-wise Performance screen.

## 2. "Performance Overview" Title — Reduce Size

- [x] 2.1 In the Review Analytics landing screen, reduce the "Performance Overview" section heading to the standard section title size used across the app.

## 3. Explore More Details — Deconstructed Layout

- [x] 3.1 In the `ExploreDetailsCard` widget, remove the outer container (background, border, padding wrapper) that groups the label and both action items.
- [x] 3.2 Move the "Explore More Details" label out of the card widget and render it as a standalone section heading directly in the landing screen's scroll list.
- [x] 3.3 Render each of the two action items as independent top-level items in the scroll list, with appropriate spacing between them and surrounding elements.

## 4. Subject-wise Performance — Section Title Sizes

- [x] 4.1 Reduce the "Overall Performance" heading to the standard section title size.
- [x] 4.2 Reduce the "Section Performance" heading to the standard section title size.

## 5. Subject-wise Performance — Center Donut Chart(s)

- [x] 5.1 Refactor the donut list to use a responsive centering pattern (Center > SingleChildScrollView > Row).
- [x] 5.2 Verify that a small number of charts center automatically, and a large number of charts overflow into a left-aligned horizontal scroll.
