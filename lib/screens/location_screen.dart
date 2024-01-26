import 'package:flutter/material.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:weather_app/services/weather.dart';
import 'city_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather});
  final dynamic locationWeather;

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  String? temperatureString;
  String? city;
  String? shortForecast;
  String? detailedForecast;
  String? weatherType;
  String? weatherIcon;
  String? weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    if (weatherData.forecastURL != null) {
      setState(() {
        temperature = weatherData.temperature;
        temperatureString = temperature.toString();
        city = weatherData.city;
        shortForecast = weatherData.shortForecast;
        detailedForecast = weatherData.detailedForecast;
        weatherType = extractWeatherFromIconURL(weatherData.icon);
        weatherIcon = weatherModel.getWeatherIcon(weatherType!);
        weatherMessage = weatherModel.getMessage(temperature!);
      });
    } else {
      setState(() {
        temperatureString = "?";
        weatherIcon = "👾";
        weatherMessage = "Unknown weather";
        city = "an unknown location";
        shortForecast = "Sorry, can't get your weather right now!";
        detailedForecast = "Sorry, can't get your weather right now!";
      });
    }
  }

  String extractWeatherFromIconURL(String iconURL) {
    String lastPart = iconURL.split('/').last;
    return lastPart.split(',')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weatherModel.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      if (typedCityName != null) {
                        String encodedInput = Uri.encodeFull(typedCityName);
                        var googleMapsApiKey =
                            dotenv.env['GOOGLE_MAPS_API_KEY'];
                        String geocodeUrl =
                            'https://maps.googleapis.com/maps/api/geocode/json?'
                            'address=$encodedInput&key=$googleMapsApiKey';
                        var weatherData = await weatherModel.getLocationWeather(
                            url: geocodeUrl);
                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperatureString° F',
                      style: kTempTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  // "$weatherMessage in $city",
                  "$detailedForecast",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
