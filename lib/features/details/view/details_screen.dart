import 'package:flutter/material.dart';

import '../../../core/models/breed.dart';
import '../../home/view/widgets/build_text_link.dart';

/// A screen that displays the details of a specific cat breed.
///
/// This screen shows information such as the breed's name, image, description,
/// origin, intelligence, temperament, and a link to its Wikipedia page.
class DetailsScreen extends StatelessWidget {
  /// The [Breed] object containing the details to display.
  final Breed breed;

  /// Creates a [DetailsScreen].
  ///
  /// The [breed] parameter is required and contains the data for the breed
  /// to be displayed.
  const DetailsScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Displays the name of the breed in the app bar.
        title: Text(breed.name),
        centerTitle: true,
        // Provides a back button to navigate to the previous screen.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Displays the static image of the breed.
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child:
                    breed.imageUrl != null
                        ? Image.network(
                          breed.imageUrl!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          // Shows a broken image icon if the image fails to load.
                          errorBuilder:
                              (context, error, stackTrace) => const SizedBox(
                                height: 300,
                                child: Center(
                                  child: Icon(Icons.broken_image, size: 60),
                                ),
                              ),
                        )
                        // Shows a default pet icon if no image URL is available.
                        : const SizedBox(
                          height: 300,
                          child: Center(child: Icon(Icons.pets, size: 60)),
                        ),
              ),
            ),
          ),
          //add the scroll to text content only
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section for the breed's description.
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      breed.description,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 20),
                    Text(
                      breed.description,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),

                    // Displays various details about the breed.
                    _buildDetailRow('Origen:', breed.origin),
                    _buildDetailRow('Inteligencia:', '${breed.intelligence}/5'),
                    _buildDetailRow('Temperamento:', breed.temperament),
                    // Displays the Wikipedia link and makes it tappable.
                    if (breed.wikipediaUrl != null &&
                        breed.wikipediaUrl!.isNotEmpty)
                      BuildTextLink(
                        label: 'WikiPedia Link:',
                        url: breed.wikipediaUrl.toString(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A helper widget to build a row for displaying a label and its value.
  Widget _buildDetailRow(String label, String? value) {
    // If the value is null or empty, don't display the row.
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
