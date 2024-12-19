import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;
  final List<Color> iconColors; // List to pass icon colors

  const BottomBar({super.key, 
    required this.onTabSelected,
    required this.selectedIndex,
    required this.iconColors,
  });

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          onTap: widget.onTabSelected,
          type: BottomNavigationBarType.fixed, // To show the icons without text
          backgroundColor: widget.iconColors[widget.selectedIndex], // Dynamic background color
          selectedItemColor: Colors.white, // White color for selected icon
          unselectedItemColor: Colors.white70, // Slightly lighter for unselected icons
          iconSize: 40, // Larger icons for better visibility
          elevation: 10, // Adds shadow to the BottomNavigationBar
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.eco_outlined, // Icon for Plant section
                color: Colors.white, // White color for icons
              ),
              label: '', // No label text
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money_outlined, // Icon for Sensors section
                color: Colors.white, // White color for icons
              ),
              label: '', // No label text
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sensors, // Icon for Community section
                color: Colors.white, // White color for icons
              ),
              label: '', // No label text
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store, // Icon for Finance section
                color: Colors.white, // White color for icons
              ),
              label: '', // No label text
            ),
          ],
        ),
        // Animated line to show the selected tab
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: widget.selectedIndex * (MediaQuery.of(context).size.width / 4),
          bottom: 0, // Position the line at the bottom of the bar
          child: Container(
            height: 5, // Line height
            width: MediaQuery.of(context).size.width / 4, // Line width matches tab width
            color: Colors.white, // Color of the line
          ),
        ),
      ],
    );
  }
}
