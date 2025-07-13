import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:ilike/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';
import 'package:ilike/core/error/failures.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUseCase(mockRepository);
  });

  test('should return ValidationFailure when email is invalid', () async {
    final params = LoginParams(email: 'invalid', password: '123');
    final result = await usecase(params);
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should not succeed'),
    );
  });

  test(
    'should call repository.login and return UserEntity on success',
    () async {
      final params = LoginParams(
        email: 'test@email.com',
        password: 'password123',
      );
      final user = UserEntity(email: params.email);
      when(
        () => mockRepository.login(params.email, params.password),
      ).thenAnswer((_) async => Right(user));
      final result = await usecase(params);
      expect(result.isRight(), true);
      result.fold((_) => fail('Should succeed'), (u) => expect(u, user));
      verify(
        () => mockRepository.login(params.email, params.password),
      ).called(1);
    },
  );
}
