import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/auth/auth_service.dart';
import 'core/auth/cubit/auth_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the DefaultFirebaseOptions
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  
  final prefs = await SharedPreferences.getInstance();
  final authService = AuthService();
  
  runApp(MyApp(
    prefs: prefs,
    authService: authService,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final AuthService authService;
  
  MyApp({
    super.key, 
    required this.prefs,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authService: authService),
      child: MaterialApp(
        title: 'Stoppr',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/home': (context) => const HomePage(),
        },
        // Directly using OnboardingPage as the initial screen
        home: const OnboardingPage(),
      ),
    );
  }
}

// Temporary HomePage widget - replace with your actual home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home Page',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reset preferences and restart app flow for testing
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('last_opened_date');
                  Navigator.of(context).pushReplacementNamed('/');
                });
              },
              child: const Text('Restart App Flow'),
            ),
          ],
        ),
      ),
    );
  }
}
