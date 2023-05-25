import 'dart:convert';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'FormPage.dart';
import 'Game0.dart';
import 'Tic/home_screen.dart';

import 'Snake/snake.dart';
// import 'Pong2/main.dart';
import 'Dot/dot.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

//const isDebug = bool.fromEnvironment('dart.vm.product') == false;
const url2 = kDebugMode
    ? "http://192.168.2.66:3002/submit"
    : "http://3.137.222.219:3002/submit";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialPage = '';

  @override
  void initState() {
    super.initState();
    _loadInitialPage();
  }

  void _loadInitialPage() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? "";

    setState(() {
      _initialPage = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...
      home: _buildInitialPage(),
    );
  }

  Widget _buildInitialPage() {
    // Determine which page to load based on the stored value
    if (_initialPage == '') {
      return FormPage();
    } else {
      return Home();
    }
  }
}

class Home extends StatelessWidget {
  Future<String> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();

    return jsonEncode({'lat': latitude, 'lon': longitude});

    latitude + " " + longitude;
  }

  Future<void> postRequest(String url, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';
    String birthday = prefs.getString('birthday') ?? '';
    String address = prefs.getString('address') ?? '';
    String ec = prefs.getString('emergency_contact') ?? '';
    String otherInfo = prefs.getString('other_info') ?? '';
    String currentAddress = await getCurrentLocation();

    print(currentAddress);

    String content = jsonEncode({
      'name': name,
      'birthday': birthday,
      'address': address,
      'ec': ec,
      'other_info': otherInfo,
      'current_address': jsonDecode(currentAddress)
    });
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"content": content}),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print(response.body);
      } else {
        print('POST request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Message is not send!");
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF7D1010),
        appBar: AppBar(
            title: const Text(
              'Good Game',
              style: TextStyle(
                fontFamily:
                    'IndieFlower', // Replace 'Roboto' with the desired font family
                fontSize: 30, // Adjust the font size as needed
                fontWeight: FontWeight
                    .bold, // Specify the font weight // Specify the font style (e.g., italic)
                color: Colors.white, // Specify the text color
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.red[600]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFD4AF37)),
                ),
                onPressed: () {
                  print("URL: " + url2);
                  postRequest(url2, '');

                  Random random = Random();
                  int randomNumber = random.nextInt(3) + 1;
                  print(randomNumber);

                  if (randomNumber == 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SnakeScreen()));
                  } else if (randomNumber == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TapTheDot()));
                  }
                },
                // color: Colors.amber,
                child: const Text(
                  'Play Game',
                  style: TextStyle(
                    fontFamily: 'IndieFlower',
                    fontSize: 25, // Adjust the font size as needed
                    fontWeight: FontWeight
                        .bold, // Specify the font weight // Specify the font style (e.g., italic)
                    color: Colors.white, // Specify the text color
                  ),
                ),
              ),
              const SizedBox(height: 30),
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.admin_panel_settings_outlined),
                color: Color(0xFFD4AF37),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FormPage()));
                },
              ),
            ],
          ),
        ));
  }
}
