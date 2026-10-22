# Client Runner

`app/scripts/run_client.dart` launches the Flutter app using a client's remote
configuration. It fetches client branding and settings, downloads required
assets, updates the selected native project, and starts `flutter run`.

Run it from the repository root because the script resolves the `app/`
directory relative to the current working directory.

## Prerequisites

- Flutter and Dart are installed and available on `PATH`.
- The client API is reachable from the development machine.
- A valid `CLIENT_API_KEY` is available.
- The working tree is clean, or any local native changes are safely backed up.

The runner restores native branding changes when Flutter exits. Its cleanup
uses Git restoration, so uncommitted changes in affected native files must not
be left in place before running it.

## Run the app

```bash
CLIENT_API_KEY="your_key" \
  dart run app/scripts/run_client.dart \
  --api-base-url=https://<sub-domain>.testpress.in
```

By default, the runner uses Android and debug mode.

## Options

| Option | Description |
| --- | --- |
| `--api-base-url=<url>` | Required client API base URL. |
| `--platform=android\|ios` | Target platform. Defaults to `android`. |
| `--mode=debug\|profile\|release` | Flutter mode. Defaults to `debug`. |
| `--config=<path>` | Optional config JSON path relative to the repository root. |

For example, to run the iOS client in profile mode with a feature config:

```bash
CLIENT_API_KEY="your_key" \
  dart run app/scripts/run_client.dart \
  --api-base-url=https://<sub-domain>.testpress.in \
  --platform=ios \
  --mode=profile \
  --config=config/elearn_brilliantpala.json
```

Press `Ctrl+C` to stop the app. The runner intercepts the signal so its
cleanup can restore temporary assets and native branding changes.
