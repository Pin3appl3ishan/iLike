import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:ilike/features/auth/domain/usecases/register_usecase.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';
import 'package:ilike/core/error/failures.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockRepository);
  });

  test('should return ValidationFailure when passwords do not match', () async {
    final params = RegisterParams(
      name: 'Test',
      email: 'test@email.com',
      password: 'password123',
      confirmPassword: 'wrong',
    );
    final result = await usecase(params);
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should not succeed'),
    );
  });

  test(
    'should call repository.register and return UserEntity on success',
    () async {
      final params = RegisterParams(
        name: 'Test',
        email: 'test@email.com',
        password: 'password123',
        confirmPassword: 'password123',
      );
      final user = UserEntity(email: params.email);
      when(
        () =>
            mockRepository.register(params.name, params.email, params.password),
      ).thenAnswer((_) async => Right(user));
      final result = await usecase(params);
      expect(result.isRight(), true);
      result.fold((_) => fail('Should succeed'), (u) => expect(u, user));
      verify(
        () =>
            mockRepository.register(params.name, params.email, params.password),
      ).called(1);
    },
  );
}
