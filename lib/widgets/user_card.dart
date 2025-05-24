import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final int age;
  final String bio;
  final String imageUrl;

  const UserCard({
    super.key,
    required this.name,
    required this.age,
    required this.bio,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: SizedBox(
        height: 400,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 12),
            Text('$name, $age',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(bio),
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
    );
  }
}
