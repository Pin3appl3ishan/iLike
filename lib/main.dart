import 'package:flutter/material.dart';
import 'package:ilike/views/login_screen.dart';
import 'package:ilike/views/register_screen.dart';
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
        useMaterial3: false,
        fontFamily: 'Poppins',
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme( 
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
