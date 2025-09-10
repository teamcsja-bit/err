import 'package:flutter/material.dart';

class MatchFlowScreen extends StatelessWidget {
  const MatchFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> matches = [
      {
        'errand': 'Pickup groceries',
        'user': 'Alice',
        'status': 'Accepted',
        'details': 'Pickup groceries from CityMart by 6pm.'
      },
      {
        'errand': 'Deliver medicine',
        'user': 'Bob',
        'status': 'In Progress',
        'details': 'Deliver medicine to Bob, address: 123 Main St.'
      },
      {
        'errand': 'Walk dog',
        'user': 'Charlie',
        'status': 'Completed',
        'details': 'Walk Charlie’s dog at 5pm.'
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: matches.length,
        itemBuilder: (context, idx) {
          final match = matches[idx];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.orange, size: 36),
              title: Text(match['errand'] ?? ''),
              subtitle: Text('With: ${match['user']!}\nStatus: ${match['status']!}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(match['errand'] ?? ''),
                    content: Text(match['details'] ?? ''),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
  
