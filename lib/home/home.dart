import 'package:flutter/material.dart';
import '../login_screen/login_screen.dart';
import '../signup_screen/signup_screen.dart';  

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController(initialPage: 0);
  
  // For demonstration, you'll need to set the verificationId
  final String verificationId = "your_verification_id_here"; // Set this dynamically as per your app logic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return LoginScreen(controller: controller);
            case 1:
              return SignUpScreen(controller: controller);
            default:
              return const Center(child: Text("Invalid page"));
          }
        },
      ),
    );
  }
}
