import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/presentation/pages/login_screen.dart';
import 'package:ilike/features/home/presentation/pages/home_screen.dart';
import 'package:ilike/core/service_locator/service_locator.dart';
import 'package:ilike/features/profile/domain/repositories/profile_repository.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          _handlePostLoginNavigation(context, state.user);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  );
                } else if (state is AuthInitial || state is Unauthenticated) {
                  return const LoginScreen();
                } else if (state is Authenticated) {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  );
                } else {
                  return const LoginScreen();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

Future<void> _handlePostLoginNavigation(
  BuildContext context,
  UserEntity user,
) async {
  print('\n=== Profile Completion Check ===');
  print('User ID: ${user.id}');
  print('Email: ${user.email}');
  print('Has Completed Profile (User): ${user.hasCompletedProfile}');

  // If user hasn't completed profile setup, send to onboarding
  if (user.hasCompletedProfile == null || user.hasCompletedProfile == false) {
    print(
      '❌ User hasCompletedProfile is false/null - redirecting to onboarding',
    );
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/onboarding');
    return;
  }

  try {
    // User has completed profile, verify profile exists
    print('\nFetching profile data...');
    final repo = sl<IProfileRepository>();
    final result = await repo.getProfile();
    if (!context.mounted) return;

    await result.fold(
      (failure) async {
        print('❌ Failed to fetch profile: ${failure.message}');
        // Update user state to reflect incomplete profile
        if (context.mounted) {
          context.read<AuthBloc>().add(
            UpdateUserEvent(user.copyWith(hasCompletedProfile: false)),
          );
          await Future.delayed(const Duration(milliseconds: 100));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        }
      },
      (profile) async {
        if (profile == null) {
          print('❌ Profile not found on server - redirecting to onboarding');
          if (context.mounted) {
            context.read<AuthBloc>().add(
              UpdateUserEvent(user.copyWith(hasCompletedProfile: false)),
            );
            await Future.delayed(const Duration(milliseconds: 100));
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          }
          return;
        }

        print('\nProfile Data:');
        print('Profile ID: ${profile.id}');
        print('Name: ${profile.name}');
        print('Is Profile Complete: ${profile.isProfileComplete}');

        if (profile.isProfileComplete != true) {
          print(
            '❌ Profile exists but isProfileComplete is false - redirecting to onboarding',
          );
          if (context.mounted) {
            context.read<AuthBloc>().add(
              UpdateUserEvent(user.copyWith(hasCompletedProfile: false)),
            );
            await Future.delayed(const Duration(milliseconds: 100));
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          }
        } else {
          print('✅ Profile is complete - redirecting to home');
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      },
    );
  } catch (e) {
    print('❌ Error during profile check: $e');
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }
  print('==============================\n');
}
