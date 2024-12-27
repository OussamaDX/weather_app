
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/model/WeatherModel.dart';
import 'package:weather_app/service/call_to_api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Weathermodel> _weatherData;
  final String nameCity = "Rabat";
  final String assetName = 'https://www.flaticon.com/free-icon/location_2838912?term=location&page=1&position=3&origin=search&related_id=2838912';
  TextEditingController textController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _weatherData = getWeatherData(false, nameCity);
  }

  Future<Weathermodel> getWeatherData(bool isCurrentCity, String cityName) async {
    return await CallToApi().CallWeatherModel(isCurrentCity, cityName);
  }

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3366FF), // Top gradient color
            Color(0xFFFF9933), // Bottom gradient color
          ],
        ),
      ),
      child: Column(
        children: [
          // Search bar at the top
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20), // Add padding to keep it away from screen edges
            child: AnimSearchBar(
              rtl: true,
              width: MediaQuery.of(context).size.width - 40,
              color: Color(0xffffb56b),
              textController: textController,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: 26,
              ),
              onSuffixTap: () async {
                if (textController.text.isEmpty) {
                  developer.log("No city entered");
                } else {
                  setState(() {
                    _weatherData = getWeatherData(false, textController.text);
                  });
                }
                FocusScope.of(context).unfocus();
                textController.clear();
              },
              onSubmitted: (_) {},
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 20), // Spacing between the search bar and the rest of the content
          // Weather data in the center
          Expanded(
            child: FutureBuilder<Weathermodel>(
              future: _weatherData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/location.svg',
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${weather.city}',
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${weather.desc}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${weather.temp}°C',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}
