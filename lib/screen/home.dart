import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/screen/search.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('CilimoSheeg'),
        actions: [
          IconButton(
            onPressed: () async {
              LocationPermission permission =
                  await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {
                  return Future.error('Location permissions are denied');
                }
              }
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              print(position.latitude);
              var response = await http.get(Uri.parse(
                  'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=a2db19caba495fd4db81fc39f35c01ec&units=metric'));
              print(response.body);
            },
            icon: const Icon(Icons.pin_drop),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
          )
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
            image: const NetworkImage(
              'https://i.pinimg.com/originals/7e/b6/6d/7eb66d739c10bc4b32fc8fd45628901f.png',
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Kusoo dhawaaw',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 20),
                  ),
                  Text(
                    'CimiloSheeg App 🌦️',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: Text('CimiloSheeg App'),
              content: Text(
                  'CimiloSheeg waa Application loogu talo galay muujiyo cimilida'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(' ok got it'))
              ],
            ),
          );
        },
        child: Icon(Icons.info_outline),
      ),
    );
  }
}
