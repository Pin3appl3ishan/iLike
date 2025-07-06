import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';
import 'package:ilike/features/profile/domain/repositories/profile_repository.dart';
import 'package:get_it/get_it.dart';

class PhotosStep extends OnboardingStepWidget {
  final List<String> photos;
  final Function(List<String>) onChanged;

  PhotosStep({
    super.key,
    required this.onChanged,
    required this.photos,
    super.onNext,
    super.onBack,
  }) : super(
         header: "Upload your best moments",
         subtext: "Add at least 1 photo to show your vibe (max 5).",
         canProceed:
             photos.isNotEmpty &&
             !photos.any(
               (url) => url.startsWith('file://'),
             ), // Check for local file scheme instead
       );

  // Track uploads in progress to prevent duplicates
  final Set<String> _uploadsInProgress = {};

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 5, // Maximum 5 photos
                itemBuilder: (context, index) {
                  if (index < photos.length) {
                    final photo = photos[index];
                    final bool isUploading = photo.startsWith('file://');

                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image:
                                  isUploading
                                      ? FileImage(
                                        File(photo.substring(7)),
                                      ) // Remove file:// prefix
                                      : NetworkImage(photo) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isUploading)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              final newPhotos = List<String>.from(photos);
                              newPhotos.removeAt(index);
                              onChanged(newPhotos);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => _pickImage(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        if (photos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Please upload at least one photo to continue",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (photos.any((url) => url.startsWith('file://')))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Please wait for photos to finish uploading",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    if (photos.length >= 5) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final localPath = 'file://${image.path}';

      // Prevent duplicate uploads
      if (_uploadsInProgress.contains(localPath)) {
        print('[PhotosStep] Upload already in progress for: $localPath');
        return;
      }
      _uploadsInProgress.add(localPath);

      print('[PhotosStep] Starting upload of: $localPath');
      print('[PhotosStep] Current photos: $photos');

      // Add local path with file:// scheme to indicate upload pending
      final newPhotos = List<String>.from(photos);
      newPhotos.add(localPath);
      onChanged(newPhotos);

      // Upload photo
      try {
        final repository = GetIt.I<IProfileRepository>();
        final result = await repository.uploadPhoto(image.path);

        result.fold(
          (failure) {
            print('[PhotosStep] Upload failed: ${failure.message}');
            final currentPhotos = List<String>.from(photos);
            if (currentPhotos.remove(localPath)) {
              print('[PhotosStep] Removed failed upload from photos');
            } else {
              print(
                '[PhotosStep] Warning: Could not find failed upload in photos',
              );
            }
            onChanged(currentPhotos);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload photo: ${failure.message}'),
              ),
            );
          },
          (serverUrl) {
            print('[PhotosStep] Upload succeeded. Server URL: $serverUrl');
            print('[PhotosStep] Looking for local path: $localPath');
            final currentPhotos = List<String>.from(photos);
            print('[PhotosStep] Current photos before update: $currentPhotos');
            final index = currentPhotos.indexOf(localPath);
            if (index != -1) {
              currentPhotos[index] = serverUrl;
              print('[PhotosStep] Updated photos array: $currentPhotos');
              onChanged(currentPhotos);
            } else {
              print(
                '[PhotosStep] Warning: Could not find local path in photos array',
              );
              currentPhotos.add(serverUrl);
              print('[PhotosStep] Added server URL directly: $currentPhotos');
              onChanged(currentPhotos);
            }
          },
        );
      } catch (e) {
        print('[PhotosStep] Unexpected error during upload: $e');
        final currentPhotos = List<String>.from(photos);
        currentPhotos.remove(localPath);
        onChanged(currentPhotos);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      } finally {
        // Always remove from uploads in progress
        _uploadsInProgress.remove(localPath);
      }
    }
  }
}
