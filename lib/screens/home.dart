import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      print('permission.denied');
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          print(
              'permission permanently denied, please provide permission to the map from device settings');
        } else {
          print('permission granted');
          getLocation();
        }
      } else {
        print('User denied the request');
      }
    } else {
      getLocation();
    }
  }

  Future<void> getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    NetWorkHelper netWorkHelper = NetWorkHelper(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey");
    var weatherData = await netWorkHelper.getData();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return Center(
        child: Text('Loading...'),
      );
    } else {
      return const Scaffold(
        body: const SafeArea(
          child: const Center(),
        ),
      );
    }
  }
}

// var id = decodedData['weather'][0]['id'];
// var temperature = decodedData['main']['temp'];
// var cityName = decodedData['name'];
