import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? profilePicture;
  final List<String> photoUrls;
  final double radius;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProfileImage({
    super.key,
    this.profilePicture,
    this.photoUrls = const [],
    this.radius = 25,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  String? get _imageUrl {
    // Priority: profilePicture > first photoUrl > null
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      return profilePicture;
    }
    if (photoUrls.isNotEmpty && photoUrls.first.isNotEmpty) {
      return photoUrls.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrl;

    if (imageUrl == null) {
      return _buildPlaceholder(context);
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: width ?? radius * 2,
        height: height ?? radius * 2,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context);
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width ?? radius * 2,
      height: height ?? radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Icon(
        Icons.person,
        size: radius,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      width: width ?? radius * 2,
      height: height ?? radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Center(
        child: SizedBox(
          width: radius * 0.6,
          height: radius * 0.6,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
