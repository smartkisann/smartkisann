import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_success_screen.dart'; // Import the OTPSuccessScreen widget

class OTPForm extends StatefulWidget {
  final String verificationId;
  final Function(String) callBack;

  const OTPForm({super.key, required this.verificationId, required this.callBack});

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _digitControllers = List.generate(6, (_) => TextEditingController());
  late AnimationController _wiggleController;
  late Animation<double> _wiggleAnimation;
  bool _isWiggling = false;
  bool _isLoading = false; // New variable to track loading state

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _wiggleAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _wiggleController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _digitControllers) {
      controller.dispose();
    }
    _wiggleController.dispose();
    super.dispose();
  }

  void _animateIncorrectOTP() {
    setState(() {
      _isWiggling = true;
      for (var controller in _digitControllers) {
        controller.clear();
      }
    });

    _wiggleController.forward().then((_) {
      _wiggleController.reverse().then((_) {
        setState(() {
          _isWiggling = false; // Reset the wiggle state
        });
      });
    });
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true; // Set loading to true when verification starts
    });

    final otp = _digitControllers.map((controller) => controller.text).join();

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // If verification is successful, navigate to the success screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OTPSuccessScreen()),
      );
    } catch (e) {
      _animateIncorrectOTP();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect OTP. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state after verification attempt
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the cover image at the top
            Image.asset(
              'assets/images/vector-4.png', // Ensure this path matches your project structure
              width: double.infinity, // Make the image stretch across the width
              fit: BoxFit.cover, // Maintain aspect ratio
            ),
            const SizedBox(height: 16), // Space between image and text
            const Text(
              "Enter the 6-digit OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Centered asterisk icon
            const Icon(
              Icons.star,
              color: Colors.green, // Use your secondary color here
              size: 40,
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return AnimatedBuilder(
                  animation: _wiggleAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_isWiggling ? _wiggleAnimation.value : 0.0, 0.0), // Wiggle effect
                      child: SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _digitControllers[index],
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                elevation: 5,
              ),
              onPressed: _isLoading ? null : _verifyOTP, // Disable button if loading
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      "Verify OTP",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
            const SizedBox(height: 15),
            // Removed resend OTP button
          ],
        ),
      ),
    );
  }
}
