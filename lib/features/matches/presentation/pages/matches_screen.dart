import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/match_bloc.dart';
import '../widgets/match_card.dart';
import '../widgets/like_card.dart';
import '../widgets/profile_grid_card.dart';
import '../widgets/match_grid_card.dart';
import '../../../chat/presentation/pages/chat_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Demo data for showcase with Nepali details
  final List<Map<String, dynamic>> _demoLikes = [
    {
      'id': '1',
      'name': 'Priya Thapa',
      'age': 24,
      'gender': 'female',
      'location': 'Kathmandu, Nepal',
      'interests': ['Yoga', 'Hiking', 'Photography'],
      'profilePicture':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face',
    },
    {
      'id': '2',
      'name': 'Anjali Shrestha',
      'age': 26,
      'gender': 'female',
      'location': 'Pokhara, Nepal',
      'interests': ['Painting', 'Music', 'Cooking'],
      'profilePicture':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=600&fit=crop&crop=face',
    },
  ];

  final List<Map<String, dynamic>> _demoLikesSent = [
    {
      'id': '3',
      'name': 'Rajesh Gurung',
      'age': 27,
      'gender': 'male',
      'location': 'Lalitpur, Nepal',
      'interests': ['Technology', 'Football', 'Food'],
      'profilePicture':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
    },
    {
      'id': '4',
      'name': 'Amit Tamang',
      'age': 29,
      'gender': 'male',
      'location': 'Bhaktapur, Nepal',
      'interests': ['Tourism', 'Hiking', 'Culture'],
      'profilePicture':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=600&fit=crop&crop=face',
    },
  ];

  final List<Map<String, dynamic>> _demoMatches = [
    {
      'id': '1',
      'user': {
        'id': '1',
        'name': 'Priya Thapa',
        'age': 24,
        'gender': 'female',
        'location': 'Kathmandu, Nepal',
        'interests': ['Yoga', 'Hiking', 'Photography'],
        'profilePicture':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face',
      },
      'matchDate': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '2',
      'user': {
        'id': '3',
        'name': 'Rajesh Gurung',
        'age': 27,
        'gender': 'male',
        'location': 'Lalitpur, Nepal',
        'interests': ['Technology', 'Football', 'Food'],
        'profilePicture':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
      },
      'matchDate': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load initial data
    _loadTabData(_tabController.index);

    // Listen to tab changes
    _tabController.addListener(() {
      _loadTabData(_tabController.index);
    });
  }

  void _loadTabData(int tabIndex) {
    switch (tabIndex) {
      case 0: // Likes tab
        context.read<MatchBloc>().add(LoadLikesEvent());
        break;
      case 1: // Likes Sent tab
        context.read<MatchBloc>().add(LoadLikesSentEvent());
        break;
      case 2: // Matches tab
        context.read<MatchBloc>().add(LoadMatchesEvent());
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple TabBar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            tabs: const [
              Tab(text: 'Likes'),
              Tab(text: 'Likes Sent'),
              Tab(text: 'Matches'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Likes Tab
                _buildLikesTab(),
                // Likes Sent Tab
                _buildLikesSentTab(),
                // Matches Tab
                _buildMatchesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikesTab() {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        if (state is MatchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MatchErrorState) {
          return _buildErrorState(state.message, () => _loadTabData(0));
        }

        // For demo, show demo data instead of real data
        if (_demoLikes.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _demoLikes.length,
            itemBuilder: (context, index) {
              final profile = _demoLikes[index];
              return _buildDemoProfileCard(profile, 'Likes');
            },
          );
        }

        return _buildEmptyState(
          icon: Icons.favorite_border,
          title: 'No likes yet',
          message: 'When someone likes your profile, they\'ll appear here.',
        );
      },
    );
  }

  Widget _buildLikesSentTab() {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        if (state is MatchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MatchErrorState) {
          return _buildErrorState(state.message, () => _loadTabData(1));
        }

        // For demo, show demo data instead of real data
        if (_demoLikesSent.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _demoLikesSent.length,
            itemBuilder: (context, index) {
              final profile = _demoLikesSent[index];
              return _buildDemoProfileCard(profile, 'Likes Sent');
            },
          );
        }

        return _buildEmptyState(
          icon: Icons.favorite_outline,
          title: 'No likes sent',
          message: 'Start exploring to find people you like!',
        );
      },
    );
  }

  Widget _buildMatchesTab() {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        if (state is MatchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MatchErrorState) {
          return _buildErrorState(state.message, () => _loadTabData(2));
        }

        // For demo, show demo data instead of real data
        if (_demoMatches.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _demoMatches.length,
            itemBuilder: (context, index) {
              final match = _demoMatches[index];
              return _buildDemoMatchCard(match);
            },
          );
        }

        return _buildEmptyState(
          icon: Icons.people_outline,
          title: 'No matches yet',
          message:
              'Keep exploring! When you both like each other, it\'s a match!',
        );
      },
    );
  }

  Widget _buildDemoProfileCard(Map<String, dynamic> profile, String tabType) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Viewing ${profile['name']}\'s profile from $tabType'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Stack(
          children: [
            // Profile Image
            AspectRatio(
              aspectRatio: 0.75,
              child: Image.network(
                profile['profilePicture'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  );
                },
              ),
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${profile['name'].split(' ').first}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildGenderIcon(profile['gender']),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile['age']} • ${profile['location']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (profile['interests'] != null &&
                        profile['interests'].isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: profile['interests']
                            .take(2)
                            .map<Widget>((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              interest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoMatchCard(Map<String, dynamic> match) {
    final user = match['user'] as Map<String, dynamic>;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Show chat screen as a modal
          _showChatModal(context, {
            'id': match['id'],
            'name': user['name'],
            'profilePicture': user['profilePicture'],
          });
        },
        child: Stack(
          children: [
            // Profile Image
            AspectRatio(
              aspectRatio: 0.75,
              child: Image.network(
                user['profilePicture'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  );
                },
              ),
            ),
            // MATCH badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'MATCH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${user['name'].split(' ').first}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildGenderIcon(user['gender']),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user['age']} • ${user['location']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (user['interests'] != null &&
                        user['interests'].isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children:
                            user['interests'].take(2).map<Widget>((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              interest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderIcon(String gender) {
    IconData icon;
    Color color;

    switch (gender.toLowerCase()) {
      case 'male':
        icon = Icons.male;
        color = Colors.blue;
        break;
      case 'female':
        icon = Icons.female;
        color = Colors.pink;
        break;
      default:
        icon = Icons.person;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 16);
  }

  void _showChatModal(BuildContext context, Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chat: chat),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
