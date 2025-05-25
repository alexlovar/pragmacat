// Importing dart:convert to enable JSON encoding and decoding
import 'dart:convert';

/// Parses a JSON string and returns a list of [Breed] objects.
/// [str] is the JSON string to be parsed.
List<Breed> breedFromJson(String str) =>
    List<Breed>.from(json.decode(str).map((x) => Breed.fromJson(x)));

/// Converts a list of [Breed] objects to a JSON string.
/// [data] is the list of Breed instances to be encoded.
String breedToJson(List<Breed> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Model class representing a Cat Breed.
/// Includes essential information obtained from the Cat API.
class Breed {
  final String id; // Unique identifier of the breed
  final String name; // Name of the breed
  final String origin; // Country of origin
  final String description; // Description of the breed
  final int intelligence; // Intelligence rating of the breed
  final String temperament; // Typical temperament of the breed
  final String? wikipediaUrl; // Link to the Wikipedia page for the breed
  final String? imageUrl; // Optional URL to an image of the breed

  /// Constructor for [Breed], requiring all fields except [imageUrl] and [wikipediaUrl].
  Breed({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.intelligence,
    required this.temperament,
    this.wikipediaUrl,
    this.imageUrl,
  });

  /// Factory constructor to create a [Breed] object from a JSON map.
  /// Provides default values if certain fields are missing from the JSON.
  factory Breed.fromJson(Map<String, dynamic> json) => Breed(
    id: json["id"] ?? 'N/A',
    name: json["name"] ?? 'Unknown Breed',
    origin: json["origin"] ?? 'Unknown Origin',
    description: json["description"] ?? 'No description available.',
    intelligence: json["intelligence"] ?? 0,
    temperament: json["temperament"] ?? 'Not specified',
    wikipediaUrl: json["wikipedia_url"],
    imageUrl: json["image"]?["url"],
  );

  /// Converts a [Breed] object into a JSON map.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "origin": origin,
    "description": description,
    "intelligence": intelligence,
    "temperament": temperament,
    "wikipedia_url": wikipediaUrl,
    "image": {"url": imageUrl},
  };
}
