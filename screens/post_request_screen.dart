
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/errand_request.dart';
import '../models/errand_post.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  PostRequestScreenState createState() => PostRequestScreenState();
}

class PostRequestScreenState extends State<PostRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String description = '';
  String destination = '';
  TimeOfDay? selectedTime;
  double distanceKm = 1.0;
  bool isUrgent = false;
  int waitHours = 1;


  @override
  Widget build(BuildContext context) {
  final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Request'), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Request Description', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'e.g., I am very sick, need cough syrup'),
                  onChanged: (val) => description = val,
                  validator: (val) => val == null || val.isEmpty ? 'Enter a description' : null,
                ),
                const SizedBox(height: 16),
                Text('How many hours will you wait?', style: Theme.of(context).textTheme.titleLarge),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: waitHours.toDouble(),
                        min: 1,
                        max: 24,
                        divisions: 23,
                        label: '$waitHours hours',
                        onChanged: (val) => setState(() => waitHours = val.round()),
                      ),
                    ),
                    Text('$waitHours h'),
                  ],
                ),
                Text('Where do you need to go?', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'e.g., Pharmacy, Grocery Store'),
                  onChanged: (val) => destination = val,
                  validator: (val) => val == null || val.isEmpty ? 'Enter a destination' : null,
                ),
                const SizedBox(height: 16),
                Text('Time Needed', style: Theme.of(context).textTheme.titleLarge),
                Row(
                  children: [
                    Expanded(
                      child: Text(selectedTime == null
                          ? 'No time selected'
                          : selectedTime!.format(context)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: const Text('Select Time'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Max Distance (km)', style: Theme.of(context).textTheme.titleLarge),
                Slider(
                  value: distanceKm,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  label: '${distanceKm.toStringAsFixed(1)} km',
                  onChanged: (val) => setState(() => distanceKm = val),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isUrgent,
                      onChanged: (val) => setState(() => isUrgent = val ?? false),
                    ),
                    const Text('Urgent'),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && selectedTime != null) {
                        // Add a request (for requests list)
                        appState.addRequest(
                          ErrandRequest(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            description: description,
                            distanceKm: distanceKm,
                            isUrgent: isUrgent,
                            requester: 'You',
                            createdAt: DateTime.now(),
                            expiresAt: DateTime.now().add(Duration(hours: waitHours)),
                            status: 'active',
                          ),
                        );
                        // Also add a post (for posts list and expiry logic)
                        appState.addPost(
                          ErrandPost(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            type: 'request',
                            place: destination,
                            item: description,
                            userNickname: appState.currentUser?.name ?? 'You',
                            eta: DateTime.now(),
                            radiusKm: distanceKm,
                            status: 'active',
                            createdAt: DateTime.now(),
                            expiresAt: DateTime.now().add(Duration(hours: waitHours)),
                          ),
                        );
                        Navigator.pop(context, {
                          'description': description,
                          'destination': destination,
                          'selectedTime': selectedTime,
                          'distanceKm': distanceKm,
                          'isUrgent': isUrgent,
                          'waitHours': waitHours,
                        });
                      } else if (selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a time.')));
                      }
                    },
                    child: const Text('Post'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
