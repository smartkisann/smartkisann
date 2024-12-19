import 'package:flutter/material.dart';
import '../data/crops.dart'; // Crop model
import '../data/phases.dart'; // Crop phases data

class DetailedPlantsScreen extends StatefulWidget {
  final Crop selectedCrop;
  final VoidCallback onDelete; // Callback for deletion

  DetailedPlantsScreen({
    required this.selectedCrop,
    required this.onDelete,
  });

  @override
  _DetailedPlantsScreenState createState() => _DetailedPlantsScreenState();
}

class _DetailedPlantsScreenState extends State<DetailedPlantsScreen> {
  int _currentStep = 0; // Track the current step
  late List<Map<String, String>> _phases;

  @override
  void initState() {
    super.initState();
    // Fetch crop phases based on the selected crop's ID
    _phases = CropGrowthPhases.getCropPhasesDescriptions(
        int.parse(widget.selectedCrop.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCrop.name),
        backgroundColor: Colors.green[800], // Dark green for a clean look
        elevation: 5,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Crop'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Crop details in a Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.green[50], // Light green background for the card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Crop Icon or Emoji
                    widget.selectedCrop.icon.contains('assets/icons/')
                        ? Image.asset(
                            widget.selectedCrop.icon,
                            width: 120,
                            height: 120,
                          )
                        : Text(
                            widget.selectedCrop.icon, // If it's an emoji
                            style: TextStyle(fontSize: 100),
                          ),
                    const SizedBox(height: 16),
                    // Crop Name
                    Text(
                      widget.selectedCrop.name,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    const SizedBox(height: 8),
                    // Crop Description
                    Text(
                      "This crop has unique phases and growth stages that contribute to its successful harvest.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Crop Phases Stepper (Custom Stepper)
            Stepper(
              currentStep: _currentStep,
              onStepTapped: (int step) {
                setState(() {
                  _currentStep = step;
                });
              },
              onStepContinue: () {
                if (_currentStep < _phases.length - 1) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  // Completion reached, show a dialog with success message
                  _showCompletionDialog();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                }
              },
              steps: _buildSteps(),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800], // Dark green background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        _currentStep == _phases.length - 1 ? 'Complete' : 'Next',
                        style: TextStyle(color: Colors.white), // Text color white
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(color: Colors.green[800]), // Green color for Back button text
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each step in the stepper
  List<Step> _buildSteps() {
    List<Step> steps = [];
    for (int i = 0; i < _phases.length; i++) {
      steps.add(Step(
        title: Text(
          _phases[i]['phase']!, // Only show phase name
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold, // Make the heading bold
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white, // White background for green text
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _phases[i]['description']!, // Phase description
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= i,
        state: _currentStep > i ? StepState.complete : StepState.indexed,
      ));
    }
    return steps;
  }

  // Method to show the completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green[800],
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  'Congratulations! You have completed all phases.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // White color for Close button text
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to show delete confirmation dialog
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Crop', style: TextStyle(color: Colors.red)),
          content: Text('Are you sure you want to delete this crop?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.green[800])),
            ),
            TextButton(
              onPressed: () async {
                // Deleting the crop from the database
                await CropDatabase.deleteCrop(widget.selectedCrop.id);

                // Call the callback to notify the parent widget to refresh
                widget.onDelete();

                // Go back to the previous screen
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
