/// A utility class that holds constant values used for API interaction.
/// This includes the base URL, endpoints, and the API key for authentication.
class ApiConstants {
  /// The base URL of The Cat API.
  /// All endpoints are relative to this URL.
  static const String baseUrl = 'https://api.thecatapi.com/v1';

  /// The endpoint used to fetch breed data.
  /// This is appended to [baseUrl] to create the full request URL.
  static const String breedsEndpoint = '/breeds';

  /// API Key for accessing The Cat API.
  ///
  /// WARNING:
  /// This key is included directly in the source code **only for testing purposes**.
  /// In a production environment, it is strongly recommended to store sensitive keys
  /// such as this one in a secure place, like a `.env` file or a secure secrets manager.
  /// Hardcoding secrets can expose them to version control or unauthorized users.
  static const String apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';
}
