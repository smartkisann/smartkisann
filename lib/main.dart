import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboarding/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure you import this if you're using options
import '../home/home.dart'; // Import home.dart
import '../data/fetch_db.dart'; // Import FetchDB

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InitialScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late Future<bool> _shouldShowOnboarding;

  @override
  void initState() {
    super.initState();
    _shouldShowOnboarding = _checkIfShouldShowOnboarding();
  }

  // Check if the user should see the onboarding screen
  Future<bool> _checkIfShouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true; // Check if it's the first time

    if (!isFirstTime) {
      final email = await FetchDB.fetchdb("email");  // Fetch the email from FetchDB
      if (email != null && email.isNotEmpty) {
        return false; // If email exists, skip onboarding and go directly to home
      }
    }
    return true; // Show onboarding if it's the first time or email doesn't exist
  }

  void _setFirstTimeCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _shouldShowOnboarding,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading app'));
        } else {
          if (snapshot.data == true) {
            // Set first time completed if onboarding is shown
            _setFirstTimeCompleted();
            return const ConcentricAnimationOnboarding(); // Show onboarding screen
          } else {
            return const HomePage(); // Show home page if email is found
          }
        }
      },
    );
  }
}
