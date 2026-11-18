# 🌦️ CimiloSheeg: Weather App (Flutter)

**🔗 Live demo:** https://nainezz.github.io/weatherApp/

**CimiloSheeg** ("weather report" in Somali) is a weather app built with **Flutter**. It uses the device's location to fetch current weather from the OpenWeatherMap API.

## Features

- **Dark-themed home screen** with a full-screen background image and a welcome message.
- **Weather where you are.** On opening, the app asks for location permission (`geolocator`) and shows the current weather for your position.
- **Current conditions.** Temperature, conditions with an icon, high and low, feels-like, humidity and wind speed, in metric units.
- **City search.** Type any city (for example Nairobi, Mogadishu or London) to see its weather.
- **Clear error messages.** Explains what to do when location is blocked, a city isn't found or the connection fails, with a retry button.
- **Pull to refresh** on the home screen.

## Roadmap

- [x] Show temperature, conditions and an icon on the home screen
- [x] Connect the search screen to the API by city name
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

**Mohamed Yussuf (Nainezz)**, a software engineer in Nairobi, Kenya · [GitHub](https://github.com/nainezz)
