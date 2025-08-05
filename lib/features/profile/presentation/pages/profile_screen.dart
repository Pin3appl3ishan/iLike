import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/core/utils/snackbar_utils.dart';
import 'package:ilike/features/profile/domain/entities/profile_entity.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:ilike/features/profile/presentation/widgets/profile_photo_grid.dart';
import 'package:ilike/features/profile/presentation/widgets/profile_section.dart';
import 'package:ilike/features/profile/presentation/pages/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          showErrorSnackBar(context, state.message);
        } else if (state is ProfileUpdated) {
          showSuccessSnackBar(context, 'Profile updated successfully');
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoaded) {
          final profile = state.profile;
          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfo(profile),
                  const SizedBox(height: 24),
                  ProfilePhotoGrid(
                    photos: profile.photoUrls,
                    onPhotosChanged: (photos) {
                      // Handle photo updates
                      context.read<ProfileBloc>().add(
                        UpdateProfileEvent(profile.copyWith(photoUrls: photos)),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ProfileSection(
                    title: 'About Me',
                    content: profile.bio,
                    icon: Icons.person_outline,
                    onEdit: () => _editField(context, 'bio', profile),
                  ),
                  const SizedBox(height: 16),
                  ProfileSection(
                    title: 'Basic Information',
                    content: _buildBasicInfoText(profile),
                    icon: Icons.info_outline,
                    onEdit: () => _editBasicInfo(context, profile),
                  ),
                  const SizedBox(height: 16),
                  ProfileSection(
                    title: 'Interests',
                    content: profile.interests.join(', '),
                    icon: Icons.favorite_border,
                    onEdit: () => _editInterests(context, profile),
                  ),
                  const SizedBox(height: 16),
                  ProfileSection(
                    title: 'Looking For',
                    content: profile.intentions.join(', '),
                    icon: Icons.search,
                    onEdit: () => _editIntentions(context, profile),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: Text('Something went wrong. Please try again.'),
        );
      },
    );
  }

  Widget _buildBasicInfo(ProfileEntity profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Picture and Name/Age Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture on the left
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: ClipOval(
                child:
                    profile.profilePicture != null &&
                            profile.profilePicture!.isNotEmpty
                        ? Image.network(
                          profile.profilePicture!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderAvatar();
                          },
                        )
                        : _buildPlaceholderAvatar(),
              ),
            ),
            const SizedBox(width: 16),
            // Name and Age on the same line
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.age}',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.location,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.height,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.height,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Edit Profile Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(profile: profile),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }

  String _buildBasicInfoText(ProfileEntity profile) {
    return '''
Age: ${profile.age}
Gender: ${profile.gender}
Location: ${profile.location}
Height: ${profile.height}
''';
  }

  Future<void> _editField(
    BuildContext context,
    String field,
    ProfileEntity profile, {
    String? title,
    String? hint,
  }) async {
    final controller = TextEditingController(
      text: profile.toJson()[field] as String,
    );

    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit ${title ?? field}'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint ?? 'Enter your ${title ?? field}',
              ),
              maxLines: field == 'bio' ? 5 : 1,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && context.mounted) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(
          profile.copyWith(
            bio: field == 'bio' ? result : profile.bio,
            name: field == 'name' ? result : profile.name,
            location: field == 'location' ? result : profile.location,
            height: field == 'height' ? result : profile.height,
          ),
        ),
      );
    }
  }

  Future<void> _editBasicInfo(
    BuildContext context,
    ProfileEntity profile,
  ) async {
    final nameController = TextEditingController(text: profile.name);
    final ageController = TextEditingController(text: profile.age.toString());
    final locationController = TextEditingController(text: profile.location);
    final heightController = TextEditingController(text: profile.height);
    String selectedGender = profile.gender;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Basic Information'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items:
                        ['Male', 'Female', 'Other'].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedGender = value;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: heightController,
                    decoration: const InputDecoration(labelText: 'Height'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final age = int.tryParse(ageController.text);
                  if (age == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid age')),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'name': nameController.text,
                    'age': age,
                    'gender': selectedGender,
                    'location': locationController.text,
                    'height': heightController.text,
                  });
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && context.mounted) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(
          profile.copyWith(
            name: result['name'],
            age: result['age'],
            gender: result['gender'],
            location: result['location'],
            height: result['height'],
          ),
        ),
      );
    }
  }

  Future<void> _editInterests(
    BuildContext context,
    ProfileEntity profile,
  ) async {
    final selectedInterests = List<String>.from(profile.interests);
    final availableInterests = [
      'Travel',
      'Music',
      'Movies',
      'Reading',
      'Sports',
      'Cooking',
      'Photography',
      'Art',
      'Gaming',
      'Fitness',
      'Technology',
      'Fashion',
      'Food',
      'Nature',
      'Pets',
      'Dancing',
      'Writing',
      'Yoga',
      'Hiking',
      'Meditation',
    ];

    final result = await showDialog<List<String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Your Interests'),
            content: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                children:
                    availableInterests.map((interest) {
                      final isSelected = selectedInterests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            if (selectedInterests.length < 5) {
                              selectedInterests.add(interest);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You can select up to 5 interests',
                                  ),
                                ),
                              );
                            }
                          } else {
                            selectedInterests.remove(interest);
                          }
                          (context as Element).markNeedsBuild();
                        },
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, selectedInterests),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && context.mounted) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(profile.copyWith(interests: result)),
      );
    }
  }

  Future<void> _editIntentions(
    BuildContext context,
    ProfileEntity profile,
  ) async {
    final selectedIntentions = List<String>.from(profile.intentions);
    final availableIntentions = [
      'Long-term Relationship',
      'Short-term Dating',
      'Friendship',
      'Casual Dating',
      'Marriage',
      'Not Sure Yet',
    ];

    final result = await showDialog<List<String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('What are you looking for?'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    availableIntentions.map((intention) {
                      final isSelected = selectedIntentions.contains(intention);
                      return CheckboxListTile(
                        title: Text(intention),
                        value: isSelected,
                        onChanged: (selected) {
                          if (selected ?? false) {
                            if (selectedIntentions.length < 2) {
                              selectedIntentions.add(intention);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You can select up to 2 intentions',
                                  ),
                                ),
                              );
                            }
                          } else {
                            selectedIntentions.remove(intention);
                          }
                          (context as Element).markNeedsBuild();
                        },
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, selectedIntentions),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && context.mounted) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(profile.copyWith(intentions: result)),
      );
    }
  }
}
