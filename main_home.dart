import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/post_request_screen.dart';
import 'screens/token_screen.dart';
import 'screens/match_flow_screen.dart';
import 'screens/profile_screen.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro-Errand Swapper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
  '/': (context) => const HomeScreen(),
  '/post': (context) => PostRequestScreen(),
  '/tokens': (context) => const TokenScreen(),
  '/match': (context) => const MatchFlowScreen(),
  '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
