import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/core/service_locator/service_locator.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:ilike/features/auth/presentation/pages/register_screen.dart';
import 'package:ilike/features/auth/presentation/pages/login_screen.dart';
import 'package:ilike/features/home/presentation/pages/home_screen.dart';
import 'package:ilike/features/profile/presentation/pages/onboarding_page.dart';
import 'package:ilike/features/profile/presentation/bloc/onboarding/bloc/onboarding_bloc.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:ilike/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize dependency injection (which will handle Hive initialization)
    await initDependencies();

    runApp(const MyApp());
  } catch (e) {
    print('Error initializing app: $e');
    // Fallback to a simple error widget if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Failed to initialize app: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<ProfileBloc>(create: (context) => sl<ProfileBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'iLike App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, 
        initialRoute: '/',
        routes: {
          '/': (_) => const AuthWrapper(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/onboarding':
              (_) => BlocProvider<OnboardingBloc>(
                create: (_) => sl<OnboardingBloc>()..add(NextStep()),
                child: const OnboardingPage(),
              ),
          '/main': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
