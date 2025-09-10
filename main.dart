import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/post_request_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAZGpT0G3IgcVmIPviGEKEA8NCXbBkh0p4",
        authDomain: "flutter-setup-b3434.firebaseapp.com",
        projectId: "flutter-setup-b3434",
        storageBucket: "flutter-setup-b3434.appspot.com",
        messagingSenderId: "918148464969",
        appId: "1:918148464969:web:9da6d25f00ef7c9a1d5a98",
        measurementId: "G-CW59VCG9QR",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro-Errand Swapper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashToMain(),
      routes: {
        '/postRequest': (context) => PostRequestScreen(),
      },
    );

  }
}

class SplashToMain extends StatefulWidget {
  const SplashToMain({super.key});

  @override
  State<SplashToMain> createState() => _SplashToMainState();
}

class _SplashToMainState extends State<SplashToMain> {

  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }
    // Dummy login state: always show LoginScreen first
    // You can replace this with your own local login logic if needed
  // Always show LoginScreen for now
  return const LoginScreen();
  }
}

// ...existing code...
