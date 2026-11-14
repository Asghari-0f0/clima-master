import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude, longitude;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
      ),
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
