# native-html-table-rendering Specification

## Purpose
TBD - created by archiving change fix-table-cell-text-clipping. Update Purpose after archive.
## Requirements
### Requirement: Dynamic Height Sizing for Native HTML Tables
The `AppHtmlV2` widget SHALL strip restrictive inline height constraints and legacy height attributes from table elements so that table rows and cells size dynamically to fit their text content without vertical clipping.

#### Scenario: Table with inline height styles
- **WHEN** HTML containing a `<table>`, `<tr>`, `<td>`, or `<th>` with inline `style="height: 18px;"` or `style="line-height: normal;"` is passed to `AppHtmlV2`
- **THEN** the sanitization pass strips the restrictive height and line-height declarations
- **AND THEN** the table cell renders with sufficient height to display the full text without vertical clipping

#### Scenario: Table with legacy height attribute
- **WHEN** HTML containing a `<table>`, `<tr>`, or `<td>` with a legacy `height="20"` attribute is passed to `AppHtmlV2`
- **THEN** the sanitization pass removes the `height` attribute from the tag
- **AND THEN** the table row and cell dimensions are determined by content intrinsic height plus padding

### Requirement: Table Cell Padding and Border Integrity
The `AppHtmlV2` widget SHALL maintain cell padding and borders while allowing multiline text and equations inside table cells to render fully.

#### Scenario: Rendering table with multiple rows and cells
- **WHEN** an assessment question direction contains an HTML table with multiple rows of text and numeric values
- **THEN** borders are rendered using `currentColor` and cells have 6px padding around unclipped text content

