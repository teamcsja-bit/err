import 'package:flutter/material.dart';
// Removed Firestore import
import '../models/errand_post.dart';
import '../app_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  @override
  void initState() {
    super.initState();
    appState.addListener(_onAppStateChanged);
    _checkFirebase();
  }

  Future<void> _checkFirebase() async {
    try {
      // Try to get the default Firebase app
      await Future.delayed(const Duration(milliseconds: 100));
      // If Firebase is initialized, fetch posts
  setState(() {});
      await appState.fetchPosts();
    } catch (e) {
      // Firebase not ready, do nothing
    }
  }

  @override
  void dispose() {
    appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  void acceptPost(String id) {
    setState(() {
      appState.updatePostStatus(id, 'accepted');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Accepted post!')));
    });
  }

  void fulfillPost(String id) {
    setState(() {
      appState.updatePostStatus(id, 'fulfilled');
      appState.earnTokens(1, 'Fulfilled post $id');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as delivered! (+1 token)')));
    });
  }

  void withdrawPost(String id) async {
    await appState.deletePost(id);
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post withdrawn and deleted.')));
    }
  }


  @override
  Widget build(BuildContext context) {
    final currentUser = appState.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micro-Errand Swapper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              appState.clearLoggedInUser();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.token, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Tokens: ', style: TextStyle(fontSize: 18)),
                  Text('${appState.tokenBalance}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow[700])),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: appState.posts.length,
                itemBuilder: (context, index) {
                  final post = appState.posts[index];
                  final expired = post.isExpired;
                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: expired
                        ? Colors.grey[300]
                        : post.type == 'request'
                            ? (Colors.blue[50] ?? Colors.white)
                            : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(post.type == 'offer' ? Icons.local_shipping : Icons.shopping_cart),
                          title: Text('${post.type == 'offer' ? 'Going to' : 'Needs from'} ${post.place}'),
                          subtitle: Text('Item: ${post.item}\nETA: ${post.eta.hour}:${post.eta.minute.toString().padLeft(2, '0')}\nBy: ${post.userNickname}\nExpires: ${post.expiresAt.hour}:${post.expiresAt.minute.toString().padLeft(2, '0')}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${post.radiusKm} km'),
                              Text('Status: ${post.status}', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            children: [
                              if (post.status == 'active' && !expired && currentUser != null && post.userNickname != currentUser.name)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  onPressed: () => acceptPost(post.id),
                                  child: const Text('Accept'),
                                ),
                              if (post.status == 'accepted')
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                  onPressed: () => fulfillPost(post.id),
                                  child: const Text('Mark Delivered (+1 tokens)'),
                                ),
                              if (post.status == 'active' && post.userNickname == 'You' && !expired)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => withdrawPost(post.id),
                                  child: const Text('Withdraw'),
                                ),
                              if (expired)
                                Text('Expired', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.pushNamed(context, '/postRequest');
        if (result is Map<String, dynamic>) {
          await appState.addPost(
            ErrandPost(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: 'request',
              place: result['destination'],
              item: result['description'],
              userNickname: 'You',
              eta: DateTime.now().add(Duration(hours: result['waitHours'])),
              radiusKm: result['distanceKm'],
              status: 'active',
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(hours: result['waitHours'])),
            ),
          );
          await appState.fetchPosts();
          setState(() {});
        }
      },
      tooltip: 'Post Errand',
      child: const Icon(Icons.add),
    ),
  );
  }
}
