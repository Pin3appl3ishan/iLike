import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/presentation/pages/login_screen.dart';
import 'package:ilike/features/home/presentation/pages/home_screen.dart';
import 'package:ilike/core/service_locator/service_locator.dart';
import 'package:ilike/features/profile/domain/repositories/profile_repository.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check if user is already authenticated
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthInitial) {
          return const LoginScreen();
        } else if (state is Authenticated) {
          // While we decide where to go, show a spinner.
          _handlePostLoginNavigation(context);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

void _handlePostLoginNavigation(BuildContext context) {
  // Delay execution until after build.
  Future.microtask(() async {
    final repo = sl<IProfileRepository>();
    final result = await repo.getProfile();
    if (!context.mounted) return;

    result.fold(
      (_) {
        // Failure – assume no profile yet.
        Navigator.pushReplacementNamed(context, '/onboarding');
      },
      (profile) {
        if (profile == null) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
    );
  });
}
