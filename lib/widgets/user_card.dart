import 'package:flutter/material.dart';
import 'package:ilike/models/user_model.dart';

class UserCard extends StatelessWidget {
  final User user;
  final bool isBehindCard;

  const UserCard({super.key, required this.user, this.isBehindCard = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isBehindCard ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: SizedBox(
          height: 420,
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.avatar),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user.bio),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircleAvatar(child: Icon(Icons.close, color: Colors.red)),
                  CircleAvatar(child: Icon(Icons.star, color: Colors.blue)),
                  CircleAvatar(child: Icon(Icons.favorite, color: Colors.pink)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
