import 'package:flutter/material.dart';
import 'dart:ui';
import '../app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use shared appState.requests

  void acceptRequest(String id) {
    setState(() {
      appState.updateRequestStatus(id, 'accepted');
      appState.spendToken('Accepted request $id');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You accepted the request!')));
    });
  }

  void fulfillRequest(String id) {
    setState(() {
      appState.updateRequestStatus(id, 'fulfilled');
      appState.earnTokens(2, 'Fulfilled request $id');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as delivered!')));
    });
  }

  void quickChat(String id) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quick chat sent!')));
  }

  @override
  Widget build(BuildContext context) {
  final activeRequests = appState.requests.where((r) => r.status == 'active' && !r.isExpired).toList();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withAlpha((0.7 * 255).toInt()),
            Colors.deepPurple.withAlpha((0.3 * 255).toInt()),
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
                title: const Text('Neighborhood Requests'),
                backgroundColor: Colors.white.withAlpha((0.2 * 255).toInt()),
                elevation: 0,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: activeRequests.length,
                itemBuilder: (context, index) {
                  final req = activeRequests[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: req.isUrgent ? Colors.red.withAlpha((0.25 * 255).toInt()) : Colors.white.withAlpha((0.25 * 255).toInt()),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(req.description, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('By ${req.requester} • ${req.distanceKm} km • ${DateTime.now().difference(req.createdAt).inMinutes} min ago'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.withAlpha((0.7 * 255).toInt()),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => acceptRequest(req.id),
                                  child: const Text('Accept'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.withAlpha((0.7 * 255).toInt()),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => quickChat(req.id),
                                  child: const Text('Quick Chat'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.withAlpha((0.7 * 255).toInt()),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => fulfillRequest(req.id),
                                  child: const Text('Delivered'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.deepPurple.withAlpha((0.25 * 255).toInt()),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.token, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Tokens: ', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text('${appState.tokenBalance}', style: TextStyle(color: Colors.yellowAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.pushNamed(context, '/post');
          },
          tooltip: 'Post Request',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
