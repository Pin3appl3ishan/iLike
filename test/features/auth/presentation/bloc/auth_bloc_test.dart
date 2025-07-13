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

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeRegisterParams extends Fake implements RegisterParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterParams());
  });

  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockIsLoggedInUseCase mockIsLoggedInUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late AuthBloc authBloc;

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

  final user = UserEntity(email: 'test@email.com');

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Authenticated] when LoginEvent succeeds',
    build: () {
      when(() => mockLoginUseCase(any())).thenAnswer((_) async => Right(user));
      return authBloc;
    },
    act:
        (bloc) => bloc.add(
          const LoginEvent(email: 'test@email.com', password: 'password123'),
        ),
    expect: () => [AuthLoading(), Authenticated(user: user)],
    verify: (_) {
      verify(() => mockLoginUseCase(any())).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError] when LoginEvent fails',
    build: () {
      when(
        () => mockLoginUseCase(any()),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));
      return authBloc;
    },
    act:
        (bloc) => bloc.add(
          const LoginEvent(email: 'fail@email.com', password: 'wrong'),
        ),
    expect: () => [AuthLoading(), isA<AuthError>()],
    verify: (_) {
      verify(() => mockLoginUseCase(any())).called(1);
    },
  );
}
