
import 'package:json_annotation/json_annotation.dart';

part 'WeatherModel.g.dart';

@JsonSerializable()
class Weathermodel
{
  final String temp;
  final String city;
  final String desc;

  Weathermodel( { required this.temp, required this.city, required this.desc});

  Weathermodel.fromMap(Map<String, dynamic> json)
    : temp = json['main']['temp'].toString(),
    city = json['name'],
    desc = json['weather'][0]['description'];
  factory Weathermodel.fromJson(Map<String, dynamic> json) => _$WeathermodelFromJson(json);
  Map<String, dynamic> toJson() => _$WeathermodelToJson(this);
}