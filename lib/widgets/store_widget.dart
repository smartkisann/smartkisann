import 'package:flutter/material.dart';

class StoreWidget extends StatelessWidget {
  const StoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue[100],  // Blue background for Store section
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Store Section',
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue,  // Text color matches the section color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
