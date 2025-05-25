// Importing Flutter's material design library
import 'package:flutter/material.dart';
// Importing Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importing the SplashScreen widget from the features directory
import 'features/splash/splash_screen.dart';

/// The main function is the entry point of the Flutter application.
/// It wraps the entire app with a ProviderScope, which is necessary for Riverpod
/// to manage and provide access to the application's state throughout the widget tree.
void main() {
  runApp(
    // ProviderScope is a widget that stores the state of all the providers.
    // It must wrap the entire application to ensure that providers are accessible
    // from anywhere within the app.
    const ProviderScope(child: MyApp()),
  );
}

/// MyApp is the root widget of the application.
/// It extends StatelessWidget because it does not manage any state directly.
/// The widget builds a MaterialApp, which sets up the app's theme and home screen.
class MyApp extends StatelessWidget {
  // Constructor for MyApp. The 'key' parameter is optional and can be used
  // to control how widgets are replaced in the widget tree.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The title of the application, used by the OS to identify the app.
      title: 'Catbreeds App',

      // The theme of the application, defining the default colors and styles.
      theme: ThemeData(
        // Sets the primary color swatch for the application.
        // This color is used throughout the app for widgets like AppBar, FloatingActionButton, etc.
        primarySwatch: Colors.blueGrey,

        // Sets the visual density for the application.
        // VisualDensity.adaptivePlatformDensity adjusts the visual density based on the platform.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Hides the debug banner that appears in the top-right corner of the app during development.
      debugShowCheckedModeBanner: false,

      // Sets the home screen of the application to the SplashScreen widget.
      home: const SplashScreen(),
    );
  }
}
