// Custom exceptions for the application

/// Base class for all application exceptions
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when there's an error with the server
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred'])
    : super(statusCode: 500);
}

/// Thrown when the user is not authorized
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized'])
    : super(statusCode: 401);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;
  
  const ValidationException([super.message = 'Validation error occurred', this.errors]) 
    : super(statusCode: 400);
}

/// Thrown when the requested resource is not found
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found'])
    : super(statusCode: 404);
}

/// Thrown when there's a bad request (400) from the server
class BadRequestException extends AppException {
  const BadRequestException([super.message = 'Bad request'])
    : super(statusCode: 400);
}

/// Thrown when there's a network connectivity issue
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection'])
    : super(statusCode: 0);
}
