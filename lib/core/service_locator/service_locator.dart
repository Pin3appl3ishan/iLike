import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ilike/core/network/api_constants.dart';
import 'package:ilike/core/network/hive_service.dart';
import 'package:ilike/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ilike/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ilike/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ilike/features/auth/data/repositories/local_repository/auth_local_repository.dart';
import 'package:ilike/features/auth/data/repositories/remote_repository/auth_remote_repository.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';
import 'package:ilike/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/register_usecase.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ilike/features/profile/data/datasources/local_datasource/profile_local_datasource.dart';
import 'package:ilike/features/profile/data/datasources/remote_datasource/profile_remote_datasource.dart';
import 'package:ilike/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ilike/features/profile/domain/repositories/profile_repository.dart';
import 'package:ilike/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ilike/features/profile/domain/usecases/save_profile_usecase.dart';
import 'package:ilike/features/profile/presentation/bloc/onboarding/bloc/onboarding_bloc.dart';
import 'package:ilike/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ilike/core/network/token_interceptor.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  await _initHiveService();

  await _initExternal();

  _initNetwork();

  _initDataSources();

  _initProfileDataSources();

  _initRepositories();
  _initProfileRepositories();

  _initUseCases();
  _initProfileUseCases();

  _initBlocs();
  _initProfileBlocs();
}

Future<void> _initHiveService() async {
  // Initialize Hive and its boxes before anything tries to access local cache.
  await HiveService.init();
  sl.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initExternal() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
}

// Network
void _initNetwork() {
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );

    dio.interceptors.add(TokenInterceptor());

    return dio;
  });
}

// Repositories
void _initRepositories() {
  sl.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteRepository: sl<AuthRemoteRepository>(),
      localRepository: sl<AuthLocalRepository>(),
    ),
  );
}

void _initProfileRepositories() {
  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
}

// Data Sources
void _initDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
}

// Profile data sources
void _initProfileDataSources() {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

// Use Cases
void _initUseCases() {
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );

  sl.registerLazySingleton<IsLoggedInUseCase>(() => IsLoggedInUseCase(sl()));

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));

  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
}

// Profile use cases
void _initProfileUseCases() {
  sl.registerLazySingleton<SaveProfile>(() => SaveProfile(sl()));
  sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));
}

// Bloc
void _initBlocs() {
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      isLoggedInUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
}

// Profile blocs
void _initProfileBlocs() {
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc(saveProfile: sl()));
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(getProfile: sl(), updateProfile: sl()),
  );
}

// Future<void> _initAuthModule() async {
//   // ===================== Data Source ====================
//   sl.registerFactory(
//     () => AuthLocalDataSource(hiveService: sl<HiveService>()),
//   );

//   sl.registerFactory(
//     () => AuthRemoteDataSource(apiService: sl<ApiService>()),
//   );

//   // ===================== Repository ====================

//   sl.registerFactory(
//     () => AuthLocalRepository(
//       studentLocalDatasource: sl<StudentLocalDatasource>(),
//     ),
//   );

//   sl.registerFactory(
//     () => StudentRemoteRepository(
//       studentRemoteDataSource: serviceLocator<StudentRemoteDataSource>(),
//     ),
//   );

//   // ===================== Usecases ====================

//   sl.registerFactory(
//     () => StudentLoginUsecase(
//       studentRepository: sl<StudentRemoteRepository>(),
//     ),
//   );

//   sl.registerFactory(
//     () => StudentRegisterUsecase(
//       studentRepository: sl<StudentRemoteRepository>(),
//     ),
//   );

//   sl.registerFactory(
//     () => UploadImageUsecase(
//       studentRepository: sl<StudentRemoteRepository>(),
//     ),
//   );

//   sl.registerFactory(
//     () => StudentGetCurrentUsecase(
//       studentRepository: sl<StudentRemoteRepository>(),
//     ),
//   );

//   // ===================== ViewModels ====================

//   sl.registerFactory(
//     () => RegisterViewModel(
//       sl<BatchViewModel>(),
//       sl<CourseViewModel>(),
//       sl<StudentRegisterUsecase>(),
//       sl<UploadImageUsecase>(),
//     ),
//   );

//   // Register LoginViewModel WITHOUT HomeViewModel to avoid circular dependency
//   sl.registerFactory(
//     () => LoginViewModel(sl<StudentLoginUsecase>()),
//   );
// }
