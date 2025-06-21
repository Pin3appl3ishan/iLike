import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/core/injection/injection_container.dart' as di;
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/presentation/pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize dependency injection (which will handle Hive initialization)
    await di.init();
    
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing app: $e');
    // Fallback to a simple error widget if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
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
        home: const AuthWrapper(),
      ),
    );
  }
}
