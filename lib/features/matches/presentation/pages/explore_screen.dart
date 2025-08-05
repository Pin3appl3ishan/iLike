import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/match_bloc.dart';
import '../widgets/profile_card.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:ilike/features/profile/presentation/bloc/profile/profile_state.dart';
import '../widgets/itsmatch_screen.dart';
import '../../domain/entities/potential_match_entity.dart';
import 'package:ilike/core/services/sensor_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final SensorService _sensorService = SensorService();
  bool _isLocationEnabled = false;
  String _locationStatus = 'Checking location...';

  // Demo data for explore page with Nepali details
  final List<PotentialMatchEntity> _demoProfiles = [
    PotentialMatchEntity(
      id: '1',
      name: 'Priya Thapa',
      age: 24,
      gender: 'female',
      location: 'Kathmandu, Nepal',
      bio:
          'Software engineer by day, yoga enthusiast by evening 🧘‍♀️ Love exploring new cafes in Thamel, hiking in the Himalayas, and trying different momo varieties. Looking for someone to share adventures with!',
      photoUrls: [
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop&crop=face',
      ],
      interests: ['Yoga', 'Hiking', 'Photography', 'Coffee', 'Travel'],
      intentions: ['Long-term relationship', 'Friendship'],
      height: '5\'3"',
    ),
    PotentialMatchEntity(
      id: '2',
      name: 'Anjali Shrestha',
      age: 26,
      gender: 'female',
      location: 'Pokhara, Nepal',
      bio:
          'Creative soul who loves painting, traditional Nepali music, and cooking dal bhat. Passionate about preserving our culture and finding beauty in everyday moments. Namaste! 🙏',
      photoUrls: [
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face',
      ],
      interests: ['Painting', 'Music', 'Cooking', 'Culture', 'Reading'],
      intentions: ['Serious relationship', 'Casual dating'],
      height: '5\'2"',
    ),
    PotentialMatchEntity(
      id: '3',
      name: 'Rajesh Gurung',
      age: 27,
      gender: 'male',
      location: 'Lalitpur, Nepal',
      bio:
          'Tech entrepreneur and fitness enthusiast. Love exploring new restaurants in Patan, playing football, and building things. Always up for an adventure in the mountains! 🏔️',
      photoUrls: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop&crop=face',
      ],
      interests: ['Technology', 'Fitness', 'Football', 'Food', 'Travel'],
      intentions: ['Long-term relationship', 'Friendship'],
      height: '5\'8"',
    ),
    PotentialMatchEntity(
      id: '4',
      name: 'Amit Tamang',
      age: 29,
      gender: 'male',
      location: 'Bhaktapur, Nepal',
      bio:
          'Tourism professional and nature lover. When I\'m not showing visitors around our beautiful heritage sites, you\'ll find me hiking in Shivapuri or enjoying momo at local restaurants.',
      photoUrls: [
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
      ],
      interests: ['Tourism', 'Hiking', 'Photography', 'Food', 'Culture'],
      intentions: ['Casual dating', 'Serious relationship'],
      height: '5\'7"',
    ),
    PotentialMatchEntity(
      id: '5',
      name: 'Sita Magar',
      age: 25,
      gender: 'female',
      location: 'Chitwan, Nepal',
      bio:
          'Environmental activist and bookworm. I spend my weekends exploring Chitwan National Park, reading in cozy cafes, and working on conservation projects. Looking for someone to share quiet moments with.',
      photoUrls: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=600&fit=crop&crop=face',
      ],
      interests: [
        'Environment',
        'Reading',
        'Wildlife',
        'Nature',
        'Photography'
      ],
      intentions: ['Long-term relationship', 'Friendship'],
      height: '5\'4"',
    ),
    PotentialMatchEntity(
      id: '6',
      name: 'Bikash Limbu',
      age: 28,
      gender: 'male',
      location: 'Dharan, Nepal',
      bio:
          'Music teacher and traditional instrument enthusiast. I play madal, love live music, and enjoy trying different Nepali cuisines. Looking for someone to share good vibes and cultural experiences with! 🎵',
      photoUrls: [
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
      ],
      interests: [
        'Music',
        'Traditional Instruments',
        'Cooking',
        'Culture',
        'Teaching'
      ],
      intentions: ['Casual dating', 'Serious relationship'],
      height: '5\'9"',
    ),
  ];

  int _currentProfileIndex = 0;

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

    // For demo, we'll use local data instead of loading from API
    // context.read<MatchBloc>().add(LoadPotentialMatchesEvent());
    _initializeLocationSensor();
  }

  Future<void> _initializeLocationSensor() async {
    try {
      final hasPermission = await _sensorService.requestLocationPermission();
      final isLocationEnabled = await _sensorService.isLocationServiceEnabled();

      if (hasPermission && isLocationEnabled) {
        await _sensorService.startLocationTracking();
        setState(() {
          _isLocationEnabled = true;
          _locationStatus = 'Location enabled - Finding nearby matches';
        });
      } else {
        setState(() {
          _locationStatus = 'Location disabled - Enable for better matching';
        });
      }
    } catch (e) {
      setState(() {
        _locationStatus = 'Location error: $e';
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sensorService.dispose();
    super.dispose();
  }

  void _onSwipeLeft(String userId) {
    // For demo, just move to next profile
    setState(() {
      if (_currentProfileIndex < _demoProfiles.length - 1) {
        _currentProfileIndex++;
      }
    });

    // In real app, this would call the bloc
    // context.read<MatchBloc>().add(DislikeUserEvent(userId: userId));
  }

  void _onSwipeRight(String userId) {
    // For demo, show match screen and move to next profile
    setState(() {
      if (_currentProfileIndex < _demoProfiles.length - 1) {
        _currentProfileIndex++;
      }
    });

    // Show match screen for demo
    _showMatchScreen(context, userId);

    // In real app, this would call the bloc
    // context.read<MatchBloc>().add(LikeUserEvent(userId: userId));
  }

  void _showMatchScreen(BuildContext context, String matchedUserId) {
    // For demo, find the matched user from demo data
    final matchedUser = _demoProfiles.firstWhere(
      (profile) => profile.id == matchedUserId,
      orElse: () => _demoProfiles[0], // fallback
    );

    // Demo current user photo
    String currentUserPhotoUrl =
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItsAMatchPage(
          currentUserPhotoUrl: currentUserPhotoUrl,
          matchedUserId: matchedUser.id,
          matchedUserName: matchedUser.name,
          matchedUserPhotoUrl: matchedUser.photoUrls.isNotEmpty
              ? matchedUser.photoUrls.first
              : 'https://via.placeholder.com/100',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if we have profiles to show
    if (_demoProfiles.isEmpty) {
      return const Center(
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
      );
    }

    // Check if we've gone through all profiles
    if (_currentProfileIndex >= _demoProfiles.length) {
      return const Center(
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
      );
    }

    return Column(
      children: [
        // Location status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                _isLocationEnabled ? Icons.location_on : Icons.location_off,
                color: _isLocationEnabled ? Colors.green : Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _locationStatus,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isLocationEnabled ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Next card (if available)
                if (_currentProfileIndex + 1 < _demoProfiles.length)
                  ProfileCard(
                    profile: _demoProfiles[_currentProfileIndex + 1],
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
                            profile: _demoProfiles[_currentProfileIndex],
                            isTop: true,
                            onSwipeLeft: () => _onSwipeLeft(
                              _demoProfiles[_currentProfileIndex].id,
                            ),
                            onSwipeRight: () => _onSwipeRight(
                              _demoProfiles[_currentProfileIndex].id,
                            ),
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
                onPressed: () => _onSwipeLeft(
                  _demoProfiles[_currentProfileIndex].id,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                elevation: 8,
                child: const Icon(Icons.close, size: 32),
              ),
              FloatingActionButton(
                onPressed: () => _onSwipeRight(
                  _demoProfiles[_currentProfileIndex].id,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                elevation: 8,
                child: const Icon(Icons.favorite, size: 32),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
