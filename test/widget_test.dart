import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather/weather_service.dart';
import 'package:weather/widgets/weather_view.dart';

// A trimmed OpenWeatherMap "current weather" response.
final sample = <String, dynamic>{
  'name': 'Nairobi',
  'sys': {'country': 'KE'},
  'main': {
    'temp': 22.6,
    'feels_like': 22.1,
    'temp_min': 20.4,
    'temp_max': 24.9,
    'humidity': 56,
  },
  'wind': {'speed': 4.1},
  'weather': [
    {'description': 'broken clouds', 'icon': '04d'}
  ],
};

void main() {
  test('reads the weather from an API response', () {
    final w = Weather.fromJson(sample);
    expect(w.place, 'Nairobi');
    expect(w.country, 'KE');
    expect(w.temp, 22.6);
    expect(w.humidity, 56);
    expect(w.windSpeed, 4.1);
    expect(w.description, 'broken clouds');
    expect(w.iconUrl, 'https://openweathermap.org/img/wn/04d@4x.png');
  });

  test('copes with integer values and missing optional fields', () {
    final w = Weather.fromJson({
      'name': 'Mogadishu',
      'main': {
        'temp': 30,
        'feels_like': 33,
        'temp_min': 30,
        'temp_max': 30,
        'humidity': 70,
      },
    });
    expect(w.temp, 30.0);
    expect(w.country, '');
    expect(w.windSpeed, 0);
    expect(w.icon, '01d');
  });

  test('an empty city name gives a clear message', () async {
    expect(
      () => WeatherService.forCity('   '),
      throwsA(isA<WeatherException>()
          .having((e) => e.message, 'message', 'Enter a city name.')),
    );
  });

  testWidgets('shows temperature, conditions and details', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: WeatherView(weather: Weather.fromJson(sample))),
    ));
    expect(find.text('Nairobi, KE'), findsOneWidget);
    expect(find.text('23°C'), findsOneWidget);
    expect(find.text('Broken clouds'), findsOneWidget);
    expect(find.text('56%'), findsOneWidget);
    expect(find.text('15 km/h'), findsOneWidget);
  });
}
