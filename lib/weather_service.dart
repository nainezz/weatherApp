import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/secrets.dart';

/// Current weather for one place, as returned by OpenWeatherMap.
class Weather {
  final String place;
  final String country;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed; // metres per second
  final String description;
  final String icon;

  const Weather({
    required this.place,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = (json['wind'] ?? {}) as Map<String, dynamic>;
    final sys = (json['sys'] ?? {}) as Map<String, dynamic>;
    final list = (json['weather'] ?? []) as List<dynamic>;
    final first =
        list.isNotEmpty ? list.first as Map<String, dynamic> : <String, dynamic>{};
    return Weather(
      place: (json['name'] ?? '') as String,
      country: (sys['country'] ?? '') as String,
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      windSpeed: ((wind['speed'] ?? 0) as num).toDouble(),
      description: (first['description'] ?? '') as String,
      icon: (first['icon'] ?? '01d') as String,
    );
  }

  /// Image for the current conditions, served by OpenWeatherMap.
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@4x.png';
}

/// An error with a message that is safe to show to the user.
class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  static const _base = 'https://api.openweathermap.org/data/2.5/weather';

  /// Weather where the user is now. Asks for location permission if needed.
  static Future<Weather> forCurrentLocation() async {
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } catch (_) {
      throw const WeatherException(
          'Location isn\'t available here. Search for a city instead.');
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const WeatherException(
          'Location access is blocked. Allow it in your browser settings, '
          'or search for a city instead.');
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 20),
      );
    } catch (_) {
      throw const WeatherException(
          'Couldn\'t find your location. Search for a city instead.');
    }
    return _fetch('lat=${position.latitude}&lon=${position.longitude}');
  }

  /// Weather for a city name, for example "Nairobi" or "London, GB".
  static Future<Weather> forCity(String city) async {
    final name = city.trim();
    if (name.isEmpty) {
      throw const WeatherException('Enter a city name.');
    }
    return _fetch('q=${Uri.encodeQueryComponent(name)}');
  }

  static Future<Weather> _fetch(String query) async {
    final uri =
        Uri.parse('$_base?$query&appid=$openWeatherApiKey&units=metric');
    http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } catch (_) {
      throw const WeatherException(
          'Couldn\'t reach the weather service. Check your connection and try again.');
    }

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const WeatherException(
          'City not found. Check the spelling and try again.');
    }
    if (response.statusCode == 401) {
      throw const WeatherException(
          'The weather key isn\'t active yet. New keys can take up to 2 hours.');
    }
    if (response.statusCode == 429) {
      throw const WeatherException(
          'Too many requests right now. Try again in a minute.');
    }
    throw WeatherException(
        'The weather service had a problem (${response.statusCode}). Try again.');
  }
}
