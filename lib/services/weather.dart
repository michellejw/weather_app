import 'NetworkHelper.dart';
import 'package:weather_app/services/location.dart';

const String baseEndpoint = 'https://api.weather.gov/points/';

class WeatherModel {
  Future<dynamic> getLocationWeather({String? url}) async {
    Location currentLocation = Location();
    if (url != null) {
      await currentLocation.getLocationFromPlaceName(url);
    } else {
      await currentLocation.getCurrentLocation();
    }
    var weatherService = await WeatherService.create(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );
    return weatherService;
  }

  String getWeatherImage(String condition) {
    if ((condition == 'tsra') |
        (condition == 'tsra_sct') |
        (condition == 'tsra_hi')) {
      return 'images/tstorm.png';
    } else if ((condition == 'rain_sleet') |
        (condition == 'rain') |
        (condition == 'rain_showers') |
        (condition == 'rain_showers_hi')) {
      return 'images/rain.png';
    } else if ((condition == 'sleet') |
        (condition == 'rain_sleet') |
        (condition == 'fzra') |
        (condition == 'rain_fzra')) {
      return 'images/sleet.png';
    } else if ((condition == 'snow') |
        (condition == 'rain_snow') |
        (condition == 'snow_sleet')) {
      return 'images/snow.png';
    } else if ((condition == 'blizzard')) {
      return 'images/blizzard.png';
    } else if ((condition == "dust") |
        (condition == "haze") |
        (condition == "smoke")) {
      return 'images/hazy.png';
    } else if (condition == "fog") {
      return 'images/fog.png';
    } else if ((condition == 'hot') | (condition == 'skc')) {
      return 'images/clearsky.png';
    } else if ((condition == 'ovc')) {
      return 'images/overcast.png';
    } else if ((condition == 'bkn') |
        (condition == 'few') |
        (condition == 'sct')) {
      return 'images/partlycloudy.png';
    } else if ((condition == 'tropical_storm') | (condition == 'hurricane')) {
      return 'images/tropicalstorm.png';
    } else if (condition == 'tornado') {
      return 'images/tornado.png';
    } else if ((condition == 'wind_skc') |
        (condition == 'wind_few') |
        (condition == 'wind_sct') |
        (condition == 'wind_bkn') |
        (condition == 'wind_bkn') |
        (condition == 'wind_ovc')) {
      return 'images/wind.png';
    } else if (condition == 'cold') {
      return 'images/cold.png';
    } else {
      return 'images/galaxy.png';
    }
  }

  String getMessage(int temp) {
    if (temp > 90) {
      return 'It\'s 🍦 time';
    } else if (temp > 75) {
      return 'Time for shorts and 👕';
    } else if (temp < 50) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

class WeatherService {
  WeatherService._({
    required this.latitude,
    required this.longitude,
  });

  // Weather station properties
  final double latitude;
  final double longitude;
  String? forecastURL;
  String? city;
  String? state;

  // Forecast properties
  String? name; // name of the time period, e.g., "This Afternoon"
  int? temperature;
  int? probabilityOfPrecipitation;
  int? relativeHumidity;
  String? windSpeed;
  String? windDirection;
  String? shortForecast;
  String? detailedForecast;
  String? icon;

  NetworkHelper networkHelper = NetworkHelper();

  static Future<WeatherService> create(
      double latitude, double longitude) async {
    var service = WeatherService._(latitude: latitude, longitude: longitude);
    await service._getWeatherProperties();
    return service;
  }

  Future<void> _getForecastProperties() async {
    String endpointURL = '$baseEndpoint$latitude,$longitude';
    var endpointData = await networkHelper.getData(endpointURL);
    if (endpointData != null) {
      try {
        ForecastData endpointDecodedData = ForecastData.fromJson(endpointData);
        forecastURL = endpointDecodedData.forecast;
        city = endpointDecodedData.city;
        state = endpointDecodedData.state;
      } catch (e) {
        print('Error parsing endpoint data: $e');
      }
    } else {
      forecastURL = null;
    }
  }

  Future<void> _getWeatherProperties() async {
    await _getForecastProperties();
    if (forecastURL != null) {
      var forecastData = await networkHelper.getData(forecastURL!);
      if (forecastData != null) {
        try {
          WeatherData forecastDecodedData =
              WeatherData.fromFirstPeriodJson(forecastData);
          name = forecastDecodedData.name;
          temperature = forecastDecodedData.temperature;
          probabilityOfPrecipitation =
              forecastDecodedData.probabilityOfPrecipitation;
          relativeHumidity = forecastDecodedData.relativeHumidity;
          windSpeed = forecastDecodedData.windSpeed;
          windDirection = forecastDecodedData.windDirection;
          shortForecast = forecastDecodedData.shortForecast;
          detailedForecast = forecastDecodedData.detailedForecast;
          icon = forecastDecodedData.icon;
        } catch (e) {
          print('Error parsing forecast data: $e');
        }
      }
    } else {
      // TODO: do something if we don't get the weather data
    }
  }
}

class ForecastData {
  final String? forecast;
  final String? city;
  final String? state;

  ForecastData._({
    this.forecast,
    this.city,
    this.state,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData._(
      forecast: json['properties']['forecast'],
      city: json['properties']['relativeLocation']['properties']['city'],
      state: json['properties']['relativeLocation']['properties']['state'],
    );
  }
}

class WeatherData {
  final String? name; // name of the time period, e.g., "This Afternoon"
  final int? temperature;
  final int? probabilityOfPrecipitation;
  final int? relativeHumidity;
  final String? windSpeed;
  final String? windDirection;
  final String? shortForecast;
  final String? detailedForecast;
  final String? icon;

  WeatherData._({
    this.name,
    this.temperature,
    this.probabilityOfPrecipitation,
    this.relativeHumidity,
    this.windSpeed,
    this.windDirection,
    this.shortForecast,
    this.detailedForecast,
    this.icon,
  });

  factory WeatherData.fromFirstPeriodJson(Map<String, dynamic> json) {
    var firstPeriod = json['properties']['periods'][0];
    return WeatherData._(
      name: firstPeriod['name'],
      temperature: firstPeriod['temperature'],
      probabilityOfPrecipitation: firstPeriod['probabilityOfPrecipitation']
          ['value'],
      relativeHumidity: firstPeriod['relativeHumidity']['value'],
      windSpeed: firstPeriod['windSpeed'],
      windDirection: firstPeriod['windDirection'],
      shortForecast: firstPeriod['shortForecast'],
      detailedForecast: firstPeriod['detailedForecast'],
      icon: firstPeriod['icon'],
    );
  }
}
