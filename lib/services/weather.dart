class WeatherModel {
  String getWeatherIcon(String condition) {
    if ((condition == 'tsra') |
        (condition == 'tsra_sct') |
        (condition == 'tsra_hi')) {
      return '🌩';
    } else if ((condition == 'rain_sleet') |
        (condition == 'sleet') |
        (condition == 'rain') |
        (condition == 'rain_showers') |
        (condition == 'rain_showers_hi')) {
      return '🌧';
    } else if ((condition == 'blizzard') |
        (condition == 'snow') |
        (condition == 'rain_snow') |
        (condition == 'rain_sleet') |
        (condition == 'snow_sleet') |
        (condition == 'fzra') |
        (condition == 'rain_fzra')) {
      return '❄️';
    } else if ((condition == "dust") |
        (condition == "haze") |
        (condition == "smoke") |
        (condition == "fog")) {
      return '🌫';
    } else if ((condition == 'hot') | (condition == 'skc')) {
      return '☀️';
    } else if ((condition == 'bkn') | (condition == 'ovc')) {
      return '☁️';
    } else if ((condition == 'few') | (condition == 'sct')) {
      return '🌤️';
    } else if ((condition == 'tornado') |
        (condition == 'tropical_storm') |
        (condition == 'hurricane')) {
      return '🌪️';
    } else if ((condition == 'wind_skc') |
        (condition == 'wind_few') |
        (condition == 'wind_sct') |
        (condition == 'wind_bkn') |
        (condition == 'wind_bkn') |
        (condition == 'wind_ovc')) {
      return '💨';
    } else if (condition == 'cold') {
      return '🥶';
    } else {
      return '🤷‍';
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
