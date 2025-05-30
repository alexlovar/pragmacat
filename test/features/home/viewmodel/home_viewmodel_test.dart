import 'dart:async'; // Import for Completer

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Only if you were testing Riverpod integration, not needed for pure ViewModel test
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pragmacat/core/api/cat_api_service.dart'; // Adjust import
import 'package:pragmacat/core/models/breed.dart'; // Adjust import
import 'package:pragmacat/features/home/viewmodel/home_viewmodel.dart'; // Adjust import

// This will generate home_viewmodel_test.mocks.dart
@GenerateNiceMocks([MockSpec<CatApiService>()])
import 'home_viewmodel_test.mocks.dart';

// Helper function to create dummy Breed objects
Breed createDummyBreed({
  required String id,
  required String name,
  String origin = 'Unknown',
  String description = 'A cat breed.',
  int intelligence = 3,
  String temperament = 'Calm',
  String? wikipediaUrl,
  String? imageUrl,
}) {
  return Breed(
    id: id,
    name: name,
    origin: origin,
    description: description,
    intelligence: intelligence,
    temperament: temperament,
    wikipediaUrl: wikipediaUrl,
    imageUrl: imageUrl ?? 'http://example.com/image.jpg', // Default image
  );
}

void main() {
  late HomeViewModel homeViewModel;
  late MockCatApiService mockCatApiService;

  final breed1 = createDummyBreed(id: '1', name: 'Siamese');
  final breed2 = createDummyBreed(id: '2', name: 'Persian');
  final mockBreeds = [breed1, breed2];

  setUp(() {
    mockCatApiService = MockCatApiService();
  });

  group('HomeViewModel Tests', () {
    test(
      'initial state is loading and then transitions to data on successful fetch',
      () async {
        // Arrange
        when(mockCatApiService.getBreeds(limit: anyNamed('limit'))) // CORRECTED
        .thenAnswer((_) async => mockBreeds);

        // Act
        homeViewModel = HomeViewModel(mockCatApiService);
        final states = <AsyncValue<List<Breed>>>[];
        homeViewModel.addListener((state) {
          states.add(state);
        });

        await Future.delayed(Duration.zero);

        // Assert
        expect(states.length, greaterThanOrEqualTo(1));
        expect(states.first, const AsyncValue<List<Breed>>.loading());
        if (states.length > 1) {
          expect(states.last, AsyncValue<List<Breed>>.data(mockBreeds));
        } else {
          expect(homeViewModel.state, AsyncValue<List<Breed>>.data(mockBreeds));
        }
        expect(homeViewModel.state, AsyncValue.data(mockBreeds));
        verify(
          mockCatApiService.getBreeds(limit: anyNamed('limit')),
        ).called(1); // CORRECTED
      },
    );

    test('state transitions to error on failed fetch', () async {
      // Arrange
      final exception = Exception('Failed to load breeds');
      when(
        mockCatApiService.getBreeds(limit: anyNamed('limit')),
      ).thenThrow(exception);

      // Act
      homeViewModel = HomeViewModel(
        mockCatApiService,
      ); // Constructor calls fetchBreeds
      final states = <AsyncValue<List<Breed>>>[];
      final completer = Completer<void>(); // To wait for expected state changes

      homeViewModel.addListener((state) {
        states.add(state);
        // We expect loading, then error.
        // Once we see an error state, we can consider the sequence complete for this test.
        if (state is AsyncError) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      });

      // It's possible the constructor and fetchBreeds complete very quickly.
      // We expect at least one state (loading) and then the error state.
      // Wait for the error state to be emitted OR a timeout (good practice for async tests)
      await Future.any([
        completer.future,
        Future.delayed(const Duration(milliseconds: 200)), // Timeout
      ]);

      // Assert
      expect(
        states,
        isNotEmpty,
        reason: "Should have received at least one state change.",
      );

      // The first state emitted should be loading (from the start of fetchBreeds)
      expect(
        states.first,
        const AsyncValue<List<Breed>>.loading(),
        reason: "First emitted state should be loading.",
      );

      // The final state of the ViewModel should be error
      expect(
        homeViewModel.state,
        isA<AsyncError>(),
        reason: "ViewModel's final state should be AsyncError.",
      );
      expect(
        (homeViewModel.state as AsyncError).error,
        exception,
        reason: "ViewModel's error should match the thrown exception.",
      );

      // The states list should also reflect this
      expect(
        states.last,
        isA<AsyncError>(),
        reason: "Last emitted state in the list should be AsyncError.",
      );
      expect(
        (states.last as AsyncError).error,
        exception,
        reason: "The error in the last emitted state should match.",
      );

      // Ensure we have seen both loading and error if things happened as expected
      if (states.length >= 2) {
        expect(states[0], const AsyncValue<List<Breed>>.loading());
        expect(states[1], isA<AsyncError>());
        expect((states[1] as AsyncError).error, exception);
      } else if (states.length == 1 && states.first is AsyncError) {
        // This would be unusual if the loading state wasn't caught,
        // but means the final state is still error.
        print(
          "Warning: Only one state (AsyncError) was captured by the listener.",
        );
      }

      verify(mockCatApiService.getBreeds(limit: anyNamed('limit'))).called(1);
    });

    test('fetchBreeds method explicitly sets loading, then data', () async {
      // Arrange
      when(mockCatApiService.getBreeds(limit: anyNamed('limit'))) // CORRECTED
      .thenAnswer((_) async => []); // Initial fetch
      homeViewModel = HomeViewModel(mockCatApiService);
      await Future.delayed(Duration.zero);

      when(mockCatApiService.getBreeds(limit: anyNamed('limit'))) // CORRECTED
      .thenAnswer((_) async => mockBreeds); // For explicit call

      final states = <AsyncValue<List<Breed>>>[];
      homeViewModel.addListener((state) {
        states.add(state);
      });

      // Act
      await homeViewModel.fetchBreeds();

      // Assert
      // ... (assertions for state sequence)
      expect(states.length, 2);
      expect(states[0], const AsyncValue<List<Breed>>.loading());
      expect(states[1], AsyncValue<List<Breed>>.data(mockBreeds));
      expect(homeViewModel.state, AsyncValue.data(mockBreeds));
      verify(
        mockCatApiService.getBreeds(limit: anyNamed('limit')),
      ).called(2); // CORRECTED
    });

    test('fetchBreeds method explicitly sets loading, then error', () async {
      // Arrange
      when(mockCatApiService.getBreeds(limit: anyNamed('limit'))) // CORRECTED
      .thenAnswer((_) async => []); // Initial fetch
      homeViewModel = HomeViewModel(mockCatApiService);
      await Future.delayed(Duration.zero);

      final exception = Exception('Explicit fetch failed');
      when(mockCatApiService.getBreeds(limit: anyNamed('limit'))) // CORRECTED
      .thenThrow(exception); // For explicit call

      final states = <AsyncValue<List<Breed>>>[];
      homeViewModel.addListener((state) {
        states.add(state);
      });

      // Act
      await homeViewModel.fetchBreeds();

      // Assert
      // ... (assertions for state sequence)
      expect(states.length, 2);
      expect(states[0], const AsyncValue<List<Breed>>.loading());
      expect(states[1], isA<AsyncError<List<Breed>>>());
      expect((states[1] as AsyncError).error, exception);
      expect(homeViewModel.state, isA<AsyncError>());
      expect((homeViewModel.state as AsyncError).error, exception);
      verify(
        mockCatApiService.getBreeds(limit: anyNamed('limit')),
      ).called(2); // CORRECTED
    });
  });
}
