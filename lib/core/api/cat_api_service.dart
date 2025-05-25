// Importing the HTTP package to perform network requests.
import 'package:http/http.dart' as http;

// Importing constants (like base URL and API key).
import '../../utils/constants.dart';
// Importing the Breed model to parse the API response.
import '../models/breed.dart';

/// A service class responsible for communicating with The Cat API.
/// This class encapsulates the logic required to fetch data from the API.
class CatApiService {
  // HTTP client instance used to make requests.
  final http.Client client;

  /// Constructor for [CatApiService].
  /// Allows injecting a custom [http.Client] for testing or reuse.
  /// If none is provided, a new default client is created.
  CatApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches a list of cat breeds from The Cat API.
  ///
  /// [limit] specifies the maximum number of breeds to return (default is 15).
  /// Returns a list of [Breed] objects, filtered to include only those with images.
  Future<List<Breed>> getBreeds({int limit = 15}) async {
    // Construct the full API URL with query parameter for limit.
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.breedsEndpoint}?limit=$limit',
    );

    // Perform the GET request with the required API key in headers.
    final response = await client.get(
      uri,
      headers: {
        'x-api-key':
            ApiConstants.apiKey, // API key included in request headers.
      },
    );

    // Check if the response is successful.
    if (response.statusCode == 200) {
      // Parse the JSON response into a list of Breed objects.
      List<Breed> breeds = breedFromJson(response.body);

      // Filter out breeds that do not have an image URL.
      return breeds
          .where(
            (breed) => breed.imageUrl != null && breed.imageUrl!.isNotEmpty,
          )
          .toList();
    } else {
      // If the API call failed, throw an exception with status code info.
      throw Exception(
        'Failed to load cat breeds (status code: ${response.statusCode})',
      );
    }
  }
}
