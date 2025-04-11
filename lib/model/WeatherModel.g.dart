// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WeatherModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weathermodel _$WeathermodelFromJson(Map<String, dynamic> json) => Weathermodel(
      temp: json['temp'] as String,
      city: json['city'] as String,
      desc: json['desc'] as String,
    );

Map<String, dynamic> _$WeathermodelToJson(Weathermodel instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'city': instance.city,
      'desc': instance.desc,
    };
