import 'package:flutter/material.dart';
// import '../app_state.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create/Request Errand'), backgroundColor: Colors.green),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/postRequest');
            if (result is Map<String, dynamic> && context.mounted) {
              Navigator.pop(context, result);
            }
          },
          child: const Text('Go to Post Request'),
        ),
      ),
    );
  }
}
