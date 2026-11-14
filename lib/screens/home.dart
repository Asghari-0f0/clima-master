import 'package:clima/components/details_widget.dart';
import 'package:clima/components/error_meessage.dart';
import 'package:clima/components/loading_widget.dart';
import 'package:clima/models/weather_model.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isErrorOccured = false;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;
  int code = 0;
  final Weather weather = Weather();
  final TextEditingController cityController = TextEditingController();
  String? title, message;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> getPermission() async {
    setState(() {
      isDataLoaded = false;
      isErrorOccured = false;
    });
    try {
      permission = await geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await geolocatorPlatform.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showError(
          'Location is turned off',
          'Please enable the location service to see weather condition for your location',
        );
        return;
      }
      await updateUI();
    } catch (e) {
      debugPrint('Could not check location permission: $e');
      _showError(
        'Location is turned off',
        'Please enable the location service to see weather condition for your location',
      );
    }
  }

  Future<void> updateUI() async {
    try {
      if (!await geolocatorPlatform.isLocationServiceEnabled()) {
        _showError(
          'Location is turned off',
          'Please enable the location service to see weather condition for your location',
        );
        return;
      }
      final weatherData = await weather.getLocationWeather();
      _setWeatherModel(weatherData);
    } catch (e) {
      debugPrint('Could not load local weather: $e');
      _showError(
        'Location is turned off',
        'Please enable the location service to see weather condition for your location',
      );
      return;
    }
    if (!mounted) return;
    setState(() {
      isErrorOccured = false;
      isDataLoaded = true;
    });
  }

  Future<void> searchCity(String cityName) async {
    final city = cityName.trim();
    if (city.isEmpty) {
      _showError('City name required', 'Enter the name of an Afghan city.');
      return;
    }

    setState(() {
      isDataLoaded = false;
      isErrorOccured = false;
    });
    try {
      final weatherData = await weather.getCityWeather(city);
      _setWeatherModel(weatherData);
    } catch (e) {
      debugPrint('Could not load weather for $city: $e');
      _showError(
        'City not found',
        'Check the city name and your internet connection, then try again.',
      );
      return;
    }
    if (!mounted) return;
    setState(() {
      isErrorOccured = false;
      isDataLoaded = true;
    });
  }

  void _setWeatherModel(Map<String, dynamic> weatherData) {
    code = weatherData['weather'][0]['id'];
    weatherModel = WeatherModel(
      description: weatherData['weather'][0]['description'],
      location: '${weatherData['name']}, ${weatherData['sys']['country']}',
      temperature: weatherData['main']['temp'],
      feelsLike: weatherData['main']['feels_like'],
      humidity: weatherData['main']['humidity'],
      wind: weatherData['wind']['speed'],
      icon:
          'images/weather-icons/${getIconPrefix(code)}${kWeatherIcons[code.toString()]!['icon']}.svg',
    );
  }

  void _showError(String errorTitle, String errorMessage) {
    if (!mounted) return;
    setState(() {
      isErrorOccured = true;
      isDataLoaded = true;
      title = errorTitle;
      message = errorMessage;
    });
  }
 
  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const Scaffold(
        body: Center(child: LoadingWidget()),
        backgroundColor: Colors.black,
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 2;
                  return Row(
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: cityController,
                              textInputAction: TextInputAction.search,
                              decoration: kTextFieldDecoration,
                              onSubmitted: searchCity,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: getPermission,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kOverlayColor,
                                foregroundColor: kMidLightColor,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'My Location',
                                      style: kTextFieldTextStyle,
                                    ),
                                    const SizedBox(width: 3),
                                    const Icon(
                                      Icons.gps_fixed,
                                      color: Colors.white60,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              isErrorOccured
                  ? ErrorMeessage(title: title!, message: message!)
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_city, color: kMidLightColor),
                              SizedBox(width: 12),
                              Text(
                                weatherModel!.location!,
                                style: kLocationTextStyle,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          SvgPicture.asset(
                            weatherModel!.icon!,
                            height: 280,
                            colorFilter: const ColorFilter.mode(
                              kLightColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            '${weatherModel!.temperature!.round()}°',
                            style: kTempTextStyle,
                          ),
                          Text(
                            weatherModel!.description!.toUpperCase(),
                            style: kLocationTextStyle,
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: kOverlayColor,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Details_widget(
                          title: 'FEELS LIKE',
                          value:
                              '${weatherModel != null ? weatherModel!.feelsLike!.round() : 0}°',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Details_widget(
                          title: 'HUMIDITY',
                          value:
                              '${weatherModel != null ? weatherModel!.humidity! : 0}%',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Details_widget(
                          title: 'WIND',
                          value:
                              '${weatherModel != null ? weatherModel!.wind!.round() : 0}',
                        )
                      ],
                    ),
                    height: 90,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
