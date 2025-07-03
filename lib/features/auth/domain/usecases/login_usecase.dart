import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';
import 'package:ilike/core/usecase/usecase.dart';

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
class LoginUseCase implements UsecaseWithParams<UserEntity, LoginParams> {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    final Map<String, String> errors = {};

    // Validate email and password
    if (params.email.isEmpty) {
      errors['email'] = 'Email is required';
    }

    // Simple email validation
    if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+').hasMatch(params.email)) {
      errors['email'] = 'Please enter a valid email address';
    }

    if (params.password.isEmpty) {
      errors['password'] = 'Password is required';
    }

    // Password length check
    if (params.password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    if (errors.isNotEmpty) {
      return Left(ValidationFailure('Validation failed', errors));
    }

    return await repository.login(params.email, params.password);
  }
}
