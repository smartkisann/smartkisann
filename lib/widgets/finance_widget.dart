import 'package:flutter/material.dart';

class FinanceWidget extends StatelessWidget {
  const FinanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.yellow[100],  // Yellow background for Finance section
        child: const Text(
          'Finance Section',
          style: TextStyle(
            fontSize: 24,
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
