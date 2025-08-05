import 'package:flutter/material.dart';
import 'package:ilike/features/profile/data/models/profile_model.dart';

class SwipeCardsScreen extends StatefulWidget {
  const SwipeCardsScreen({super.key});

  @override
  State<SwipeCardsScreen> createState() => _SwipeCardsScreenState();
}

class _SwipeCardsScreenState extends State<SwipeCardsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int currentIndex = 0;
  bool isAnimating = false;

  // Sample data - replace with your actual data
  final List<ProfileModel> profiles = [
    ProfileModel(
      name: "Sarah",
      age: 25,
      gender: "Female",
      location: "New York, NY",
      bio:
          "Love hiking, coffee, and good conversations. Looking for someone who shares my passion for adventure!",
      interests: ["Hiking", "Coffee", "Photography", "Travel"],
      intentions: ["Long-term relationship"],
      height: "5'6\"",
      photoUrls: [
        "https://via.placeholder.com/400x600/FF6B6B/FFFFFF?text=Sarah",
      ],
    ),
    ProfileModel(
      name: "Mike",
      age: 28,
      gender: "Male",
      location: "Los Angeles, CA",
      bio:
          "Fitness enthusiast and dog lover. Always up for trying new restaurants and outdoor activities.",
      interests: ["Fitness", "Dogs", "Cooking", "Music"],
      intentions: ["Dating", "Long-term relationship"],
      height: "6'0\"",
      photoUrls: [
        "https://via.placeholder.com/400x600/4ECDC4/FFFFFF?text=Mike",
      ],
    ),
    ProfileModel(
      name: "Emma",
      age: 23,
      gender: "Female",
      location: "Chicago, IL",
      bio:
          "Artist and book lover. Seeking someone who appreciates creativity and deep conversations.",
      interests: ["Art", "Reading", "Museums", "Yoga"],
      intentions: ["Dating"],
      height: "5'4\"",
      photoUrls: [
        "https://via.placeholder.com/400x600/45B7D1/FFFFFF?text=Emma",
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSwipeLeft() {
    if (isAnimating) return;
    _performSwipe(SwipeDirection.left);
  }

  void _onSwipeRight() {
    if (isAnimating) return;
    _performSwipe(SwipeDirection.right);
  }

  void _performSwipe(SwipeDirection direction) {
    if (currentIndex >= profiles.length - 1) {
      // No more profiles
      _showNoMoreProfilesDialog();
      return;
    }

    setState(() {
      isAnimating = true;
    });

    _animationController.forward().then((_) {
      setState(() {
        currentIndex++;
        isAnimating = false;
      });
      _animationController.reset();

      // Handle swipe action
      if (direction == SwipeDirection.right) {
        _onLike(profiles[currentIndex - 1]);
      } else {
        _onDislike(profiles[currentIndex - 1]);
      }
    });
  }

  void _onLike(ProfileModel profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${profile.name}! 💕'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onDislike(ProfileModel profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passed on ${profile.name}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showNoMoreProfilesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('No More Profiles'),
            content: const Text(
              'You\'ve seen all available profiles. Check back later for more!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // Handle filters
            },
          ),
        ],
      ),
      body:
          currentIndex >= profiles.length
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No more profiles!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for more matches',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          // Next card (if available)
                          if (currentIndex + 1 < profiles.length)
                            ProfileCard(
                              profile: profiles[currentIndex + 1],
                              isTop: false,
                            ),
                          // Current card
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 - (_animation.value * 0.1),
                                child: Transform.translate(
                                  offset: Offset(_animation.value * 300, 0),
                                  child: Transform.rotate(
                                    angle: _animation.value * 0.3,
                                    child: ProfileCard(
                                      profile: profiles[currentIndex],
                                      isTop: true,
                                      onSwipeLeft: _onSwipeLeft,
                                      onSwipeRight: _onSwipeRight,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Action buttons
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          onPressed: _onSwipeLeft,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          elevation: 8,
                          child: const Icon(Icons.close, size: 32),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            // Handle super like
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          elevation: 8,
                          child: const Icon(Icons.star, size: 32),
                        ),
                        FloatingActionButton(
                          onPressed: _onSwipeRight,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          elevation: 8,
                          child: const Icon(Icons.favorite, size: 32),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

enum SwipeDirection { left, right }

class ProfileCard extends StatefulWidget {
  final ProfileModel profile;
  final bool isTop;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const ProfileCard({
    Key? key,
    required this.profile,
    this.isTop = false,
    this.onSwipeLeft,
    this.onSwipeRight,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  double _dragDistance = 0;
  double _dragAngle = 0;
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: widget.isTop ? _onPanUpdate : null,
      onPanEnd: widget.isTop ? _onPanEnd : null,
      child: Transform.translate(
        offset: Offset(_dragDistance, 0),
        child: Transform.rotate(
          angle: _dragAngle,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child:
                        widget.profile.photoUrls.isNotEmpty
                            ? Image.network(
                              widget.profile.photoUrls[_currentPhotoIndex],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                            : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                  ),

                  // Photo indicators
                  if (widget.profile.photoUrls.length > 1)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: List.generate(
                          widget.profile.photoUrls.length,
                          (index) => Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(
                                right:
                                    index < widget.profile.photoUrls.length - 1
                                        ? 4
                                        : 0,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    index == _currentPhotoIndex
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Swipe indicators
                  if (widget.isTop && _dragDistance != 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _dragDistance > 0
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3),
                        ),
                        child: Center(
                          child: Text(
                            _dragDistance > 0 ? 'LIKE' : 'NOPE',
                            style: TextStyle(
                              color:
                                  _dragDistance > 0 ? Colors.green : Colors.red,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Profile info
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${widget.profile.name}, ${widget.profile.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _showProfileDetails(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.profile.location,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          if (widget.profile.bio.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              widget.profile.bio,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Invisible tap areas for photo navigation
                  if (widget.profile.photoUrls.length > 1) ...[
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 200,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GestureDetector(
                        onTap: _previousPhoto,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 200,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GestureDetector(
                        onTap: _nextPhoto,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDistance += details.delta.dx;
      _dragAngle = _dragDistance / 1000;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    const threshold = 100;

    if (_dragDistance > threshold) {
      widget.onSwipeRight?.call();
    } else if (_dragDistance < -threshold) {
      widget.onSwipeLeft?.call();
    }

    setState(() {
      _dragDistance = 0;
      _dragAngle = 0;
    });
  }

  void _nextPhoto() {
    if (_currentPhotoIndex < widget.profile.photoUrls.length - 1) {
      setState(() {
        _currentPhotoIndex++;
      });
    }
  }

  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
      setState(() {
        _currentPhotoIndex--;
      });
    }
  }

  void _showProfileDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileDetailsSheet(profile: widget.profile),
    );
  }
}

class ProfileDetailsSheet extends StatelessWidget {
  final ProfileModel profile;

  const ProfileDetailsSheet({Key? key, required this.profile})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${profile.name}, ${profile.age}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection('Bio', profile.bio),
                  _buildDetailSection('Location', profile.location),
                  _buildDetailSection('Height', profile.height),
                  _buildDetailSection('Gender', profile.gender),
                  if (profile.interests.isNotEmpty)
                    _buildChipSection('Interests', profile.interests),
                  if (profile.intentions.isNotEmpty)
                    _buildChipSection('Looking for', profile.intentions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChipSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              items
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      backgroundColor: Colors.grey[200],
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Main app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SwipeCardsScreen(),
    );
  }
}

void main() {
  runApp(MyApp());
}
