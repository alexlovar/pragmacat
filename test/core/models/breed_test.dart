import 'dart:convert'; // For jsonEncode and jsonDecode

import 'package:flutter_test/flutter_test.dart';
import 'package:pragmacat/core/models/breed.dart';

void main() {
  group('Breed Model Tests', () {
    // --- Test data for a single Breed ---
    const tBreedId = 'abys';
    const tBreedName = 'Abyssinian';
    const tBreedOrigin = 'Egypt';
    const tBreedDescription =
        'The Abyssinian is easy to care for, and a joy to have in your home.';
    const tBreedIntelligence = 5;
    const tBreedTemperament =
        'Active, Energetic, Independent, Intelligent, Gentle';
    const tBreedWikipediaUrl = 'https://en.wikipedia.org/wiki/Abyssinian_(cat)';
    const tBreedImageUrl = 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg';

    final tBreedModel = Breed(
      id: tBreedId,
      name: tBreedName,
      origin: tBreedOrigin,
      description: tBreedDescription,
      intelligence: tBreedIntelligence,
      temperament: tBreedTemperament,
      wikipediaUrl: tBreedWikipediaUrl,
      imageUrl: tBreedImageUrl,
    );

    final tBreedJsonMap = {
      "id": tBreedId,
      "name": tBreedName,
      "origin": tBreedOrigin,
      "description": tBreedDescription,
      "intelligence": tBreedIntelligence,
      "temperament": tBreedTemperament,
      "wikipedia_url": tBreedWikipediaUrl,
      "image": {"url": tBreedImageUrl},
    };

    // --- Tests for Breed.fromJson() ---
    group('fromJson', () {
      test('should return a valid Breed model when the JSON is complete', () {
        // arrange
        final Map<String, dynamic> jsonMap = tBreedJsonMap;
        // act
        final result = Breed.fromJson(jsonMap);
        // assert
        expect(result, isA<Breed>());
        expect(result.id, tBreedId);
        expect(result.name, tBreedName);
        expect(result.origin, tBreedOrigin);
        expect(result.description, tBreedDescription);
        expect(result.intelligence, tBreedIntelligence);
        expect(result.temperament, tBreedTemperament);
        expect(result.wikipediaUrl, tBreedWikipediaUrl);
        expect(result.imageUrl, tBreedImageUrl);
      });

      test(
        'should return a Breed model with default values for missing optional fields',
        () {
          // arrange
          final Map<String, dynamic> jsonMapWithMissingOptionals = {
            "id": tBreedId,
            "name": tBreedName,
            "origin": tBreedOrigin,
            "description": tBreedDescription,
            "intelligence": tBreedIntelligence,
            "temperament": tBreedTemperament,
            // wikipedia_url is missing
            // image is missing
          };
          // act
          final result = Breed.fromJson(jsonMapWithMissingOptionals);
          // assert
          expect(result, isA<Breed>());
          expect(result.id, tBreedId);
          expect(result.name, tBreedName);
          expect(result.wikipediaUrl, isNull);
          expect(result.imageUrl, isNull);
        },
      );

      test(
        'should return a Breed model with default values for missing required fields',
        () {
          // arrange
          final Map<String, dynamic> jsonMapWithMissingRequired = {
            "id": tBreedId,
            // name is missing
            "origin": tBreedOrigin,
            // description is missing
            "intelligence": tBreedIntelligence,
            // temperament is missing
          };
          // act
          final result = Breed.fromJson(jsonMapWithMissingRequired);
          // assert
          expect(result, isA<Breed>());
          expect(result.id, tBreedId);
          expect(result.name, 'Unknown Breed'); // Default value
          expect(result.origin, tBreedOrigin);
          expect(
            result.description,
            'No description available.',
          ); // Default value
          expect(result.intelligence, tBreedIntelligence);
          expect(result.temperament, 'Not specified'); // Default value
        },
      );

      test('should handle null image field gracefully', () {
        // arrange
        final Map<String, dynamic> jsonMapWithNullImage = {
          "id": tBreedId,
          "name": tBreedName,
          "origin": tBreedOrigin,
          "description": tBreedDescription,
          "intelligence": tBreedIntelligence,
          "temperament": tBreedTemperament,
          "wikipedia_url": tBreedWikipediaUrl,
          "image": null, // Image field is present but null
        };
        // act
        final result = Breed.fromJson(jsonMapWithNullImage);
        // assert
        expect(result.imageUrl, isNull);
      });

      test('should handle image field with no url gracefully', () {
        // arrange
        final Map<String, dynamic> jsonMapWithImageNoUrl = {
          "id": tBreedId,
          "name": tBreedName,
          "origin": tBreedOrigin,
          "description": tBreedDescription,
          "intelligence": tBreedIntelligence,
          "temperament": tBreedTemperament,
          "wikipedia_url": tBreedWikipediaUrl,
          "image": {}, // Image field is present but 'url' is missing
        };
        // act
        final result = Breed.fromJson(jsonMapWithImageNoUrl);
        // assert
        expect(result.imageUrl, isNull);
      });
    });

    // --- Tests for Breed.toJson() ---
    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // act
        final result = tBreedModel.toJson();
        // assert
        expect(result, equals(tBreedJsonMap));
      });

      test(
        'should return a JSON map with null for optional fields if they are null in model',
        () {
          // arrange
          final breedWithNullOptionals = Breed(
            id: tBreedId,
            name: tBreedName,
            origin: tBreedOrigin,
            description: tBreedDescription,
            intelligence: tBreedIntelligence,
            temperament: tBreedTemperament,
            wikipediaUrl: null,
            // explicit null
            imageUrl: null, // explicit null
          );
          final expectedJsonMap = {
            "id": tBreedId,
            "name": tBreedName,
            "origin": tBreedOrigin,
            "description": tBreedDescription,
            "intelligence": tBreedIntelligence,
            "temperament": tBreedTemperament,
            "wikipedia_url": null,
            "image": {"url": null}, // toJson creates the nested image structure
          };
          // act
          final result = breedWithNullOptionals.toJson();
          // assert
          expect(result, equals(expectedJsonMap));
        },
      );
    });

    // --- Test data for a list of Breeds ---
    final tBreedModel2 = Breed(
      id: 'beng',
      name: 'Bengal',
      origin: 'United States',
      description:
          'Bengals are a lot of fun to live with, but they\'re definitely not the cat for everyone.',
      intelligence: 5,
      temperament: 'Alert, Agile, Energetic, Demanding, Intelligent',
      wikipediaUrl: 'https://en.wikipedia.org/wiki/Bengal_(cat)',
      imageUrl: 'https://cdn2.thecatapi.com/images/O3btzLlsO.png',
    );

    final List<Breed> tBreedList = [tBreedModel, tBreedModel2];

    final tBreedJsonMap2 = {
      "id": 'beng',
      "name": 'Bengal',
      "origin": 'United States',
      "description":
          'Bengals are a lot of fun to live with, but they\'re definitely not the cat for everyone.',
      "intelligence": 5,
      "temperament": 'Alert, Agile, Energetic, Demanding, Intelligent',
      "wikipedia_url": 'https://en.wikipedia.org/wiki/Bengal_(cat)',
      "image": {"url": 'https://cdn2.thecatapi.com/images/O3btzLlsO.png'},
    };

    final String tBreedListJsonString = jsonEncode([
      tBreedJsonMap,
      tBreedJsonMap2,
    ]);

    // --- Tests for breedFromJson() top-level function ---
    group('breedFromJson (top-level)', () {
      test(
        'should return a list of Breed models when the JSON string is a valid list',
        () {
          // arrange
          // act
          final result = breedFromJson(tBreedListJsonString);
          // assert
          expect(result, isA<List<Breed>>());
          expect(result.length, 2);
          expect(result[0].id, tBreedModel.id);
          expect(result[1].name, tBreedModel2.name);
        },
      );

      test(
        'should return an empty list when the JSON string is an empty list',
        () {
          // arrange
          const String emptyListJson = '[]';
          // act
          final result = breedFromJson(emptyListJson);
          // assert
          expect(result, isA<List<Breed>>());
          expect(result, isEmpty);
        },
      );

      test('should throw a FormatException for invalid JSON string', () {
        // arrange
        const String invalidJson =
            '[{"id": "test", name: "missing quotes"}]'; // Malformed JSON
        // act & assert
        expect(
          () => breedFromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    // --- Tests for breedToJson() top-level function ---
    group('breedToJson (top-level)', () {
      test(
        'should return a JSON string representing the list of Breed models',
        () {
          // arrange
          // act
          final result = breedToJson(tBreedList);
          // assert
          // We decode the result and the expected string to compare the underlying maps/lists
          // as string comparison can be fragile due to key order or whitespace.
          expect(jsonDecode(result), equals(jsonDecode(tBreedListJsonString)));
        },
      );

      test(
        'should return an empty JSON list string for an empty list of Breeds',
        () {
          // arrange
          final List<Breed> emptyBreedList = [];
          // act
          final result = breedToJson(emptyBreedList);
          // assert
          expect(result, equals('[]'));
        },
      );
    });
  });
}
