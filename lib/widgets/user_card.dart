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
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xFFFFCDD2), // soft red
                    child: Icon(Icons.close, color: Colors.red),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFBBDEFB), // soft blue
                    child: Icon(Icons.star, color: Colors.blue),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFF8BBD0), // soft pink
                    child: Icon(Icons.favorite, color: Colors.pink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
