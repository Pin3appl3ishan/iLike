import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
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
class RegisterUseCase implements UsecaseWithParams<UserEntity, RegisterParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    final Map<String, String> errors = {};

    // Validate name
    if (params.name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }

    // Validate email
    if (params.email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+').hasMatch(params.email)) {
      errors['email'] = 'Please enter a valid email address';
    }

    // Password validation
    if (params.password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (params.password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    // Password confirmation
    if (params.confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Confirm password is required';
    } else if (params.password != params.confirmPassword) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    if (errors.isNotEmpty) {
      return Left(ValidationFailure('Validation failed', errors));
    }

    return await repository.register(
      params.name.trim(),
      params.email.trim().toLowerCase(),
      params.password,
    );
  }
}
