# 🌦️ CimiloSheeg: Weather App (Flutter)

**CimiloSheeg** ("weather report" in Somali) is a weather app built with **Flutter**. It uses the device's location to fetch current weather from the OpenWeatherMap API.

> 🚧 **Work in progress.** Location and the API call are working. The weather display and the city search are still being built.

## Features

- **Dark-themed home screen** with a full-screen background image and a welcome message.
- **Current location.** Requests location permission and gets the device's GPS position with `geolocator`.
- **Live weather data.** Calls the OpenWeatherMap current weather API for that position, in metric units.
- **Search screen.** A screen for searching a city or country, with a UI layout for the result.

## Roadmap

- [ ] Show temperature, conditions and an icon on the home screen
- [ ] Connect the search screen to the API by city name
- [ ] Add a multi-day forecast
- [x] Move the API key out of the code into a git-ignored file

## Tech stack

| | |
|---|---|
| Framework | Flutter (Dart) |
| Location | `geolocator` |
| Networking | `http` |
| Weather data | [OpenWeatherMap API](https://openweathermap.org/api) |

## Getting started

```bash
git clone https://github.com/nainezz/weatherApp.git
cd weatherApp
cp lib/secrets.example.dart lib/secrets.dart   # then add your API key in lib/secrets.dart
flutter pub get
flutter run
```

You need your own free API key from [openweathermap.org](https://openweathermap.org/api). `lib/secrets.dart` is git-ignored, so your key stays on your machine. Requires Dart `>=2.17.6 <3.0.0`.

## Author

**Nainezz**, a software engineer in Nairobi, Kenya · [GitHub](https://github.com/nainezz)
