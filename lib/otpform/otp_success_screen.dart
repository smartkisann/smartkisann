import 'package:flutter/material.dart';
import '../dash/dash.dart'; // Import the Dash widget

class OTPSuccessScreen extends StatefulWidget {
  const OTPSuccessScreen({super.key});

  @override
  State<OTPSuccessScreen> createState() => _OTPSuccessScreenState();
}

class _OTPSuccessScreenState extends State<OTPSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    _iconAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Automatically navigate to Dash screen after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dash()), // Navigate to Dash
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _iconAnimation,
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _textAnimation,
              child: const Text(
                "OTP Verified",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _textAnimation,
              child: const Text(
                "Account Created",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
