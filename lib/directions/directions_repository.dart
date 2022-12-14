import'package:dio/dio.dart';
import'package:flutter/foundation.dart';
import'package:google_maps_flutter/google_maps_flutter.dart';
import'package:foodpanda_users_app/directions/.env.dart';
import'package:foodpanda_users_app/directions/directions_model.dart';


class DirectionsRepository{
 static const String _baseUrl=
      'https://maps.googleapis.com/maps/api/directions/json?';

  late final Dio _dio;

 DirectionsRepository({required Dio dio}) : _dio = dio ?? Dio();
  Future<Directions?>getDirections({
   required LatLng origin,
   required LatLng destination,
 })async{
    final response = await _dio.get(
     _baseUrl,
     queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': googleAPIKey,
     },
    );

    //Check if response is succesful
   if (response.statusCode == 200) {
    return Directions.fromMap(response.data);
   }
   return null;
  }
}