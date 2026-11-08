import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude, longitude;

 Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      debugPrint("Web location error: $e");
    }
  }
}
