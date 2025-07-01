import 'package:bloc/bloc.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.isLoggedInUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold((failure) {
      if (failure is ValidationFailure) {
        emit(
          AuthError(
            message: _mapFailureToMessage(failure),
            fieldErrors: failure.errors,
          ),
        );
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      }
    }, (user) => emit(Authenticated(user: user)));
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold((failure) {
      if (failure is ValidationFailure) {
        emit(
          AuthError(
            message: _mapFailureToMessage(failure),
            fieldErrors: failure.errors,
          ),
        );
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      }
    }, (user) => emit(Authenticated(user: user)));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final isLoggedInResult = await isLoggedInUseCase();

    await isLoggedInResult.fold(
      (failure) {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
      (isLoggedIn) async {
        if (isLoggedIn) {
          final userResult = await getCurrentUserUseCase();
          userResult.fold(
            (failure) => emit(AuthInitial()),
            (user) => emit(Authenticated(user: user)),
          );
        } else {
          emit(AuthInitial());
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return 'Server error. Please try again later.';
      case CacheFailure _:
        return 'Cache error. Please try again.';
      case UnauthorizedFailure _:
        return 'Invalid email or password.';
      case ValidationFailure _:
        return failure.message;
      default:
        return 'An unexpected error occurred';
    }
  }
}
