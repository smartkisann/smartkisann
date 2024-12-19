import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Crop {
  final String id;
  final String name;
  final String icon; // Unicode emoji as icon
  final String daysTillHarvest;
  final String irrigationInterval;
  final String avgMoistureRequired;
  final String avgPhRequired;
  final String plantationDate; // This should ideally be a DateTime

  Crop({
    required this.id,
    required this.name,
    required this.icon,
    required this.daysTillHarvest,
    required this.irrigationInterval,
    required this.avgMoistureRequired,
    required this.avgPhRequired,
    this.plantationDate = '', // Default value empty string, consider using null if a date is not set
  });

  // Convert Crop to a Map to save in local storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'daysTillHarvest': daysTillHarvest,
      'irrigationInterval': irrigationInterval,
      'avgMoistureRequired': avgMoistureRequired,
      'avgPhRequired': avgPhRequired,
      'plantationDate': plantationDate,
    };
  }

  // Convert Map to Crop object
  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      daysTillHarvest: map['daysTillHarvest'],
      irrigationInterval: map['irrigationInterval'],
      avgMoistureRequired: map['avgMoistureRequired'],
      avgPhRequired: map['avgPhRequired'],
      plantationDate: map['plantationDate'] ?? '',
    );
  }
}

class CropDatabase {
  static const String storageKey = 'planted_crops';

  // Method to get all crops from local storage
  static Future<List<Crop>> getAllCrops() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cropsJson = prefs.getString(storageKey);

    if (cropsJson == null || cropsJson.isEmpty) {
      return []; // Return empty list if no crops found
    }

    final List<dynamic> cropsList = json.decode(cropsJson);
    return cropsList.map((crop) => Crop.fromMap(crop)).toList();
  }

  // Method to add a new crop to local storage
  static Future<void> addNewCrop(Crop crop) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Crop> existingCrops = await getAllCrops();

    existingCrops.add(crop); // Add new crop to the list

    final List<Map<String, dynamic>> cropsMap = existingCrops.map((crop) => crop.toMap()).toList();
    await prefs.setString(storageKey, json.encode(cropsMap));
  }

  // Method to delete a crop by ID from local storage
  static Future<void> deleteCrop(String cropId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Crop> existingCrops = await getAllCrops();

    existingCrops.removeWhere((crop) => crop.id == cropId); // Remove crop by ID

    final List<Map<String, dynamic>> cropsMap = existingCrops.map((crop) => crop.toMap()).toList();
    await prefs.setString(storageKey, json.encode(cropsMap));
  }
}
