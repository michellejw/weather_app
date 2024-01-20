import 'NetworkHelper.dart';

// WeatherService class for handling weather-specific functionalities.
class WeatherService {
  WeatherService({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  static const String baseEndpoint = 'https://api.weather.gov/points/';
  NetworkHelper networkHelper = NetworkHelper();

  Future<String?> getForecastUrl() async {
    String endpointURL = '$baseEndpoint$latitude,$longitude';
    var endpointData = await networkHelper.getData(endpointURL);
    if (endpointData != null) {
      try {
        ForecastData endpointDecodedData = ForecastData.fromJson(endpointData);
        return endpointDecodedData.forecast;
      } catch (e) {
        print('Error parsing endpoint data: $e');
      }
    }
    return null;
  }

  Future<int?> getTemperature() async {
    String? forecastURL = await getForecastUrl();
    if (forecastURL != null) {
      var forecastData = await networkHelper.getData(forecastURL);
      if (forecastData != null) {
        try {
          WeatherData forecastDecodedData =
              WeatherData.fromFirstPeriodJson(forecastData);
          return forecastDecodedData.temperature;
        } catch (e) {
          print('Error parsing forecast data: $e');
        }
      }
    }
    return null;
  }
}

class ForecastData {
  final String? forecast;

  ForecastData._({this.forecast});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData._(
      forecast: json['properties']['forecast'],
    );
  }
}

class WeatherData {
  final int? temperature;

  WeatherData._({this.temperature});

  factory WeatherData.fromFirstPeriodJson(Map<String, dynamic> json) {
    var firstPeriod = json['properties']['periods'][0];
    return WeatherData._(
      temperature: firstPeriod['temperature'],
    );
  }
}
