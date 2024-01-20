import 'NetworkHelper.dart';

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

  static const String baseEndpoint = 'https://api.weather.gov/points/';
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
    }
    return null;
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
        } catch (e) {
          print('Error parsing forecast data: $e');
        }
      }
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

  WeatherData._({
    this.name,
    this.temperature,
    this.probabilityOfPrecipitation,
    this.relativeHumidity,
    this.windSpeed,
    this.windDirection,
    this.shortForecast,
    this.detailedForecast,
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
    );
  }
}
