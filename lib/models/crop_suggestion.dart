class CropSuggestion {
  // Crop dataset
  static final List<Map<String, dynamic>> crops = [
    {
      'id': 1,
      'name': 'Rice',
      'min_n': 40,
      'max_n': 80,
      'min_p': 30,
      'max_p': 70,
      'min_k': 20,
      'max_k': 60,
      'temp_min': 20,
      'temp_max': 35,
      'lat_range': [10, 30],
      'lon_range': [70, 90],
      'months': [6, 7, 8, 9]
    },
    {
      'id': 2,
      'name': 'Wheat',
      'min_n': 30,
      'max_n': 70,
      'min_p': 20,
      'max_p': 60,
      'min_k': 30,
      'max_k': 80,
      'temp_min': 10,
      'temp_max': 25,
      'lat_range': [20, 40],
      'lon_range': [70, 80],
      'months': [10, 11, 12, 1, 2, 3]
    },
    {
      'id': 3,
      'name': 'Banana',
      'min_n': 60,
      'max_n': 100,
      'min_p': 40,
      'max_p': 80,
      'min_k': 50,
      'max_k': 90,
      'temp_min': 22,
      'temp_max': 30,
      'lat_range': [0, 20],
      'lon_range': [70, 90],
      'months': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    },
    {
      'id': 4,
      'name': 'Coconut',
      'min_n': 30,
      'max_n': 60,
      'min_p': 20,
      'max_p': 50,
      'min_k': 40,
      'max_k': 80,
      'temp_min': 25,
      'temp_max': 30,
      'lat_range': [5, 15],
      'lon_range': [75, 85],
      'months': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    },
    {
      'id': 5,
      'name': 'Tomato',
      'min_n': 40,
      'max_n': 70,
      'min_p': 30,
      'max_p': 60,
      'min_k': 20,
      'max_k': 50,
      'temp_min': 18,
      'temp_max': 30,
      'lat_range': [20, 40],
      'lon_range': [70, 80],
      'months': [3, 4, 5, 6, 7, 8]
    },
  ];

  // AI Algorithm to suggest best crops
  static Future<List<int>> getSuggestedCrops(
      double temperature, double latitude, double longitude, Map<String, int> npk, int rainfall, double ph, int month) async {
    List<Map<String, dynamic>> rankedCrops = [];

    for (var crop in crops) {
      double predictionScore = 0;

      // Temperature match
      if (_predictTemperatureMatch(temperature, crop['temp_min'], crop['temp_max']) > 0) {
        predictionScore += 3;  // Higher weight for temperature match
      }

      // NPK match
      if (_predictNPKMatch(npk, crop) > 0) {
        predictionScore += 3;  // Higher weight for NPK match
      }

      // Geographical match
      if (_predictGeographicalMatch(latitude, longitude, crop) > 0) {
        predictionScore += 2;  // Lower weight for geographical match
      }

      // Month match
      if (_predictMonthMatch(month, crop['months']) > 0) {
        predictionScore += 2;  // Moderate weight for month match
      }

      // Rainfall match (adding a simple condition for rainfall match)
      if (rainfall >= 100 && rainfall <= 300) {
        predictionScore += 2;  // Moderate weight for rainfall
      }

      // pH match (adding a simple condition for pH match)
      if (ph >= 5.5 && ph <= 7.5) {
        predictionScore += 2;  // Moderate weight for pH
      }

      // Only include crops with a high enough score
      if (predictionScore >= 6) {  // Threshold score increased to 6
        rankedCrops.add({'id': crop['id'], 'score': predictionScore});
      }
    }

    // Sort crops by their score in descending order
    rankedCrops.sort((a, b) => b['score'].compareTo(a['score']));

    // Return sorted crop IDs
    return rankedCrops.map((crop) => crop['id'] as int).toList();
  }

  // Temperature match prediction (strict matching)
  static double _predictTemperatureMatch(double temperature, double tempMin, double tempMax) {
    if (temperature >= tempMin && temperature <= tempMax) {
      return 1.0;  // Full match
    }
    return 0.0;  // No match
  }

  // NPK match prediction (strict matching)
  static double _predictNPKMatch(Map<String, int> npk, Map<String, dynamic> crop) {
    double score = 0.0;
    if (npk['N']! >= crop['min_n'] && npk['N']! <= crop['max_n']) score += 1.0;
    if (npk['P']! >= crop['min_p'] && npk['P']! <= crop['max_p']) score += 1.0;
    if (npk['K']! >= crop['min_k'] && npk['K']! <= crop['max_k']) score += 1.0;
    return score;
  }

  // Geographical match prediction (strict matching)
  static double _predictGeographicalMatch(double latitude, double longitude, Map<String, dynamic> crop) {
    if (latitude >= crop['lat_range'][0] && latitude <= crop['lat_range'][1] &&
        longitude >= crop['lon_range'][0] && longitude <= crop['lon_range'][1]) {
      return 1.0;  // Full match
    }
    return 0.0;  // No match
  }

  // Month match prediction (strict matching)
  static double _predictMonthMatch(int month, List<int> cropMonths) {
    if (cropMonths.contains(month)) {
      return 1.0;  // Full match
    }
    return 0.0;  // No match
  }
}
