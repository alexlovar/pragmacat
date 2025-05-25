import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/breed_providers.dart'; // Importing the Riverpod providers for breeds
import 'widgets/breed_card.dart'; // Importing the UI widget to display each breed

/// This is the main screen of the app that shows the list of cat breeds.
/// It uses Riverpod for state management and listens to filtered breed data.
/// we are using text in spanish for the app but we can use translation for multiple languages
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the filteredBreedsProvider for changes in breed list or search term
    final breedsAsyncValue = ref.watch(filteredBreedsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200], // Light gray background color
      appBar: AppBar(
        title: const Text('Catbreeds'), // Title of the app
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            60.0,
          ), // Height of the bottom area
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // Updates the search term state when text changes
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Buscar raza...', // Hint text  "Search breed..."
                prefixIcon: const Icon(
                  Icons.search,
                ), // Search icon at the start
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // No visible border
                ),
                filled: true,
                fillColor:
                    Colors.white, // White background for the search field
              ),
            ),
          ),
        ),
        backgroundColor: Colors.grey[200], // Matches the scaffold background
        elevation: 0, // No shadow under the AppBar
      ),
      // Displays the body based on the AsyncValue state
      body: breedsAsyncValue.when(
        // When data is successfully loaded
        data: (breeds) {
          if (breeds.isEmpty) {
            // Show message if no breeds match the filter
            return const Center(
              child: Text('No se encontraron razas.'),
            ); // "No breeds found."
          }
          // Build a scrollable list of breed cards
          return ListView.builder(
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              return BreedCard(
                breed: breeds[index],
              ); // Show a card for each breed
            },
          );
        },
        // While data is loading
        loading: () => const Center(child: CircularProgressIndicator()),
        // If an error occurs
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
