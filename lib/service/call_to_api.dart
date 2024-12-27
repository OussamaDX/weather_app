import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/utils.dart';
import 'package:weather_app/api/apiRepo.dart';
import 'package:weather_app/constants/apiKey.dart';
import 'package:http/http.dart' as http;
import '../model/WeatherModel.dart';


/*
apikey : 

*/
class CallToApi
{
  
  Future<Weathermodel> CallWeatherModel(bool current,String name) async
  {
    try
    {
      // print('this is name of city: =>  ' + name);
      Position position = await getCurrentPosition();
      if (current)
      {
        List<Placemark> Placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
          );
          Placemark place = Placemarks[0];
          name = place.locality!;
      }
      var url = Uri.https('api.openweathermap.org', '/data/2.5/weather',
          {'q': name, "units": "metric", "appid": Apirepo.apiKey});
      final http.Response response = await http.get(url);
      if (response.statusCode == 200)
      {
        Map<String, dynamic> decodeJson = json.decode(response.body);
        return Weathermodel.fromMap(decodeJson);
      }
      else
      {
        throw ("Error fetching data from OpenWeatherMap API: $response.statusCode");
      }

    } catch (e)
    {
      print('this is a problem ==>> ${e}');
      throw ("error to find the weathee service: ");  
    }
  }

  Future<Position> getCurrentPosition() async
  {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled)
    {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}