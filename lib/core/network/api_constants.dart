class ApiConstants {
  ApiConstants._(); // private constructor

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:5000";

  // Base URL for the API
  static const String baseUrl =
      "$serverAddress/api"; // no version segment, no trailing slash
  static const String imageUrl = "$baseUrl/uploads"; // not in use yet

  // Authentication endpoints
  static const String login = '/users/login';
  static const String register = '/users/register';
  static const String logout = '/users/logout';
  static const String refreshToken = '/users/refresh';
  static const String currentUser = '/users/me';

  // Profile endpoints
  static const String getProfile = '/users/profile/me';
  static const String setupProfile = '/users/profile/setup';
  static const String updateProfile = '/users/profile/update';
  static const String uploadPhoto = '/users/profile/upload-photo';

  // Match endpoints
  static const String getPotentialMatches = '/matches/potential';
  static const String likeUser = '/matches/like';
  static const String dislikeUser = '/matches/like';
  static const String getMatches = '/matches';
  static const String getLikes = '/matches/likes';

  // Helper methods
  static String likeUserEndpoint(String userId) => '$likeUser/$userId';
  static String dislikeUserEndpoint(String userId) => '$dislikeUser/$userId';
  // Add other API endpoints here as needed

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorization = 'Authorization';
}
