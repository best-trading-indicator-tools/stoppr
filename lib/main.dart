import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/welcome/application/welcome_manager.dart';
import 'features/welcome/presentation/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  // TEMPORARY: Clear SharedPreferences to force welcome screen to appear
  await prefs.remove('last_opened_date');
  
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
      routes: {
        '/home': (context) => const HomePage(),
      },
      home: FutureBuilder<bool>(
        future: WelcomeManager(prefs).shouldShowWelcomeScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          
          if (snapshot.data == true) {
            return const WelcomeScreen();
          }
          
          return const HomePage();
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
