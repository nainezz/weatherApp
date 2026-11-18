import 'package:flutter/material.dart';
import 'package:weather/screen/search.dart';
import 'package:weather/weather_service.dart';
import 'package:weather/widgets/weather_view.dart';

const backgroundImage =
    'https://i.pinimg.com/originals/7e/b6/6d/7eb66d739c10bc4b32fc8fd45628901f.png';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final weather = await WeatherService.forCurrentLocation();
      if (!mounted) return;
      setState(() {
        _weather = weather;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e is WeatherException
            ? e.message
            : 'Something went wrong. Try again.';
        _loading = false;
      });
    }
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  Widget _content() {
    if (_loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text('Finding the weather where you are…',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      );
    }
    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MessageView(
              message: _error!,
              actionLabel: 'Try again',
              onAction: _loadLocation),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _openSearch,
            icon: const Icon(Icons.search),
            label: const Text('Search a city'),
          ),
        ],
      );
    }
    return WeatherView(weather: _weather!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('CimiloSheeg'),
        actions: [
          IconButton(
            tooltip: 'Weather where I am',
            onPressed: _loading ? null : _loadLocation,
            icon: const Icon(Icons.my_location),
          ),
          IconButton(
            tooltip: 'Search a city',
            onPressed: _openSearch,
            icon: const Icon(Icons.search),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOver,
            ),
            image: const NetworkImage(backgroundImage),
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadLocation,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight - 40),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Kusoo dhawaaw',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 20),
                        ),
                        const Text(
                          'CimiloSheeg App 🌦️',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        const SizedBox(height: 28),
                        _content(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'About this app',
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('CimiloSheeg App'),
              content: const Text(
                  'CimiloSheeg waa Application loogu talo galay muujiyo cimilida'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok, got it'))
              ],
            ),
          );
        },
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
