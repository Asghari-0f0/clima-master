import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;

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
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      debugPrint("780: ${position.latitude}");
      debugPrint("380: ${position.longitude}");
    } catch (e) {
      debugPrint("Web location error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              getPermission();
            },
            child: const Text(
              'Get Location',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
