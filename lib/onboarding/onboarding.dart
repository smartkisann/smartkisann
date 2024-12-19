import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import '../home/home.dart';

final pages = [
  const PageData(
    icon: Icons.eco_outlined,
    title: "Grow your favourite plants with AI",
    bgColor: Color.fromARGB(255, 0, 191, 79),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.sensors,
    title: "Monitor and manage using Sensors",
    bgColor: Color.fromARGB(255, 255, 174, 76),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.groups_outlined,
    title: "Connect with community",
    bgColor: Color.fromARGB(255, 46, 164, 255),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.agriculture_outlined,
    title: "Get instant farming Services",
    bgColor: Color.fromARGB(255, 71, 209, 103),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.attach_money_outlined,
    title: "Track your finance",
    bgColor: Color.fromARGB(255, 255, 8, 107),
    textColor: Colors.white,
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        scaleFactor: 2,
        itemCount: pages.length, // Set itemCount to prevent looping
        onFinish: () {
          // Navigate to Home Page after finishing onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: page.textColor,
          ),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
            color: page.textColor,
            fontSize: screenHeight * 0.035,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
