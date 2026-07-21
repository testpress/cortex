## Why

To allow white-labeled institute apps to adopt their own brand identity, we need to inject the client's `primary_color` (retrieved from the configuration API) directly into the app's design system. This solves the problem of hardcoded UI colors, enabling dynamic branding for different clients without maintaining separate forks or complicated runtime theme builders.

## What Changes

- Fetch `primary_color` from the remote config API during the build process.
- Pass the color into the Flutter build context via `--dart-define=PRIMARY_COLOR=<hex>`.
- Refactor `DesignColors.light()` and `DesignColors.dark()` to parse this environment variable at compile-time.
- Automatically calculate harmonious contrasting colors (`onPrimary`, `primaryContainer`, `onPrimaryContainer`) based on the injected brand color.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `dynamic-branding`: Expanding the current branding capability (which handles splash screens, icons, and logos) to also control the app's structural primary color theme.

## Impact

- **`app/scripts/run_client.dart` & `app/scripts/generate_client_app.dart`**: Modified to append `--dart-define=PRIMARY_COLOR` flags.
- **`packages/core/lib/design/design_config.dart`**: Modified to parse the flag and compute color palettes natively, bypassing `DesignColors.smart()` to preserve bespoke semantic background tokens.
