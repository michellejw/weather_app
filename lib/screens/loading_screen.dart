import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/weather_services.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  Future getLocationData() async {
    Location currentLocation = Location();
    await currentLocation.getCurrentLocation();

    longitude = currentLocation.longitude;
    latitude = currentLocation.latitude;

    var weatherService = await WeatherService.create(latitude!, longitude!);
    print(weatherService.temperature);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
