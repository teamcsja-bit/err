import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/user_profile.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;

  // Controllers for editing fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController villageController;
  late TextEditingController cityController;
  late TextEditingController pincodeController;
  late TextEditingController bioController;

  // Gender variable
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppState>(context, listen: false).currentUser!;
    _initControllers(user);
    _selectedGender = user.gender.isNotEmpty ? user.gender : null;
  }

  void _initControllers(UserProfile user) {
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    villageController = TextEditingController(text: user.village);
    cityController = TextEditingController(text: user.city);
    pincodeController = TextEditingController(text: user.pincode);
    bioController = TextEditingController(text: user.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    villageController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser!;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.7),
            Color.fromRGBO(255, 192, 203, 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: const Text('Profile & Settings'),
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.2),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(
                        _editing ? Icons.check : Icons.edit,
                        color: Colors.pink,
                    ),
                    onPressed: () {
                      if (_editing) {
                        // Save details
                        appState.updateCurrentUserProfile(
                          name: nameController.text.trim(),
                          village: villageController.text.trim(),
                          city: cityController.text.trim(),
                          pincode: pincodeController.text.trim(),
                          gender: _selectedGender ?? "",
                          phone: phoneController.text.trim(),
                          bio: bioController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile updated")),
                        );
                      }
                      setState(() => _editing = !_editing);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.person, size: 80, color: Colors.pink),
                    const SizedBox(height: 20),

                    _buildField("Name", user.name, nameController),
                    _buildField("Email", user.email, emailController,
                        enabled: false), // Email not editable
                    _buildField("Phone", user.phone, phoneController),
                    _buildField("Village", user.village, villageController),
                    _buildField("City", user.city, cityController),
                    _buildField("Pincode", user.pincode, pincodeController),

                    // Gender Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _editing
                          ? DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: "Gender",
                                border: OutlineInputBorder(),
                              ),
                              items: ["Male", "Female", "Other"]
                                  .map((gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text(gender),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            )
                          : ListTile(
                              title: const Text("Gender",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(user.gender.isNotEmpty
                                  ? user.gender
                                  : "Not set"),
                            ),
                    ),

                    _buildField("Bio", user.bio, bioController, maxLines: 3),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Provider.of<AppState>(context, listen: false)
                            .clearLoggedInUser();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      child: const Text('Logout',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label, String value, TextEditingController controller,
      {bool enabled = true, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _editing
          ? TextField(
              controller: controller,
              enabled: enabled,
              maxLines: maxLines,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            )
          : ListTile(
              title: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(value.isNotEmpty ? value : "Not set"),
            ),
    );
  }
}
