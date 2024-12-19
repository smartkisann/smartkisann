class CropGrowthPhases {
  // Crop phase descriptions for different crops
  static Map<int, List<Map<String, String>>> cropPhasesDescriptions = {
    1: [
      {
        'phase': 'Land Preparation',
        'description': 'Prepare the land by clearing weeds, plowing, and leveling the soil. Ensure proper irrigation channels and drainage systems are in place.'
      },
      {
        'phase': 'Seeding',
        'description': 'Plant rice seeds in flooded fields or prepare seed beds. Ensure proper spacing and depth for optimal growth.'
      },
      {
        'phase': 'Vegetative Growth',
        'description': 'Rice plants begin to grow and develop leaves. Apply fertilizers based on the soil requirements, ensure proper irrigation, and manage weeds.'
      },
      {
        'phase': 'Flowering',
        'description': 'Rice plants begin to flower. Monitor for pests and diseases, and ensure that irrigation levels are optimal for the flowering stage.'
      },
      {
        'phase': 'Maturation',
        'description': 'Rice grains begin to mature and ripen. Reduce irrigation and prepare for harvesting. Ensure that the fields are kept dry.'
      },
      {
        'phase': 'Harvesting',
        'description': 'Harvest rice when the grains are fully mature and dry. Cut the plants and thresh the grains. Ensure proper handling to avoid damage.'
      },
    ],
    2: [
      {
        'phase': 'Sowing',
        'description': 'Sow wheat seeds in well-prepared soil. Ensure the seeds are planted at an optimal depth and spaced adequately for healthy growth.'
      },
      {
        'phase': 'Vegetative Growth',
        'description': 'Wheat plants grow and develop leaves. Apply fertilizers to promote healthy growth, and control weeds to reduce competition for nutrients.'
      },
      {
        'phase': 'Flowering',
        'description': 'Wheat plants begin to flower. Continue monitoring for pests, diseases, and nutrient deficiencies. Ensure adequate water and nutrition.'
      },
      {
        'phase': 'Maturation',
        'description': 'The wheat grains start to mature. Allow the plants to dry out and prepare for harvesting. Avoid waterlogging and reduce irrigation.'
      },
      {
        'phase': 'Harvesting',
        'description': 'Harvest wheat when the grains are mature and the plants are dry. Ensure proper handling during harvesting and threshing to prevent grain loss.'
      },
    ],
    3: [
      {
        'phase': 'Planting',
        'description': 'Plant banana suckers or tissue-cultured plants in well-prepared soil. Ensure that the planting hole is large enough for the root system.'
      },
      {
        'phase': 'Vegetative Growth',
        'description': 'Banana plants grow rapidly during this phase. Provide adequate irrigation, nutrition, and support to the plants to encourage healthy growth.'
      },
      {
        'phase': 'Flowering',
        'description': 'Banana plants begin to flower and form clusters of bananas. Control pests and diseases that can affect the flowers and developing fruit.'
      },
      {
        'phase': 'Fruiting',
        'description': 'The bananas begin to form and mature. Ensure regular irrigation and proper nutrition to support fruit development. Thin the fruits if necessary to improve size and quality.'
      },
      {
        'phase': 'Harvesting',
        'description': 'Harvest bananas when the fruits reach their desired size and color. Cut the bunches carefully and allow them to ripen properly.'
      },
    ],
    4: [
      {
        'phase': 'Planting',
        'description': 'Plant coconut seedlings or germinated coconuts in well-drained soil. Ensure the spacing between plants is adequate to allow for proper growth.'
      },
      {
        'phase': 'Young Growth',
        'description': 'Coconut trees start growing and developing leaves. During this phase, ensure that the plants receive adequate water and nutrients for healthy growth.'
      },
      {
        'phase': 'Mature Growth',
        'description': 'Coconut trees reach maturity and begin producing coconuts. Maintain proper irrigation, and provide necessary nutrients to ensure healthy fruit production.'
      },
      {
        'phase': 'Harvesting',
        'description': 'Coconuts can be harvested when they are mature. Use appropriate tools to carefully remove the coconuts from the trees.'
      },
    ],
    5: [
      {
        'phase': 'Planting',
        'description': 'Plant tomato seeds or seedlings in well-drained, nutrient-rich soil. Ensure adequate spacing for plant growth and air circulation.'
      },
      {
        'phase': 'Germination',
        'description': 'Tomato seeds begin to sprout and develop roots. Keep the soil moist and provide adequate warmth for seedling growth.'
      },
      {
        'phase': 'Vegetative Growth',
        'description': 'Tomato plants grow and develop stems, leaves, and branches. Prune the plants if necessary and provide proper nutrients and irrigation.'
      },
      {
        'phase': 'Flowering',
        'description': 'Tomato plants begin to flower. Control pests and diseases, and ensure that the plants are properly pollinated.'
      },
      {
        'phase': 'Fruiting',
        'description': 'Tomatoes begin to form and ripen. Ensure adequate water, nutrition, and pest control to support fruit development.'
      },
      {
        'phase': 'Harvesting',
        'description': 'Harvest tomatoes when they are fully ripe and have reached their desired color. Handle them carefully to prevent damage during picking.'
      },
    ],
  };

  // Method to get phases and descriptions for a given crop ID
  static List<Map<String, String>> getCropPhasesDescriptions(int cropId) {
    if (cropPhasesDescriptions.containsKey(cropId)) {
      return cropPhasesDescriptions[cropId]!;
    } else {
      throw Exception('Crop ID $cropId does not exist.');
    }
  }

  // Method to print all phases with descriptions for a given crop
  static void printCropPhasesDescriptions(int cropId) {
    List<Map<String, String>> phases = getCropPhasesDescriptions(cropId);
    print('Phases for Crop ID $cropId:');
    for (int i = 0; i < phases.length; i++) {
      print('${i + 1}. ${phases[i]['phase']}');
      print('   Description: ${phases[i]['description']}');
    }
  }
}
