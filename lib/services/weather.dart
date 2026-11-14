import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';

class Weather {
  Future<Map<String, dynamic>> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    final uri = Uri.parse(openWeatherMapURL).replace(queryParameters: {
      'units': 'metric',
      'lat': '${location.latitude}',
      'lon': '${location.longitude}',
      'appid': apiKey,
    });
    return NetWorkHelper(uri.toString()).getData();
  }

  Future<Map<String, dynamic>> getCityWeather(String cityName) async {
    final uri = Uri.parse(openWeatherMapURL).replace(queryParameters: {
      'units': 'metric',
      'q': '${cityName.trim()},AF',
      'appid': apiKey,
    });
    return NetWorkHelper(uri.toString()).getData();
  }
}
