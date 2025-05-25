// Dart core library used for creating a delay.
import 'dart:async';

// Flutter material design package for building UI.
import 'package:flutter/material.dart';
// Google Fonts package to use custom fonts.
import 'package:google_fonts/google_fonts.dart';

// Importing the HomeScreen to navigate to after the splash screen.
import '../home/view/home_screen.dart';

/// SplashScreen is the initial screen of the app shown for a few seconds
/// before navigating to the HomeScreen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Set a timer to navigate to HomeScreen after 3 seconds.
    Timer(
      const Duration(seconds: 3), // Duration for splash screen.
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is centered vertically and horizontally.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Spacer to push content towards the center vertically.
            const Spacer(flex: 2),

            // App title using Google Fonts for a stylish look.
            Text(
              'Catbreeds',
              style: GoogleFonts.dancingScript(
                fontSize: 98,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            // Spacer between title and image.
            const Spacer(flex: 3),

            // Image asset displayed at the center.
            Image.asset('assets/images/cat.png', width: 150, height: 150),

            // Spacer at the bottom for better layout spacing.
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
