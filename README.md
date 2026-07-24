# climate

A simple Flutter weather app. Search for a city and see today's forecast
(current condition, average/max/min temperature) powered by
[WeatherAPI](https://www.weatherapi.com/).

## Architecture

- `lib/service/` — `ClimateServices` calls the WeatherAPI forecast endpoint via `dio`.
- `lib/model/` — `ClimateModel` parses the API response.
- `lib/get_climate_cubit/` — `flutter_bloc` cubit + states driving the UI.
- `lib/view/` & `lib/widget/` — the home screen and its widgets.

## Configuration

The WeatherAPI key is **not** stored in source. Provide it at build/run time
with `--dart-define`:

```bash
flutter run --dart-define=WEATHER_API_KEY=your_key_here
flutter build apk --dart-define=WEATHER_API_KEY=your_key_here
```

Get a free key at https://www.weatherapi.com/.

## Running

```bash
flutter pub get
flutter run --dart-define=WEATHER_API_KEY=your_key_here
```

## Tests

```bash
flutter test
```
