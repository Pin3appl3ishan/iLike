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
import 'package:ilike/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:ilike/features/profile/presentation/bloc/onboarding/bloc/onboarding_bloc.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:ilike/core/network/token_interceptor.dart';
import 'package:ilike/features/matches/data/datasources/remote_datasource/match_remote_datasource.dart';
import 'package:ilike/features/matches/data/repositories/match_repository_impl.dart';
import 'package:ilike/features/matches/domain/repositories/match_repository.dart';
import 'package:ilike/features/matches/domain/usecases/get_potential_matches_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/like_user_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/dislike_user_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/get_matches_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/get_likes_usecase.dart';
import 'package:ilike/features/matches/presentation/bloc/match_bloc.dart';
import 'package:ilike/core/network/api_service.dart';
import 'package:ilike/features/matches/domain/usecases/get_likes_sent_usecase.dart';
import 'package:ilike/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ilike/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:ilike/features/chat/domain/repositories/chat_repository.dart';
import 'package:ilike/features/chat/domain/usecases/get_chats_usecase.dart';
import 'package:ilike/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:ilike/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:ilike/features/chat/domain/usecases/mark_messages_read_usecase.dart';
import 'package:ilike/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:ilike/core/services/sensor_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  await _initHiveService();

  await _initExternal();

  _initNetwork();

  _initDataSources();
  _initProfileDataSources();
  _initMatchDataSources();
  _initChatDataSources();

  _initRepositories();
  _initProfileRepositories();
  _initMatchRepositories();
  _initChatRepositories();

  _initUseCases();
  _initProfileUseCases();
  _initMatchUseCases();
  _initChatUseCases();

  _initBlocs();
  _initProfileBlocs();
  _initMatchBlocs();
  _initChatBlocs();

  _initServices();
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

  sl.registerLazySingleton<ApiService>(() => ApiService(sl()));
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
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );
}

// Match data sources
void _initMatchDataSources() {
  sl.registerLazySingleton<MatchRemoteDataSource>(
    () => MatchRemoteDataSourceImpl(dio: sl()),
  );
}

// Match repositories
void _initMatchRepositories() {
  sl.registerLazySingleton<MatchRepository>(
    () => MatchRepositoryImpl(remoteDataSource: sl()),
  );
}

// Match use cases
void _initMatchUseCases() {
  sl.registerLazySingleton<GetPotentialMatchesUseCase>(
    () => GetPotentialMatchesUseCase(sl()),
  );
  sl.registerLazySingleton<LikeUserUseCase>(() => LikeUserUseCase(sl()));
  sl.registerLazySingleton<DislikeUserUseCase>(() => DislikeUserUseCase(sl()));
  sl.registerLazySingleton<GetMatchesUseCase>(() => GetMatchesUseCase(sl()));
  sl.registerLazySingleton<GetLikesUseCase>(() => GetLikesUseCase(sl()));
  sl.registerLazySingleton<GetLikesSentUseCase>(
      () => GetLikesSentUseCase(sl()));
}

// Match blocs
void _initMatchBlocs() {
  sl.registerLazySingleton<MatchBloc>(
    () => MatchBloc(
      getPotentialMatches: sl(),
      likeUser: sl(),
      dislikeUser: sl(),
      getMatches: sl(),
      getLikes: sl(),
      getLikesSent: sl(),
    ),
  );
}

// Chat data sources
void _initChatDataSources() {
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );
}

// Chat repositories
void _initChatRepositories() {
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl()),
  );
}

// Chat use cases
void _initChatUseCases() {
  sl.registerLazySingleton<GetChatsUseCase>(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton<GetMessagesUseCase>(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton<MarkMessagesReadUseCase>(
      () => MarkMessagesReadUseCase(sl()));
}

// Chat blocs
void _initChatBlocs() {
  sl.registerLazySingleton<ChatBloc>(
    () => ChatBloc(
      getChats: sl(),
      getMessages: sl(),
      sendMessage: sl(),
      markMessagesRead: sl(),
      authBloc: sl<AuthBloc>(),
    ),
  );
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
  sl.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(getProfile: sl(), updateProfile: sl()),
  );
}

// Remove the duplicate init() function - it's causing conflicts

// Services
void _initServices() {
  sl.registerLazySingleton<SensorService>(() => SensorService());
}
