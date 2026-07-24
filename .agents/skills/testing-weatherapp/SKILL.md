---
name: testing-weatherapp
description: Build, run, and end-to-end test the Flutter WeatherApp (climate) UI and its unit tests. Use when verifying UI or logic changes to this weather app.
---

# Testing WeatherApp (Flutter, package name `climate`)

## Toolchain
- Flutter is installed at `$HOME/flutter`. Add it to PATH: `export PATH="$HOME/flutter/bin:$PATH"`.
- From the repo root run `flutter pub get` once before building/testing.

## Unit / widget tests & analysis
```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter test          # 32 tests currently
flutter analyze       # clean except a pre-existing flutter_lints include warning (also on main)
```

## Run the app for visual/UI testing
Easiest reliable path is the web build served in the pre-running Chrome (do NOT launch a new Chrome):
```bash
export PATH="$HOME/flutter/bin:$PATH"
nohup flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0 > /tmp/flutterweb.log 2>&1 &
```
Wait ~25-40s for the first compile (tail `/tmp/flutterweb.log` until it prints `is being served at`), then navigate the controlled Chrome to `localhost:8080` (type just the host:port; typing a full `http://...` URL sometimes gets treated as a Google search and hits a captcha).

For before/after comparisons, add a `git worktree` of the other branch and serve it on a second port (e.g. 8081) so both run simultaneously.

## Triggering the UI states (see `lib/view/home_view.dart` `_buildBody`)
- **Empty**: initial load → `NoClimateState` ("Ready when you are" card).
- **Loaded**: type a real city (e.g. `London`) in the search field and click the send button → `ClimateLoadedState` weather card. The weather API key embedded in `lib/service/climate_services.dart` works against api.weatherapi.com and returns live data.
- **Error**: type a nonsense string (e.g. `zzzzzzzzz`) and submit → `ClimateFaillureState` ("Something went wrong" + "Try again").
- Background gradient color is derived from the condition via `getThemeColor` (e.g. orange for Sunny), so it visibly changes between empty and loaded.

## Notes
- The repo currently has NO CI workflows, so there are no PR checks to wait on.
- In Flutter widget tests, `Image.network` calls fail (status 400) in the test harness; consume via `tester.takeException()`. Production code uses an `errorBuilder` fallback icon.

## Devin Secrets Needed
- None. The weather API key is embedded in the repo source and no login is required.
