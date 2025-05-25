// Import Riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importing the HomeViewModel for business logic.
import '../../features/home/viewmodel/home_viewmodel.dart';
// Importing the CatApiService which handles API communication.
import '../api/cat_api_service.dart';
// Importing the Breed model.
import '../models/breed.dart';

/// Provider that exposes a singleton instance of [CatApiService].
/// This service is responsible for fetching data from The Cat API.
final catApiServiceProvider = Provider<CatApiService>((ref) => CatApiService());

/// StateNotifierProvider that exposes the [HomeViewModel] as a state notifier.
/// It manages the state of the list of breeds asynchronously.
///
/// - Uses [AsyncValue<List<Breed>>] to represent loading, success, or error states.
/// - Depends on [catApiServiceProvider] to fetch data from the API.
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<List<Breed>>>((ref) {
      final apiService = ref.watch(catApiServiceProvider);
      return HomeViewModel(apiService);
    });

/// StateProvider that holds the current search term entered by the user.
/// This value is used to filter the breed list in real time.
final searchProvider = StateProvider<String>((ref) => '');

/// Provider that returns a filtered list of breeds based on the search term.
///
/// - Watches the state of [homeViewModelProvider] (the list of breeds).
/// - Watches the value of [searchProvider] (search input).
/// - Filters the list of breeds by checking if the breed name contains the search term.
final filteredBreedsProvider = Provider<AsyncValue<List<Breed>>>((ref) {
  // Get the current list of breeds (could be loading, data, or error).
  final breedsAsyncValue = ref.watch(homeViewModelProvider);
  // Get the current search term in lowercase for case-insensitive matching.
  final searchTerm = ref.watch(searchProvider).toLowerCase();

  // Apply filtering based on the current state of breedsAsyncValue.
  return breedsAsyncValue.when(
    data: (breeds) {
      // If no search term is provided, return the full list.
      if (searchTerm.isEmpty) {
        return AsyncValue.data(breeds);
      } else {
        // Filter the list by checking if the breed name includes the search term.
        final filtered =
            breeds
                .where((breed) => breed.name.toLowerCase().contains(searchTerm))
                .toList();
        return AsyncValue.data(filtered);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
