import 'package:flutter/material.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iLike App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const SplashScreen(),
    );
  }
}