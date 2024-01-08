import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  static const String apiKey =
      '296a93f03e234fcf82f14de9cf81ae4d'; // Replace with your Weatherbit API key
  static const String city = 'Jamshedpur'; // Replace with your city name
  late String weatherDescription;
  late double temperature;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.weatherbit.io/v2.0/current?city=$city&key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherDescription = data['data'][0]['weather']['description'];
          temperature = data['data'][0]['temp'];
        });
      } else {
        // Handle error
        print('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other exceptions
      print('Exception while fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildInfoText('City: $city'),
            SizedBox(height: 10),
            buildInfoText(
                'Temperature: ${temperature?.toStringAsFixed(1) ?? 'Loading'}°C'),
            SizedBox(height: 10),
            buildInfoText('Weather: $weatherDescription'),
          ],
        ),
      ),
    );
  }

  Widget buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20),
    );
  }
}
