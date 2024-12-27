import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/model/WeatherModel.dart';
import 'package:weather_app/pages/weatherScreen.dart';
import 'package:weather_app/service/call_to_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: const WeatherScreen(),
    );
  }
}
