import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/fetch_db.dart'; // Import fetch_db.dart to use the setdb function
import '../dash/dash.dart'; // Import your Dash screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false; // Loading state variable
  String? _errorMessage; // Variable to hold error message

  // Check if the user is already signed in
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;

    // If the user is already signed in, navigate to the Dash screen
    if (user != null && user.email != null) {
      // Save the email using setdb function
      await FetchDB.setdb("email", user.email ?? ""); // Handle the nullable email

      // Navigate to the dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dash()), // Navigate to Dash screen
      );
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true; // Start loading
      _errorMessage = null; // Reset error message
    });

    try {
      // Sign in with Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      // After successful sign-in, fetch the user email
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? userEmail = user.email;

        // Save the email using setdb function
        if (userEmail != null && userEmail.isNotEmpty) {
          await FetchDB.setdb("email", userEmail); // Call the setdb method to save the email
        }
      }

      // Save in SharedPreferences that user has logged in (and bypass onboarding next time)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false);

      // Navigate to the dashboard if sign-in is successful
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dash()), // Navigate to the Dash screen
      );
    } on FirebaseAuthException catch (e) {
      // Handle different FirebaseAuthException cases
      setState(() {
        _isLoading = false; // Stop loading
        if (e.code == 'user-not-found') {
          _errorMessage = 'No account found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided.';
        } else {
          _errorMessage = 'An unknown error occurred.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
        _errorMessage = 'An unknown error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Image.asset(
                "assets/images/vector-1.png",
                width: 400,
                height: 400,
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF393939),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF66BB6A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _passController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: const TextStyle(
                      color: Color(0xFF393939),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF66BB6A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66BB6A),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 15),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
