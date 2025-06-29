class ApiConstants {
  ApiConstants._(); // private constructor

    // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:3000";

  // Base URL for the API
  static const String baseUrl = "$serverAddress/api/v1/";
  static const String imageUrl = "$baseUrl/uploads/"; // not in use yet

  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String currentUser = '/auth/me';
  
  // Add other API endpoints here as needed
  
  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorization = 'Authorization';
  
}
