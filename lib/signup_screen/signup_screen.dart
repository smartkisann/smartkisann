import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../otpform/otpform.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true; 
    });

    String phoneNumber = _phoneController.text.trim();
    String password = _passController.text.trim();
    String confirmPassword = _repassController.text.trim();
    String email = _emailController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      setState(() {
        _isLoading = false; 
      });
      return;
    }

    if (phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number must be 10 digits long")),
      );
      setState(() {
        _isLoading = false; 
      });
      return;
    }

    try {
      if (email.isNotEmpty) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          widget.controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "An error occurred")),
          );
          setState(() {
            _isLoading = false; 
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPForm(
                verificationId: verificationId,
                callBack: (otp) {
                  // Handle OTP verification here
                  print("Entered OTP: $otp");
                },
              ),
            ),
          );
          setState(() {
            _isLoading = false; 
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _isLoading = false; 
          });
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent! Please check your phone.")),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Image.asset(
              "assets/images/vector-2.png",
              width: 428,
              height: 457,
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 27,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field (optional)
                TextField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                    labelStyle: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: Color(0xFF4CAF50)),
                    ),
                  ),
                ),
                const SizedBox(height: 17),

                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: Color(0xFF4CAF50)),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 17),

                // Password Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 147,
                      height: 56,
                      child: TextField(
                        controller: _passController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF393939),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Create Password',
                          hintStyle: TextStyle(
                            color: Color(0xFF837E93),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Color(0xFF4CAF50)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 147,
                      height: 56,
                      child: TextField(
                        controller: _repassController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF393939),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            color: Color(0xFF837E93),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Color(0xFF4CAF50)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Create Account Button
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 50,
                    width: 360,
                    color: const Color(0xFF4CAF50),
                    child: TextButton(
                      onPressed: _isLoading ? null : _sendOTP,
                      child: _isLoading 
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
