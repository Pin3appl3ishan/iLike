import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:ilike/core/constants/api.dart';
import 'package:ilike/core/constants/hive_constants.dart';
import 'package:ilike/core/network/hive_service.dart';
import 'package:ilike/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ilike/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';
import 'package:ilike/features/auth/data/models/user_model.dart';
import 'package:ilike/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';
import 'package:ilike/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/register_usecase.dart';
import 'package:ilike/features/auth/presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await _initHive();
  
  // Services
  sl.registerLazySingleton<HiveService>(() => HiveService());
  
  // Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(hiveService: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      isLoggedInUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
}

Future<void> _initHive() async {
  try {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    
    // Open boxes
    if (!Hive.isBoxOpen(HiveConstants.userBox)) {
      await Hive.openBox<UserModel>(HiveConstants.userBox);
    }
    
    if (!Hive.isBoxOpen(HiveConstants.tokenBox)) {
      await Hive.openBox<String>(HiveConstants.tokenBox);
    }
  } catch (e) {
    print('Error initializing Hive: $e');
    rethrow;
  }
}
