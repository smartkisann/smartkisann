import 'package:flutter/material.dart';

class SensorsWidget extends StatelessWidget {
  const SensorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.red[100],  // Red background for Sensors section
        child: const Text(
          'Sensors Section',
          style: TextStyle(
            fontSize: 24,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
