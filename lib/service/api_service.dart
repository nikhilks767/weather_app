// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class ApiService extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _error = "";
  String get error => _error;
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather?q=";
  final String unit = "&units=metric";
  final String apiKey = "9fd904fe142dc0a2ef59366f2a2e9991";

  Future<void> fetchData(String city) async {
    _isLoading = true;

    try {
      final apiUrl = "$baseUrl$city&appid=$apiKey$unit";
      final response = await http.get(Uri.parse(apiUrl));
      print(apiUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        _weather = WeatherModel.fromJson(data);
        notifyListeners();
      } else {
        _error = "Failed to load data";
      }
    } catch (e) {
      _error = "Fetching data failed : $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
