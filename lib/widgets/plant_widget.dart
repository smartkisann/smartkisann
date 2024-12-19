import 'package:flutter/material.dart';
import '../data/crops.dart';
import '../popups/add_plantation_dialog.dart';
import '../data/optimised_crops.dart';
import '../views/detailed_plants.dart'; // Import the DetailedPlantsScreen

class PlantWidget extends StatefulWidget {
  const PlantWidget({super.key});

  @override
  _PlantWidgetState createState() => _PlantWidgetState();
}

class _PlantWidgetState extends State<PlantWidget> {
  List<Crop> plantedCrops = [];
  bool isProcessing = false;
  String? currentGif;
  String? currentPhaseText;

  @override
  void initState() {
    super.initState();
    _loadPlantedCrops();
  }

  Future<void> _loadPlantedCrops() async {
    final crops = await CropDatabase.getAllCrops();
    setState(() {
      plantedCrops = crops;
    });
  }

  Future<void> _handleAddCrop() async {
    setState(() {
      isProcessing = true;
      currentGif = 'assets/gifs/fetching_weather.gif';
      currentPhaseText = 'Fetching Weather Data';
    });

    // Step 1: Fetch Weather Data
    final weather = await OptimisedCrops.fetchWeatherData();

    setState(() {
      currentGif = 'assets/gifs/fetching_npk.gif';
      currentPhaseText = 'Fetching Soil Data';
    });

    // Step 2: Fetch NPK Data
    final npk = await OptimisedCrops.fetchNPKData();

    setState(() {
      currentGif = 'assets/gifs/computing.gif';
      currentPhaseText = 'Computing';
    });

    // Step 3: Compute Data
    final optimizedCropIds = await OptimisedCrops.computeData(weather, npk);

    setState(() {
      currentGif = 'assets/gifs/optimising.gif';
      currentPhaseText = 'Optimizing Suggestions';
    });

    setState(() {
      isProcessing = false;
    });

    // Show Add Plantation Dialog with Optimized Crops (IDs)
    showDialog(
      context: context,
      builder: (context) {
        return AddPlantationDialog(
          cropIds: optimizedCropIds,
          onCropSelected: (crop) {
            setState(() {
              plantedCrops.add(crop);
            });
            CropDatabase.addNewCrop(crop);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: plantedCrops.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _handleAddCrop,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: isProcessing && currentGif != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    currentGif!,
                                    width: 100, // Larger icon size
                                    height: 100,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    currentPhaseText ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Icon(Icons.add, size: 60, color: Colors.green),
                      ),
                    ),
                  );
                }

                final crop = plantedCrops[index - 1];

                return GestureDetector(
                  onTap: () {
                    // Navigate to DetailedPlantsScreen with the selected crop
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedPlantsScreen(
                          selectedCrop: crop,
                          onDelete: () {
                            setState(() {
                              plantedCrops.remove(crop);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Render crop icon, either as emoji or image
                        crop.icon.contains('assets/icons/')
                            ? Image.asset(
                                crop.icon, // Path to the image file
                                width: 60,
                                height: 60,
                              )
                            : Text(
                                crop.icon, // If it's an emoji
                                style: TextStyle(fontSize: 80),
                              ),
                        const SizedBox(height: 8),
                        Text(
                          crop.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}