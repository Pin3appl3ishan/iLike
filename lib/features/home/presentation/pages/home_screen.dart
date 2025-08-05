import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/core/utils/snackbar_utils.dart';
import 'package:ilike/core/utils/widget_utils.dart';
import 'package:ilike/features/auth/presentation/bloc/auth.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:ilike/features/profile/presentation/pages/profile_screen.dart';
import 'package:ilike/features/matches/presentation/pages/explore_screen.dart';
import 'package:ilike/features/matches/presentation/pages/matches_screen.dart';
import 'package:ilike/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:ilike/core/service_locator/service_locator.dart';
import 'package:ilike/features/profile/domain/repositories/profile_repository.dart';
import 'package:ilike/features/settings/settings_screen.dart';

// Placeholder widget - replace with actual implementations
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isCheckingProfile = false;

  final List<Widget> _screens = [
    const ExploreScreen(),
    const MatchesScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load profile data initially since profile tab might be selected
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        // First check if profile is complete
        await _verifyProfileCompletion();
        // Then load profile data for display
        if (mounted) {
          context.read<ProfileBloc>().add(LoadProfileEvent());
        }
      }
    });
  }

  Future<void> _verifyProfileCompletion() async {
    if (_isCheckingProfile) return;
    setState(() => _isCheckingProfile = true);

    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final user = authState.user;
      if (user.hasCompletedProfile != true) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/onboarding');
        return;
      }

      final repo = sl<IProfileRepository>();
      final result = await repo.getProfile();

      if (!mounted) return;
      await result.fold(
        (failure) async {
          print('❌ Failed to fetch profile in HomeScreen: ${failure.message}');
          if (mounted) {
            context.read<AuthBloc>().add(
                  UpdateUserEvent(user.copyWith(hasCompletedProfile: false)),
                );
            await Future.delayed(const Duration(milliseconds: 100));
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          }
        },
        (profile) async {
          if (profile == null || profile.isProfileComplete != true) {
            print('❌ Profile incomplete or missing in HomeScreen');
            if (mounted) {
              context.read<AuthBloc>().add(
                    UpdateUserEvent(user.copyWith(hasCompletedProfile: false)),
                  );
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/onboarding');
              }
            }
          }
        },
      );
    } catch (e) {
      print('❌ Error checking profile in HomeScreen: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingProfile = false);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Load profile data when navigating to profile tab
    if (index == 3) {
      context.read<ProfileBloc>().add(LoadProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Logo section
                  if (_selectedIndex == 0) ...[
                    // Explore page - logo on left
                    _getAppBarTitle(compact: false),
                    const Spacer(),
                    // Filter button on right
                    ..._getAppBarActions(),
                  ] else ...[
                    // Other pages - centered logo
                    const Spacer(),
                    _getAppBarTitle(compact: false),
                    const Spacer(),
                    // Actions on right
                    ..._getAppBarActions(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          } else if (state is AuthError) {
            if (context.mounted) {
              showErrorSnackBar(context, state.message);
            }
          }
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _getAppBarTitle({bool compact = false}) {
    // App logo with icon and text - Tinder style
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite,
          color: Theme.of(context).colorScheme.primary,
          size: 28, // Bigger icon like Tinder
        ),
        const SizedBox(width: 6),
        Text(
          'iLike',
          style: TextStyle(
            fontSize: 22, // Bigger text like Tinder
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  List<Widget> _getAppBarActions() {
    switch (_selectedIndex) {
      case 0: // Explore tab
        return [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter options coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ];
      case 3: // Profile tab
        return [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ];
      default: // Other tabs (Matches, Chat)
        return []; // No actions for now
    }
  }
}
