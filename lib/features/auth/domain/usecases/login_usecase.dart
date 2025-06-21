import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

// Parameters for login operation
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Use case for handling user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Executes the login use case
  /// 
  /// Returns [UserEntity] if login is successful
  /// Returns [Failure] if login fails
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    // Validate email and password
    if (params.email.isEmpty || params.password.isEmpty) {
      return Left(ValidationFailure('Email and password are required'));
    }

    // Simple email validation
    if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+').hasMatch(params.email)) {
      return Left(ValidationFailure('Please enter a valid email address'));
    }

    // Password length check
    if (params.password.length < 6) {
      return Left(ValidationFailure('Password must be at least 6 characters'));
    }

    return await repository.login(params.email, params.password);
  }
}
