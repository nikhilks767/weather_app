// ignore_for_file: avoid_print

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Placemark?> getLocationName(Position? position) async {
    if (position != null) {
      try {
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          return placemarks[0];
        }
      } catch (e) {
        print("Error fetching location name: $e");
      }
    }
    return null;
  }
}
