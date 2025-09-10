import 'package:flutter/material.dart';
import 'dart:ui';
import '../app_state.dart';
import 'package:provider/provider.dart';

class TokenScreen extends StatelessWidget {
  const TokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.7),
            Color.fromRGBO(0, 0, 255, 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: const Text('Tokens & History'),
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
                elevation: 0,
              ),
            ),
          ),
        ),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.token, size: 64, color: Colors.blue),
                    SizedBox(height: 16),
                    Text('Tokens left: ${appState.tokenBalance}', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 24),
                    Text('Token History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    if (appState.tokenHistory.isEmpty)
                      Text('No token activity yet.', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ...appState.tokenHistory.reversed.take(5).map((h) => Text(h, style: TextStyle(fontSize: 14))),
                    SizedBox(height: 24),
                    Text('Work History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    if (appState.requests.isEmpty)
                      Text('No work history yet.', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ...appState.requests.reversed.take(5).map((r) => Text('Request: ${r.id} - Status: ${r.status}', style: TextStyle(fontSize: 14))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
