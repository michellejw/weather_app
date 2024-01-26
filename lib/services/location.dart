import 'package:geolocator/geolocator.dart';
import 'NetworkHelper.dart';

class Location {
  double? latitude;
  double? longitude;
  NetworkHelper networkHelper = NetworkHelper();

  Future<void> getLocationFromPlaceName(String url) async {
    try {
      var response = await networkHelper.getData(url);
      final coordinates = response['results'][0]['geometry']['location'];
      latitude = coordinates['lat'];
      longitude = coordinates['lng'];
    } catch (e) {
      print(e);
    }
  }

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position.
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
