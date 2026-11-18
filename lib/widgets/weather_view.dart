import 'package:flutter/material.dart';
import 'package:weather/weather_service.dart';

/// Shows the current weather for one place.
class WeatherView extends StatelessWidget {
  final Weather weather;
  const WeatherView({Key? key, required this.weather}) : super(key: key);

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final place = weather.country.isEmpty
        ? weather.place
        : '${weather.place}, ${weather.country}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place_outlined, size: 20, color: Colors.white70),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                place,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        Image.network(
          weather.iconUrl,
          width: 120,
          height: 120,
          errorBuilder: (_, __, ___) => const SizedBox(height: 24),
        ),
        Text(
          '${weather.temp.round()}°C',
          style: const TextStyle(
              fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          _capitalise(weather.description),
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          'High ${weather.tempMax.round()}°  ·  Low ${weather.tempMin.round()}°',
          style: const TextStyle(fontSize: 15, color: Colors.white70),
        ),
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Detail(
                  icon: Icons.thermostat,
                  label: 'Feels like',
                  value: '${weather.feelsLike.round()}°C'),
              _Detail(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '${weather.humidity}%'),
              _Detail(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${(weather.windSpeed * 3.6).round()} km/h'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Detail(
      {Key? key, required this.icon, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }
}

/// A message with an optional action, used for errors.
class MessageView extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const MessageView(
      {Key? key, required this.message, this.actionLabel, this.onAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, color: Colors.white),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
