import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../../core/utils/widget_utils.dart';
import 'sensor_demo_screen.dart';
import 'test_demo_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Account settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Notifications settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Privacy settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to About page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sensors),
            title: const Text('Sensor Demo'),
            subtitle: const Text('Location & Accelerometer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SensorDemoScreen(),
                ),
              );
            },
          ),
          const Divider(),
          // Logout button at the bottom
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              final shouldLogout = await showConfirmationDialog(
                context,
                title: 'Logout',
                content: 'Are you sure you want to logout?',
              );

              if (shouldLogout == true && context.mounted) {
                context.read<AuthBloc>().add(LogoutEvent());
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
