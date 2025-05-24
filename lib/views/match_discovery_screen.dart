import 'package:flutter/material.dart';
import 'package:ilike/widgets/user_card.dart';
import 'package:ilike/models/user_model.dart';

class MatchDiscoveryScreen extends StatefulWidget {
  MatchDiscoveryScreen({super.key});

  @override
  State<MatchDiscoveryScreen> createState() => _MatchDiscoveryScreenState();
}

class _MatchDiscoveryScreenState extends State<MatchDiscoveryScreen> {
  final List<User> mockUsers = [
    User(
      id: '1',
      name: 'Emma',
      email: 'emma@example.com',
      bio: 'Loves hiking and sushi 🍣',
      avatar: 'https://i.pravatar.cc/300',
    ),
    User(
      id: '2',
      name: 'Liam',
      email: 'liam@example.com',
      bio: 'Tech enthusiast & gym rat 🏋️',
      avatar: 'https://i.pravatar.cc/301',
    ),
    User(
      id: '3',
      name: 'Sophia',
      email: 'sophia@example.com',
      bio: 'Music and art lover 🎨🎶',
      avatar: 'https://i.pravatar.cc/302',
    ),
  ];

  int currentIndex = 0;

  void _swipe(bool liked) {
    // Handle swipe logic here
    if (liked) {
      // Logic for liking a user
      print('Liked user at index ${mockUsers[currentIndex].name}');
    } else {
      // Logic for rejecting a user
      print('Rejected user at index ${mockUsers[currentIndex].name}');
    }

    setState(() {
      if (currentIndex < mockUsers.length - 1) {
        currentIndex++;
      } else {
        // Reset to the first user if at the end
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mockUsers.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (currentIndex < mockUsers.length - 1)
            UserCard(user: mockUsers[currentIndex + 1], isBehindCard: true),
          Draggable(
            feedback: Material(
              color: Colors.transparent,
              child: UserCard(user: mockUsers[currentIndex]),
            ),
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx > 300) {
                _swipe(true); // Right swipe
              } else if (details.velocity.pixelsPerSecond.dx < -300) {
                _swipe(false); // Left swipe
              }
            },
            child: UserCard(user: mockUsers[currentIndex]),
          ),
        ],
      ),
    );
  }
}
