import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/features/profile/domain/entities/profile_entity.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_event.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _locationController;
  late TextEditingController _heightController;
  late TextEditingController _bioController;
  String _selectedGender = 'Other';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _locationController = TextEditingController(text: profile.location);
    _heightController = TextEditingController(text: profile.height);
    _bioController = TextEditingController(text: profile.bio);
    _selectedGender = profile.gender;
    _avatarUrl = profile.profilePicture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _heightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? widget.profile.age,
      gender: _selectedGender,
      location: _locationController.text.trim(),
      height: _heightController.text.trim(),
      bio: _bioController.text.trim(),
      profilePicture: _avatarUrl,
    );
    context.read<ProfileBloc>().add(UpdateProfileEvent(updatedProfile));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
            tooltip: 'Save',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        _avatarUrl != null && _avatarUrl!.isNotEmpty
                            ? NetworkImage(_avatarUrl!)
                            : null,
                    child:
                        _avatarUrl == null || _avatarUrl!.isEmpty
                            ? const Icon(
                              Icons.person,
                              size: 48,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // TODO: Implement avatar upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Avatar upload coming soon!'),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedGender = value);
              },
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
