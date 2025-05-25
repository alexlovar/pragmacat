// Importing Riverpod's StateNotifier for managing state.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importing the API service that fetches cat breed data.
import '../../../core/api/cat_api_service.dart';
// Importing the model class for Breed.
import '../../../core/models/breed.dart';

/// ViewModel for the Home screen, following the MVVM pattern.
///
/// This class extends [StateNotifier] and manages the state of a list of [Breed]s
/// as an [AsyncValue] to handle loading, success, and error states.
class HomeViewModel extends StateNotifier<AsyncValue<List<Breed>>> {
  // Instance of the API service used to fetch data from the Cat API.
  final CatApiService _apiService;

  /// Constructor initializes the API service and sets the initial state to loading.
  /// Immediately triggers the fetching of breed data from the API.
  HomeViewModel(this._apiService) : super(const AsyncValue.loading()) {
    fetchBreeds(); // Fetch data as soon as the ViewModel is created.
  }

  /// Fetches the list of cat breeds from the API.
  ///
  /// Sets the state to loading, then tries to get the data.
  /// On success, updates the state with the fetched breed list.
  /// On failure, sets the state to an error with stack trace for debugging.
  Future<void> fetchBreeds() async {
    try {
      // Set state to loading to indicate the request is in progress.
      state = const AsyncValue.loading();

      // Fetch breeds using the API service.
      final breeds = await _apiService.getBreeds();

      // Set the state to data when the request is successful.
      state = AsyncValue.data(breeds);
    } catch (e, stack) {
      // Set the state to error if an exception occurs.
      state = AsyncValue.error(e, stack);
    }
  }
}
