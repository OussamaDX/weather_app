import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/WeatherModel.dart';
import 'package:weather_app/service/call_to_api.dart';

// Provider for the API service
final weatherApiProvider = Provider<CallToApi>((ref) {
  return CallToApi();
});

// Provider for the weather data based on city name
final weatherProvider = FutureProvider.family<Weathermodel, String>((ref, cityName) async {
  final weatherApi = ref.watch(weatherApiProvider);
  return weatherApi.CallWeatherModel(false, cityName);
});

// Provider for current location weather data
final currentLocationWeatherProvider = FutureProvider<Weathermodel>((ref) async {
  final weatherApi = ref.watch(weatherApiProvider);
  return weatherApi.CallWeatherModel(true, "");
});

// Provider to store the current city (for UI state)
final currentCityProvider = StateProvider<String>((ref) {
  return "Rabat"; // Default city
});