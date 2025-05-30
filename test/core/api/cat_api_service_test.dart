import 'dart:convert'; // For jsonEncode

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pragmacat/core/api/cat_api_service.dart'; // Adjust import path
import 'package:pragmacat/core/models/breed.dart'; // Adjust import path
import 'package:pragmacat/utils/constants.dart'; // Adjust import path

// This will generate a test/core/api/cat_api_service_test.mocks.dart file
// You need to run: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'cat_api_service_test.mocks.dart'; // Import the generated mocks

void main() {
  late CatApiService catApiService;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    catApiService = CatApiService(client: mockHttpClient);
  });

  // Helper function to create a dummy Breed JSON
  Map<String, dynamic> createBreedJson({
    String id = 'abys',
    String name = 'Abyssinian',
    String? imageUrl, // Allow null image URL
  }) {
    return {
      "id": id,
      "name": name,
      "origin": "Egypt",
      "description": "Friendly cat",
      "intelligence": 5,
      "temperament": "Active, Playful",
      "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
      "image": imageUrl != null ? {"url": imageUrl} : null,
    };
  }

  group('CatApiService', () {
    group('getBreeds', () {
      final tLimit = 10;
      final tExpectedUri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.breedsEndpoint}?limit=$tLimit',
      );
      final tHeaders = {'x-api-key': ApiConstants.apiKey};

      test(
        'should return a list of Breeds when the response code is 200 (success) '
        'and filters out breeds without images',
        () async {
          // arrange
          final breedListJson = [
            createBreedJson(id: 'abys', name: 'Abyssinian', imageUrl: 'url1'),
            createBreedJson(id: 'beng', name: 'Bengal', imageUrl: null),
            // No image
            createBreedJson(id: 'char', name: 'Chartreux', imageUrl: 'url2'),
            createBreedJson(id: 'dons', name: 'Donskoy', imageUrl: ''),
            // Empty image URL
          ];
          final successResponse = http.Response(jsonEncode(breedListJson), 200);

          when(
            mockHttpClient.get(tExpectedUri, headers: tHeaders),
          ).thenAnswer((_) async => successResponse);

          // act
          final result = await catApiService.getBreeds(limit: tLimit);

          // assert
          expect(result, isA<List<Breed>>());
          expect(
            result.length,
            2,
          ); // Only Abyssinian and Chartreux should remain
          expect(result[0].name, 'Abyssinian');
          expect(result[0].imageUrl, 'url1');
          expect(result[1].name, 'Chartreux');
          expect(result[1].imageUrl, 'url2');
          verify(mockHttpClient.get(tExpectedUri, headers: tHeaders)).called(1);
        },
      );

      test(
        'should return an empty list when the response code is 200 but all breeds lack images',
        () async {
          // arrange
          final breedListJson = [
            createBreedJson(id: 'beng', name: 'Bengal', imageUrl: null),
            createBreedJson(id: 'dons', name: 'Donskoy', imageUrl: ''),
          ];
          final successResponse = http.Response(jsonEncode(breedListJson), 200);

          when(
            mockHttpClient.get(tExpectedUri, headers: tHeaders),
          ).thenAnswer((_) async => successResponse);

          // act
          final result = await catApiService.getBreeds(limit: tLimit);

          // assert
          expect(result, isA<List<Breed>>());
          expect(result.isEmpty, true);
          verify(mockHttpClient.get(tExpectedUri, headers: tHeaders)).called(1);
        },
      );

      test(
        'should return an empty list when the response code is 200 but the list is empty',
        () async {
          // arrange
          final emptyListJson = [];
          final successResponse = http.Response(jsonEncode(emptyListJson), 200);

          when(
            mockHttpClient.get(tExpectedUri, headers: tHeaders),
          ).thenAnswer((_) async => successResponse);

          // act
          final result = await catApiService.getBreeds(limit: tLimit);

          // assert
          expect(result, isA<List<Breed>>());
          expect(result.isEmpty, true);
          verify(mockHttpClient.get(tExpectedUri, headers: tHeaders)).called(1);
        },
      );

      test(
        'should throw an Exception when the response code is not 200',
        () async {
          // arrange
          final errorResponse = http.Response('Something went wrong', 404);
          when(
            mockHttpClient.get(tExpectedUri, headers: tHeaders),
          ).thenAnswer((_) async => errorResponse);

          // act
          final call = catApiService.getBreeds(limit: tLimit);

          // assert
          expect(() => call, throwsA(isA<Exception>()));
          verify(mockHttpClient.get(tExpectedUri, headers: tHeaders)).called(1);
        },
      );

      test('should use default limit of 15 if no limit is provided', () async {
        // arrange
        final defaultLimitUri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.breedsEndpoint}?limit=15', // Default limit
        );
        final successResponse = http.Response(
          jsonEncode([createBreedJson(imageUrl: 'url1')]),
          200,
        );

        when(
          mockHttpClient.get(defaultLimitUri, headers: tHeaders),
        ) // Expect call with default limit
        .thenAnswer((_) async => successResponse);

        // act
        await catApiService.getBreeds(); // Call without limit parameter

        // assert
        verify(
          mockHttpClient.get(defaultLimitUri, headers: tHeaders),
        ).called(1);
      });
    });
  });
}
