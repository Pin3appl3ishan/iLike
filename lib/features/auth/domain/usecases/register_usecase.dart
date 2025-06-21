import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

// Parameters for registration operation
class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, password, confirmPassword];
}

/// Use case for handling user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Executes the registration use case
  /// 
  /// Returns [UserEntity] if registration is successful
  /// Returns [Failure] if registration fails
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    // Validate name
    if (params.name.isEmpty) {
      return const Left(ValidationFailure('Name is required'));
    }

    // Validate email
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }

    // Email format validation
    if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+').hasMatch(params.email)) {
      return const Left(ValidationFailure('Please enter a valid email address'));
    }

    // Password validation
    if (params.password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }

    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    // Password confirmation
    if (params.password != params.confirmPassword) {
      return const Left(ValidationFailure('Passwords do not match'));
    }

    return await repository.register(
      params.name.trim(),
      params.email.trim().toLowerCase(),
      params.password,
    );
  }
}
