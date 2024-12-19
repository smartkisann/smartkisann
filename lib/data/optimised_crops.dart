import 'dart:async';
import '../data/crops.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/crop_suggestion.dart';

class OptimisedCrops {
  // Method to get current location
  static Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  // Fetch the weather data based on location
  static Future<int> fetchWeatherData() async {
    try {
      Position position = await _getCurrentLocation();

      String url = 'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true&temperature_unit=celsius';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        int temperature = data['current_weather']['temperature'].toInt();

        return temperature;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Simulate fetching NPK data (this could be replaced with actual data fetching logic)
  static Future<Map<String, int>> fetchNPKData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate delay

    return {
      'N': 50, // Nitrogen value
      'P': 30, // Phosphorus value
      'K': 20, // Potassium value
    };
  }

  // Fetch rainfall data based on location
  static Future<int> fetchRainfallData() async {
    try {
      Position position = await _getCurrentLocation();

      // Log the coordinates for debugging
      print('Requesting rainfall data for latitude: ${position.latitude}, longitude: ${position.longitude}');

      String url =
          'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&hourly=precipitation_sum&timezone=auto';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Get the precipitation sum (rainfall) from the API response
        var rainfall = data['hourly']['precipitation_sum'] != null
            ? data['hourly']['precipitation_sum'][0]
            : 0; // Take the rainfall for the first hour, or 0 if not available

        print('Fetched Rainfall: $rainfall mm');
        return rainfall?.toInt() ?? 0; // Return rainfall in mm
      } else {
        print('Failed to load rainfall data, status code: ${response.statusCode}');
        return 0; // Default to 0 if there is an error
      }
    } catch (e) {
      print('Error fetching rainfall data: $e');
      return 0; // Default to 0 in case of an exception
    }
  }

  // Simulate fetching pH data (this could be replaced with actual data fetching logic)
  static Future<double> fetchPHData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    return 6.5; // Sample pH value
  }

  // Method to compute optimized crops based on weather, location, NPK values, rainfall, and pH
  static Future<List<int>> computeData(int weather, Map<String, int> npk) async {
    List<int> optimizedCropIds = [];
    Position position = await _getCurrentLocation();

    DateTime now = DateTime.now();
    int month = now.month;
    print("Current Month: ${month}");

    // Fetch rainfall and pH data
    int rainfall = await fetchRainfallData();
    double ph = await fetchPHData();

    print("Rainfall: ${rainfall} mm");
    print("Soil pH: ${ph}");

    // Pass rainfall and pH data along with other parameters to getSuggestedCrops
    List<int> suggestedCrops = await CropSuggestion.getSuggestedCrops(
      weather.toDouble(),
      position.latitude,
      position.longitude,
      npk,
      rainfall,
      ph,
      month,
    );
    optimizedCropIds.addAll(suggestedCrops);

    return optimizedCropIds;
  }
}
