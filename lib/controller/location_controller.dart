// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/service/location_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final LocationService _locationService = LocationService();
  Placemark? _currentLocationName;
  Placemark? get currentLocationName => _currentLocationName;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      _currentPosition = null;
      notifyListeners();
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      _currentPosition = null;
      notifyListeners();
      return;
    }

    // If permissions are granted, get the current position
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      print("Current position: $_currentPosition");
      _currentLocationName =
          await _locationService.getLocationName(_currentPosition);
      if (_currentLocationName == null) {
        print("No placemark found for the given coordinates.");
      } else {
        print(_currentLocationName);
      }
    } catch (e) {
      print("Error getting location: $e");
      _currentPosition = null;
    }
    notifyListeners();
  }
}
