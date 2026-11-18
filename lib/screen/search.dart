import 'package:flutter/material.dart';
import 'package:weather/weather_service.dart';
import 'package:weather/widgets/weather_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Weather? _weather;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final city = _controller.text.trim();
    if (city.isEmpty) {
      setState(() => _error = 'Enter a city name.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final weather = await WeatherService.forCity(city);
      if (!mounted) return;
      setState(() {
        _weather = weather;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _weather = null;
        _error = e is WeatherException
            ? e.message
            : 'Something went wrong. Try again.';
        _loading = false;
      });
    }
  }

  Widget _result() {
    if (_loading) {
      return const CircularProgressIndicator();
    }
    if (_error != null) {
      return MessageView(message: _error!);
    }
    if (_weather != null) {
      return WeatherView(weather: _weather!);
    }
    return const Text(
      'Type a city, for example Nairobi, Mogadishu or London.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search a city')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              onChanged: (_) {
                if (_error == 'Enter a city name.') {
                  setState(() => _error = null);
                }
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'City name, for example Nairobi',
                suffixIcon: IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: _loading ? null : _search,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(child: _result()),
          ],
        ),
      ),
    );
  }
}
