import 'package:flutter/material.dart';

import '../../../../core/models/breed.dart'; // Importing the Breed model
import '../../../details/view/details_screen.dart'; // Importing the details screen to navigate to

/// StatelessWidget that displays a card with information about a cat breed.
class BreedCard extends StatelessWidget {
  final Breed breed; // Breed object to be displayed in this card

  const BreedCard({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0, // Shadow depth of the card
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias, // Ensures child content is clipped properly
      child: Stack(
        children: [
          // Main image or placeholder in the center
          Center(
            child:
                breed.imageUrl != null
                    ? Image.network(
                      breed.imageUrl!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        // Shows a loading spinner while the image is loading
                        return SizedBox(
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Shows an icon if image fails to load
                        return const SizedBox(
                          height: 250,
                          child: Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        );
                      },
                    )
                    : const SizedBox(
                      height: 250,
                      child: Center(
                        child: Icon(Icons.pets, size: 50), // Placeholder icon
                      ),
                    ),
          ),

          // Overlay gradient to darken edges for better text contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Name of the breed at the top left
          Positioned(top: 10, left: 10, child: _buildLabel(breed.name)),

          // Origin of the breed at the bottom left
          Positioned(bottom: 10, left: 10, child: _buildLabel(breed.origin)),

          // Intelligence rating at the bottom right
          Positioned(
            bottom: 10,
            right: 10,
            child: _buildLabel('Int: ${breed.intelligence}'),
          ),

          // "Más..." button at the top right, navigates to details screen
          Positioned(
            top: 5,
            right: 5,
            child: TextButton(
              onPressed: () {
                // Navigate to the details screen with the current breed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(breed: breed),
                  ),
                );
              },
              child: const Text(
                'Más...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Utility method to create a styled label used in the card
  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
