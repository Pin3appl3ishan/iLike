import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/core/utils/snackbar_utils.dart';
import 'package:ilike/core/utils/widget_utils.dart';
import 'package:ilike/features/auth/presentation/bloc/auth/auth.dart';

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

  final List<Widget> _screens = [
    const PlaceholderScreen(title: 'Discover Matches'),
    const PlaceholderScreen(title: 'Chat'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'iLike',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showConfirmationDialog(
                context,
                title: 'Logout',
                content: 'Are you sure you want to logout?',
              );
              
              if (shouldLogout == true && context.mounted) {
                if (!context.mounted) return;
                context.read<AuthBloc>().add(LogoutEvent());
              }
            },
          ),
        ],
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
        selectedItemColor: Colors.pinkAccent,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat), 
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
