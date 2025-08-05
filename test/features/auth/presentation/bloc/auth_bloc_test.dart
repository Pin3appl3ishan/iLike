import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/register_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/core/error/failures.dart';

// Mock classes for testing
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  group('AuthBloc Tests', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockIsLoggedInUseCase mockIsLoggedInUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockIsLoggedInUseCase = MockIsLoggedInUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        isLoggedInUseCase: mockIsLoggedInUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        final testUser = UserEntity(
          id: '1',
          email: 'test@example.com',
          username: 'testuser',
          hasCompletedProfile: true,
        );
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<Authenticated>(),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Login failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'wrongpassword',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when registration is successful',
      build: () {
        final testUser = UserEntity(
          id: '1',
          email: 'new@example.com',
          username: 'newuser',
          hasCompletedProfile: false,
        );
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterEvent(
        name: 'New User',
        email: 'new@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<Authenticated>(),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when registration fails',
      build: () {
        when(() => mockRegisterUseCase(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Registration failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterEvent(
        name: 'New User',
        email: 'new@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when logout is successful',
      build: () {
        when(() => mockLogoutUseCase())
            .thenAnswer((_) async => const Right(unit));
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase()).called(1);
      },
    );

    test('handles network failure gracefully', () {
      when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => const Left(NetworkFailure('No internet connection')));

      authBloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'password123',
      ));

      expect(authBloc.state, isA<AuthError>());
    });

    test('handles validation errors', () {
      final validationErrors = <String, String>{
        'email': 'Invalid email format',
        'password': 'Password too short',
      };
      when(() => mockLoginUseCase(any())).thenAnswer((_) async =>
          Left(ValidationFailure('Validation failed', validationErrors)));

      authBloc.add(const LoginEvent(
        email: 'invalid-email',
        password: '123',
      ));

      expect(authBloc.state, isA<AuthError>());
    });

    test('handles unauthorized access', () {
      when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => const Left(UnauthorizedFailure('Invalid credentials')));

      authBloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'wrongpassword',
      ));

      expect(authBloc.state, isA<AuthError>());
    });

    test('handles cache failures', () {
      when(() => mockLogoutUseCase()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to clear cache')));

      authBloc.add(LogoutEvent());

      expect(authBloc.state, isA<AuthError>());
    });
  });
}
