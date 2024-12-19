import 'package:flutter/material.dart';
import '../data/crops.dart';

class AddPlantationDialog extends StatefulWidget {
  final List<int> cropIds; // Accept the list of crop IDs to filter
  final Function(Crop) onCropSelected;

  AddPlantationDialog({required this.cropIds, required this.onCropSelected});

  @override
  _AddPlantationDialogState createState() => _AddPlantationDialogState();
}

class _AddPlantationDialogState extends State<AddPlantationDialog> {
  List<Crop> crops = [];
  bool isLoading = false;
  String? currentGif;

  @override
  void initState() {
    super.initState();
    _filterCrops(); // Directly filter the crops based on cropIds
  }

  // Filter crops based on the crop IDs passed from PlantWidget
  void _filterCrops() {
    setState(() {
      isLoading = true;
      currentGif = 'assets/gifs/fetching_weather.gif'; // Show fetching gif (optional)
    });

    // Define all available crops (you can optimize this list elsewhere if needed)
    final allCrops = [
      Crop(id: '1', name: 'Rice', icon: 'assets/icons/rice.png', daysTillHarvest: '120', irrigationInterval: '7', avgMoistureRequired: '80%', avgPhRequired: '6.0'),
      Crop(id: '2', name: 'Wheat', icon: 'assets/icons/wheat.png', daysTillHarvest: '150', irrigationInterval: '10', avgMoistureRequired: '70%', avgPhRequired: '7.0'),
      Crop(id: '3', name: 'Banana', icon: 'assets/icons/banana.png', daysTillHarvest: '365', irrigationInterval: '14', avgMoistureRequired: '75%', avgPhRequired: '5.5'),
      Crop(id: '4', name: 'Coconut', icon: 'assets/icons/coconut.png', daysTillHarvest: '360', irrigationInterval: '21', avgMoistureRequired: '70%', avgPhRequired: '5.5'),
      Crop(id: '5', name: 'Tomato', icon: 'assets/icons/tomato.png', daysTillHarvest: '60', irrigationInterval: '7', avgMoistureRequired: '80%', avgPhRequired: '6.5'),
    ];

    // Filter crops based on the cropIds passed from PlantWidget
    final filteredCrops = allCrops.where((crop) {
      return widget.cropIds.contains(int.parse(crop.id)); // Compare the cropId with the passed IDs
    }).toList();

    setState(() {
      crops = filteredCrops;
      isLoading = false;
      currentGif = null; // Hide gif once crops are loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800], // Set overall background to dark green
      appBar: AppBar(
        title: Text('Select a Crop'),
        backgroundColor: Colors.green[700], // Darker green for app bar
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentGif != null)
                    Image.asset(currentGif!, width: 150, height: 150),
                  SizedBox(height: 16),
                  Text(
                    'Processing...',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return GestureDetector(
                  onTap: () {
                    widget.onCropSelected(crop); // Notify parent about crop selection
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Card(
                    color: Colors.white, // White card color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded corners
                    ),
                    elevation: 8, // Add a shadow to make the card stand out
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          crop.icon, // Path to the image file
                          width: 60, // Width of the image
                          height: 60, // Height of the image
                        ),
                        SizedBox(height: 8),
                        Text(
                          crop.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('Days to harvest: ${crop.daysTillHarvest}', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
