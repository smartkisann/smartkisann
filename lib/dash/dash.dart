import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_bar.dart';
import '../widgets/plant_widget.dart'; // Import widget files
import '../widgets/finance_widget.dart'; // Import widget files
import '../widgets/sensors_widget.dart'; // Import widget files
import '../widgets/store_widget.dart'; // Import widget files
import '../data/fetch_db.dart'; // Import the fetch_db.dart file

class Dash extends StatefulWidget {
  const Dash({super.key});

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  int _selectedIndex = 0;
  String? _userEmail;
  bool _showLogoutDialog = false;  // To control showing the full screen logout dialog
  final bool _profileFocused = false;  // To track if the profile icon is focused or not
  bool _isMenuOpen = false;  // To track if the menu is open
  bool _isLogoutIconRedTick = false;  // Track if the logout icon is in red tick state

  final List<Widget> _bodyWidgets = [
    const PlantWidget(),
    const FinanceWidget(),
    const SensorsWidget(),
    const StoreWidget(),
  ];

  final List<Color> _iconColors = [
    Colors.green, // Plant
    Colors.yellow, // Finance
    Colors.red, // Sensors
    Colors.blue, // Store
  ];

  final List<Color> _backgroundColors = [
    Colors.green[700]!, // Plant background
    Colors.yellow[800]!, // Finance background
    Colors.red[700]!, // Sensors background
    Colors.blue[700]!, // Store background
  ];

  final List<String> _sectionTitles = [
    'Plants',
    'Finance ',
    'Sensors ',
    'Store ',
  ];

  @override
  void initState() {
    super.initState();

    // Fetch the current user and their email from SharedPreferences
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    String? email = await FetchDB.fetchdb("email");  // Fetch email from the database
    setState(() {
      _userEmail = email ?? 'No Email';  // Set the fetched email, or use default
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleLogoutDialog() {
    setState(() {
      _showLogoutDialog = !_showLogoutDialog;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _performLogout() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you really want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent, // Make the header transparent
          elevation: 0, // Remove shadow from AppBar
          title: Text(
            _sectionTitles[_selectedIndex], // Show the current section title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: _toggleMenu, // Toggle the sliding menu
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isMenuOpen
                      ? const Icon(Icons.close, color: Colors.black)
                      : _userEmail != null
                          ? Text(
                              _userEmail![0],  // Show the first letter of the email
                              style: const TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            )
                          : const Icon(Icons.person, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 20),  // Space after profile icon
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            color: _backgroundColors[_selectedIndex],
            child: _bodyWidgets[_selectedIndex],
          ),
        ),
        extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
        bottomNavigationBar: BottomBar(
          onTabSelected: _onTabSelected,
          selectedIndex: _selectedIndex,
          iconColors: _iconColors,  // Pass the dynamic icon colors
        ),
        // Show sliding icons for logout, settings, and profile
        floatingActionButton: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: kToolbarHeight + 240, // Place the icons just below the profile icon
              right: 8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isMenuOpen ? 1 : 0,  // Fade in/out when menu is open/closed
                child: GestureDetector(
                  onTap: _isLogoutIconRedTick
                      ? _performLogout // Logout action when red tick is clicked
                      : () {
                          setState(() {
                            _isLogoutIconRedTick = true; // Change icon to red tick
                          });
                        },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: _isLogoutIconRedTick
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.red,
                            size: 30,
                          )
                        : const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 30,
                          ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: kToolbarHeight + 180, // Adjust position further below the profile icon
              right: 8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isMenuOpen ? 1 : 0,
                child: GestureDetector(
                  onTap: () {
                    // Settings action
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: kToolbarHeight + 120, // Adjust position further down
              right: 8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isMenuOpen ? 1 : 0,
                child: GestureDetector(
                  onTap: () {
                    // Profile action
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
