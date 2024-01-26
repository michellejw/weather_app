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
  String? state;
  String? shortForecast;
  String? detailedForecast;
  String? weatherType;
  String? weatherIcon;
  String? weatherMessage;
  String backgroundImage = 'images/galaxy.png';

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
        state = weatherData.state;
        shortForecast = weatherData.shortForecast;
        detailedForecast = weatherData.detailedForecast;
        weatherType = extractWeatherFromIconURL(weatherData.icon);
        backgroundImage = weatherModel.getWeatherImage(weatherType!);
        weatherMessage = weatherModel.getMessage(temperature!);
        print(weatherType);
      });
    } else {
      setState(() {
        temperatureString = "?";
        weatherIcon = "👾";
        weatherMessage = "Unknown weather";
        city = "?";
        state = "?";
        shortForecast = "Sorry, can't get your weather right now!";
        detailedForecast = "Sorry, can't get your weather right now!";
        backgroundImage = 'images/galaxy.png';
      });
    }
  }

  String extractWeatherFromIconURL(String iconURL) {
    String lastPart = iconURL.split('/').last;
    return lastPart.split(RegExp(r'[,?]'))[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.7), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                      color: kTopMenuIconColor,
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
                      color: kTopMenuIconColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Text(
                      "$city, $state",
                      style: kMessageTextStyle,
                    ),
                    Text(
                      '$temperatureString° F',
                      style: kTempTextStyle,
                    ),
                  ]),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 40.0),
                color: const Color(0x57050505),
                child: Text(
                  // "$weatherMessage in $city",
                  "$detailedForecast",
                  style: kMessageTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
