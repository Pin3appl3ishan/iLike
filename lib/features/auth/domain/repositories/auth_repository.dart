import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Authenticate a user with email and password
  Future<Either<Failure, UserEntity>> login(String email, String password);
  
  // Register a new user
  Future<Either<Failure, UserEntity>> register(String name, String email, String password);
  
  // Logout the current user
  Future<Either<Failure, Unit>> logout();
  
  // Get the currently authenticated user
  Future<Either<Failure, UserEntity>> getCurrentUser();
  
  // Check if a user is currently logged in
  Future<Either<Failure, bool>> isLoggedIn();
}
