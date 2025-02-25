import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/welcome/application/welcome_manager.dart';
import 'features/welcome/presentation/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stoppr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: WelcomeManager(prefs).shouldShowWelcomeScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          
          if (snapshot.data == true) {
            return const WelcomeScreen();
          }
          
          return const HomePage(); // You'll need to create this
        },
      ),
    );
  }
}

// Temporary HomePage widget - replace with your actual home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
